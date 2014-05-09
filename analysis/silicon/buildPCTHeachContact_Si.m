figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize', [16 12])

load('z:\users\Andrew\Whisker Project\Silicon\CTA\CTA_140536_110823.mat')

contactNumbers = 1:15
Snums = 1:148%Snums_L4
for k = 1:length(Snums)
    display(['processing cell # ' num2str(Snums(k))]);
    subplot(10,15,k);hold on
    
       if ~strcmp( S.trialArrayName{Snums(k)}(5:17), T.sessionName(4:16))
        display(['Loading '  S.trialArrayName{Snums(k)}])
    load(['Z:\users\Andrew\Whisker Project\Silicon\ConTA\' S.contactsArrayName{Snums(k)}]);
    load(['Z:\users\Andrew\Whisker Project\Silicon\CTA\' S.trialArrayName{Snums(k)}]);
        [contacts params] = autoContactAnalyzerSi(T, params, contacts, 'recalc');

       end
    

    firstLick = cell(length(T.trials),1);
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    clustInd = find(T.cellNum == S.clust{Snums(k)} & T.shankNum==S.shank{Snums(k)});
    useFlag = find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag,T.trials));
    % Trial Index of All Contact trials
    
        tindGo = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) >= 1 & ...
        cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
    
    tindAll = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) >= 1 & ...
        cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
    tindGo = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 1 | ...
        cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 2 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
    tindNogo = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 | ...
        cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 4 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
    
    [~,indGoAll,~] = intersect(tindAll,tindGo);
    [~,indNogoAll,~] = intersect(tindAll,tindNogo);
    
    spikeTimesAll = cell(numel(tindAll),numel(contactNumbers));
    alignTimesAll = cell(numel(tindAll),numel(contactNumbers));
    conSignAll    = cell(numel(tindAll),numel(contactNumbers));


    
    
    for i = 1:length(tindAll)
        if ~isempty(T.trials{tindAll(i)}.beamBreakTimes)
            firstLick{tindAll(i)} = T.trials{i}.beamBreakTimes(find(T.trials{i}.beamBreakTimes...
                > T.trials{i}.pinDescentOnsetTime + .5,1,'first'));
        end
        for j = contactNumbers
            if size(contacts{tindAll(i)}.segmentInds{1},1)>=j
                if T.trials{tindAll(i)}.whiskerTrial.time{1}(contacts{tindAll(i)}.segmentInds{1}(j,1)) <= min([T.trials{1}.pinDescentOnsetTime+1.5 firstLick{tindAll(i)} T.trials{i}.pinAscentOnsetTime]);
                    spikeTimesAll{i,j} = double(T.trials{tindAll(i)}.shanksTrial.clustData{clustInd}.spikeTimes)/19530-wTTO;
                    alignTimesAll{i,j} = T.trials{tindAll(i)}.whiskerTrial.time{1}(contacts{tindAll(i)}.segmentInds{1}(j,1));               
                    conSignAll{i,j} = sign(contacts{tindAll(i)}.peakM0adj{1}(j));  % Direction of each contact
                end
            end
        end
        
    end
    
    sigma = {};
    conWindow = [.005 .05];
    baseWindow = [-0.05 0];
    S.PCTH.Ind.plotLims{Snums(k)} = [-.05 .05];
    S.PCTH.Ind.binSize{Snums(k)} = .001;
    for j = 1:size(spikeTimesAll,2)
        if length(spikeTimesAll(cellfun(@(x)~isempty(x),alignTimesAll(:,j)),j))>4
            staIn = spikeTimesAll(cellfun(@(x)~isempty(x),alignTimesAll(:,j)),j);
            alnIn = alignTimesAll(cellfun(@(x)~isempty(x),alignTimesAll(:,j)),j);
            conSignIn = conSignAll(cellfun(@(x)~isempty(x),alignTimesAll(:,j)),j);
            spks = nan(numel(alnIn),1);
            for t = 1:numel(alnIn);
                spks(t) = sum(staIn{t} > alnIn{t} + conWindow(1) & staIn{t} < alnIn{t} + conWindow(2));
                basespks(t) = sum(staIn{t} > alnIn{t} + baseWindow(1) & staIn{t} < alnIn{t} + baseWindow(2));       
            end
            prospks = spks([conSignIn{:}]<0);
            retspks = spks([conSignIn{:}]>0);
            probasespks = basespks([conSignIn{:}]<0);
            retbasespks = basespks([conSignIn{:}]>0);
    
            % All contact trials
            
            [S.PCTH.Ind.allCon.lambda{Snums(k),j} S.PCTH.Ind.allCon.lambda95{Snums(k),j}]= poissfit(spks);
            [S.PCTH.Ind.allCon.muhat{Snums(k),j} S.PCTH.Ind.allCon.sigmahat{Snums(k),j}] = normfit(spks);
            [S.PCTH.Ind.allCon.baseline.lambda{Snums(k),j} S.PCTH.Ind.allCon.baseline.lambda95{Snums(k),j}]= poissfit(basespks);
            [S.PCTH.Ind.allCon.baseline.muhat{Snums(k),j} S.PCTH.Ind.allCon.baseline.sigmahat{Snums(k),j}] = normfit(basespks);
            S.PCTH.Ind.allCon.numT{Snums(k),j} = length(staIn);
            S.PCTH.Ind.allCon.Hist{Snums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            S.PCTH.Ind.allCon.z{Snums(k),j} = bsxfun(@minus,S.PCTH.Ind.allCon.Hist{Snums(k),j}, S.PCTH.Ind.allCon.baseline.muhat{Snums(k),1});
            S.PCTH.Ind.allCon.z{Snums(k),j} = bsxfun(@rdivide, S.PCTH.Ind.allCon.z{Snums(k),j}, S.PCTH.Ind.allCon.baseline.sigmahat{Snums(k),j});

            % Protraction contacts only, all positions
            
            [S.PCTH.Ind.proCon.lambda{Snums(k),j} S.PCTH.Ind.proCon.lambda95{Snums(k),j}]= poissfit(prospks);
            [S.PCTH.Ind.proCon.muhat{Snums(k),j} S.PCTH.Ind.proCon.sigmahat{Snums(k),j}] = normfit(prospks);
            [S.PCTH.Ind.proCon.baseline.lambda{Snums(k),j} S.PCTH.Ind.proCon.baseline.lambda95{Snums(k),j}]= poissfit(probasespks);
            [S.PCTH.Ind.proCon.baseline.muhat{Snums(k),j} S.PCTH.Ind.proCon.baseline.sigmahat{Snums(k),j}] = normfit(probasespks);
            S.PCTH.Ind.proCon.numT{Snums(k),j} = length(prospks);
            S.PCTH.Ind.proCon.Hist{Snums(k),j} = plotHist(staIn([conSignIn{:}]<0), alnIn([conSignIn{:}]<0),.001,[-.05 .05],'k');
            S.PCTH.Ind.proCon.z{Snums(k),j} = bsxfun(@minus,S.PCTH.Ind.proCon.Hist{Snums(k),j}, S.PCTH.Ind.proCon.baseline.muhat{Snums(k),1});
            S.PCTH.Ind.proCon.z{Snums(k),j} = bsxfun(@rdivide, S.PCTH.Ind.proCon.z{Snums(k),j}, S.PCTH.Ind.proCon.baseline.sigmahat{Snums(k),j});
   
            % Retraction contacts only, all positions

            [S.PCTH.Ind.retCon.lambda{Snums(k),j} S.PCTH.Ind.retCon.lambda95{Snums(k),j}]= poissfit(retspks);
            [S.PCTH.Ind.retCon.muhat{Snums(k),j} S.PCTH.Ind.retCon.sigmahat{Snums(k),j}] = normfit(retspks);
            [S.PCTH.Ind.retCon.baseline.lambda{Snums(k),j} S.PCTH.Ind.retCon.baseline.lambda95{Snums(k),j}]= poissfit(retbasespks);
            [S.PCTH.Ind.retCon.baseline.muhat{Snums(k),j} S.PCTH.Ind.retCon.baseline.sigmahat{Snums(k),j}] = normfit(retbasespks);
            S.PCTH.Ind.retCon.numT{Snums(k),j} = length(retspks);
            S.PCTH.Ind.retCon.Hist{Snums(k),j} = plotHist(staIn([conSignIn{:}]>0), alnIn([conSignIn{:}]>0),.001,[-.05 .05],'k');
            S.PCTH.Ind.retCon.z{Snums(k),j} = bsxfun(@minus,S.PCTH.Ind.retCon.Hist{Snums(k),j}, S.PCTH.Ind.retCon.baseline.muhat{Snums(k),1});
            S.PCTH.Ind.retCon.z{Snums(k),j} = bsxfun(@rdivide, S.PCTH.Ind.retCon.z{Snums(k),j}, S.PCTH.Ind.retCon.baseline.sigmahat{Snums(k),j});
          end
    end
    sigma = {};
    for j = 1:size(spikeTimesAll,2)
        if length(spikeTimesAll(indGoAll(cellfun(@(x)~isempty(x),alignTimesAll(indGoAll,j))),j))>4
            staIn = spikeTimesAll(indGoAll(cellfun(@(x)~isempty(x),alignTimesAll(indGoAll,j))),j);
            alnIn = alignTimesAll(indGoAll(cellfun(@(x)~isempty(x),alignTimesAll(indGoAll,j))),j);
            spks = nan(numel(alnIn),1);
            for t = 1:numel(alnIn);
                spks(t) = sum(staIn{t} > alnIn{t} + conWindow(1) & staIn{t} < alnIn{t} + conWindow(2));
                basespks(t) = sum(staIn{t} > alnIn{t} + baseWindow(1) & staIn{t} < alnIn{t} + baseWindow(2));
                
            end
            spks = spks(~isnan(spks));
            [S.PCTH.Ind.goCon.lambda{Snums(k),j} S.PCTH.Ind.goCon.lambda95{Snums(k),j}]= poissfit(spks);
            [S.PCTH.Ind.goCon.muhat{Snums(k),j} S.PCTH.Ind.goCon.sigmahat{Snums(k),j}] = normfit(spks);
            [S.PCTH.Ind.goCon.baseline.lambda{Snums(k),j} S.PCTH.Ind.goCon.baseline.lambda95{Snums(k),j}]= poissfit(basespks);
            [S.PCTH.Ind.goCon.baseline.muhat{Snums(k),j} S.PCTH.Ind.goCon.baseline.sigmahat{Snums(k),j}] = normfit(basespks);
            S.PCTH.Ind.goCon.numT{Snums(k),j} = length(staIn);
            S.PCTH.Ind.goCon.Hist{Snums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            S.PCTH.Ind.goCon.z{Snums(k),j} = bsxfun(@minus,S.PCTH.Ind.goCon.Hist{Snums(k),j}, S.PCTH.Ind.goCon.baseline.muhat{Snums(k),1});
            S.PCTH.Ind.goCon.z{Snums(k),j} = bsxfun(@rdivide, S.PCTH.Ind.goCon.z{Snums(k),j}, S.PCTH.Ind.goCon.baseline.sigmahat{Snums(k),j});
        end
    end
    sigma = {};
    for j = 1:size(spikeTimesAll,2)
        if length(spikeTimesAll(indNogoAll(cellfun(@(x)~isempty(x),alignTimesAll(indNogoAll,j))),j))>4
            staIn = spikeTimesAll(indNogoAll(cellfun(@(x)~isempty(x),alignTimesAll(indNogoAll,j))),j);
            alnIn = alignTimesAll(indNogoAll(cellfun(@(x)~isempty(x),alignTimesAll(indNogoAll,j))),j);
            spks = nan(numel(alnIn),1);
            for t = 1:numel(alnIn);
                spks(t) = sum(staIn{t} > alnIn{t} + conWindow(1) & staIn{t} < alnIn{t} + conWindow(2));
                basespks(t) = sum(staIn{t} > alnIn{t} + baseWindow(1) & staIn{t} < alnIn{t} + baseWindow(2));
            end
            spks = spks(~isnan(spks));
            
            [S.PCTH.Ind.nogoCon.lambda{Snums(k),j} S.PCTH.Ind.nogoCon.lambda95{Snums(k),j}]= poissfit(spks);
            [S.PCTH.Ind.nogoCon.muhat{Snums(k),j} S.PCTH.Ind.nogoCon.sigmahat{Snums(k),j}] = normfit(spks);
            [S.PCTH.Ind.nogoCon.baseline.lambda{Snums(k),j} S.PCTH.Ind.nogoCon.baseline.lambda95{Snums(k),j}]= poissfit(basespks);
            [S.PCTH.Ind.nogoCon.baseline.muhat{Snums(k),j} S.PCTH.Ind.nogoCon.baseline.sigmahat{Snums(k),j}] = normfit(basespks);
            
            S.PCTH.Ind.nogoCon.numT{Snums(k),j} = length(staIn);
            S.PCTH.Ind.nogoCon.Hist{Snums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            S.PCTH.Ind.nogoCon.z{Snums(k),j} = bsxfun(@minus,S.PCTH.Ind.nogoCon.Hist{Snums(k),j}, S.PCTH.Ind.nogoCon.baseline.muhat{Snums(k),1});
            S.PCTH.Ind.nogoCon.z{Snums(k),j} = bsxfun(@rdivide, S.PCTH.Ind.nogoCon.z{Snums(k),j}, S.PCTH.Ind.nogoCon.baseline.sigmahat{Snums(k),j});
            
        end
    end
    
end
%print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PCTHforDan_nonC2_con25.eps')
%%
for i = 1:52
    for j = find(cellfun(@(x)~isempty(x),S.PCTH.Ind.allCon.Hist(i,:)));
        spikesAddedAll{i}(j)  = (mean(S.PCTH.Ind.allCon.Hist{i,j}(56:101))  - S.PCTH.Ind.allCon.mu{i,1})*.045;
        spikesAddedGo{i}(j)   = (mean(S.PCTH.Ind.goCon.Hist{i,j}(56:101))   - S.PCTH.Ind.allCon.mu{i,1})*.045;
        spikesAddedNogo{i}(j) = (mean(S.PCTH.Ind.nogoCon.Hist{i,j}(56:101)) - S.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedAll{i}(j)  = (std(S.PCTH.Ind.allCon.Hist{i,j}(56:101))  - S.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedGo{i}(j)   = (mean(S.PCTH.Ind.goCon.Hist{i,j}(56:101))   - S.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedNogo{i}(j) = (mean(S.PCTH.Ind.NogoCon.Hist{i,j}(56:101)) - S.PCTH.Ind.allCon.mu{i,1})*.045;
        
        
    end
end

% figure(1);clf;
% for i = 1:length(S.PCTH.sharpTouchCells)
%     
%     subplot(4,4,i);hold on
%     plot(spikesAddedAll{S.PCTH.sharpTouchCells(i)},'-ok','markersize',3);
%     plot(spikesAddedNogo{S.PCTH.sharpTouchCells(i)},'-or','markersize',3);
%     
%     plot(spikesAddedGo{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
%     
%     plot([0 15],[0 0],'k')
% end

figure(1);clf;
plotidx = 1
for i = Snums_L4
    
    subplot(4,4,plotidx);hold on
    plotidx = plotidx + 1
    ci = [S.PCTH.Ind.allCon.lambda95{i,:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
    plot([0 10], repmat(S.PCTH.Ind.allCon.mu{i,1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
        plot([S.PCTH.Ind.allCon.lambda{i,:}],'k.-')

    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end
figure(5);clf;
plotidx = 1
for i = Snums_L4
    
    subplot(4,4,plotidx);hold on
    plotidx = plotidx + 1
    bar(-50:50,S.PCTH.Ind.allCon.Hist{i})
    set(gca,'xlim',[-50 50])
end

    
    
figure(2);clf;
for i = 1:length(S.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [S.PCTH.Ind.goCon.lambda95{S.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'b','edgecolor','none')
    ci = [S.PCTH.Ind.nogoCon.lambda95{S.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))

    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'r','edgecolor','none')

 %   plot([S.PCTH.Ind.allCon.lambda{S.PCTH.sharpTouchCells(i),:}],'k-')
    plot([S.PCTH.Ind.goCon.lambda{S.PCTH.sharpTouchCells(i),:}],'b.-')
    plot([S.PCTH.Ind.nogoCon.lambda{S.PCTH.sharpTouchCells(i),:}],'r.-')
    plot([0 10], repmat(S.PCTH.Ind.allCon.mu{S.PCTH.sharpTouchCells(i),1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end

figure(3);clf;
for i = 1:length(S.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [S.PCTH.Ind.proCon.lambda95{S.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'c','edgecolor','none')
    ci = [S.PCTH.Ind.retCon.lambda95{S.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))

    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'m','edgecolor','none')

 %   plot([S.PCTH.Ind.allCon.lambda{S.PCTH.sharpTouchCells(i),:}],'k-')
    plot([S.PCTH.Ind.proCon.lambda{S.PCTH.sharpTouchCells(i),:}],'c.-')
    plot([S.PCTH.Ind.retCon.lambda{S.PCTH.sharpTouchCells(i),:}],'m.-')
    plot([0 10], repmat(S.PCTH.Ind.allCon.mu{S.PCTH.sharpTouchCells(i),1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end

% Added spikes per contact
figure(4);clf;
for i = 1:length(S.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [S.PCTH.Ind.allCon.lambda95{S.PCTH.sharpTouchCells(i),:}]-S.PCTH.Ind.allCon.baseline.lambda{S.PCTH.sharpTouchCells(i),1} ;
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
        plot([S.PCTH.Ind.allCon.lambda{S.PCTH.sharpTouchCells(i),:}]-S.PCTH.Ind.allCon.baseline.lambda{S.PCTH.sharpTouchCells(i),1},'k.-')

    axis
    set(gca,'xlim',[1 6])
    set(gcf,'name','Added spikes per contact')
     % figure(2);clf
    % plot(spikesAdded{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end
