figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize', [16 12])

SUnums_L23 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))
SUnums_L56 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.588))

SUnums_Lall = find([SU.distance{:}] > .250);
SUnums= SUnums_L4

contactNumbers = 1:15
[~, depthOrder] = sort(cellfun(@(x)-x(3),SU.recordingLocation(SUnums)))
SUnums = 1:52%SUnums_L4
for k = 1:length(SUnums)
    display(['processing cell # ' num2str(SUnums(k))]);
    subplot(6,9,k);hold on
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\' SU.contactsArrayName{SUnums(k)}]);
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\' SU.trialArrayName{SUnums(k)}]);
    [contacts params] = autoContactAnalyzerSi(T, params, contacts, 'recalc');
    
    firstLick = cell(length(T.trials),1);
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindAll  = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) >= 1 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    tindGo   = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 1 | cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 2 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    tindNogo = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 | cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 4 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    
    
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
                    spikeTimesAll{i,j} = double(T.trials{tindAll(i)}.spikesTrial.spikeTimes)/10000-wTTO;
                    alignTimesAll{i,j} = T.trials{tindAll(i)}.whiskerTrial.time{1}(contacts{tindAll(i)}.segmentInds{1}(j,1));
                    conSignAll{i,j} = sign(contacts{tindAll(i)}.peakM0adj{1}(j));  % Direction of each contact
                end
            end
        end
        
    end
    
    sigma = {};
    conWindow = [.005 .05];
    baseWindow = [-0.05 0];
    SU.PCTH.Ind.plotLims{SUnums(k)} = [-.05 .05];
    SU.PCTH.Ind.binSize{SUnums(k)} = .001;
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
            
            [SU.PCTH.Ind.allCon.lambda{SUnums(k),j} SU.PCTH.Ind.allCon.lambda95{SUnums(k),j}]= poissfit(spks);
            [SU.PCTH.Ind.allCon.muhat{SUnums(k),j} SU.PCTH.Ind.allCon.sigmahat{SUnums(k),j}] = normfit(spks);
            [SU.PCTH.Ind.allCon.baseline.lambda{SUnums(k),j} SU.PCTH.Ind.allCon.baseline.lambda95{SUnums(k),j}]= poissfit(basespks);
            [SU.PCTH.Ind.allCon.baseline.muhat{SUnums(k),j} SU.PCTH.Ind.allCon.baseline.sigmahat{SUnums(k),j}] = normfit(basespks);
            SU.PCTH.Ind.allCon.numT{SUnums(k),j} = length(staIn);
            SU.PCTH.Ind.allCon.Hist{SUnums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            SU.PCTH.Ind.allCon.z{SUnums(k),j} = bsxfun(@minus,SU.PCTH.Ind.allCon.Hist{SUnums(k),j}, SU.PCTH.Ind.allCon.baseline.muhat{SUnums(k),1});
            SU.PCTH.Ind.allCon.z{SUnums(k),j} = bsxfun(@rdivide, SU.PCTH.Ind.allCon.z{SUnums(k),j}, SU.PCTH.Ind.allCon.baseline.sigmahat{SUnums(k),j});

            % Protraction contacts only, all positions
            
            [SU.PCTH.Ind.proCon.lambda{SUnums(k),j} SU.PCTH.Ind.proCon.lambda95{SUnums(k),j}]= poissfit(prospks);
            [SU.PCTH.Ind.proCon.muhat{SUnums(k),j} SU.PCTH.Ind.proCon.sigmahat{SUnums(k),j}] = normfit(prospks);
            [SU.PCTH.Ind.proCon.baseline.lambda{SUnums(k),j} SU.PCTH.Ind.proCon.baseline.lambda95{SUnums(k),j}]= poissfit(probasespks);
            [SU.PCTH.Ind.proCon.baseline.muhat{SUnums(k),j} SU.PCTH.Ind.proCon.baseline.sigmahat{SUnums(k),j}] = normfit(probasespks);
            SU.PCTH.Ind.proCon.numT{SUnums(k),j} = length(prospks);
            SU.PCTH.Ind.proCon.Hist{SUnums(k),j} = plotHist(staIn([conSignIn{:}]<0), alnIn([conSignIn{:}]<0),.001,[-.05 .05],'k');
            SU.PCTH.Ind.proCon.z{SUnums(k),j} = bsxfun(@minus,SU.PCTH.Ind.proCon.Hist{SUnums(k),j}, SU.PCTH.Ind.proCon.baseline.muhat{SUnums(k),1});
            SU.PCTH.Ind.proCon.z{SUnums(k),j} = bsxfun(@rdivide, SU.PCTH.Ind.proCon.z{SUnums(k),j}, SU.PCTH.Ind.proCon.baseline.sigmahat{SUnums(k),j});
   
            % Retraction contacts only, all positions

            [SU.PCTH.Ind.retCon.lambda{SUnums(k),j} SU.PCTH.Ind.retCon.lambda95{SUnums(k),j}]= poissfit(retspks);
            [SU.PCTH.Ind.retCon.muhat{SUnums(k),j} SU.PCTH.Ind.retCon.sigmahat{SUnums(k),j}] = normfit(retspks);
            [SU.PCTH.Ind.retCon.baseline.lambda{SUnums(k),j} SU.PCTH.Ind.retCon.baseline.lambda95{SUnums(k),j}]= poissfit(retbasespks);
            [SU.PCTH.Ind.retCon.baseline.muhat{SUnums(k),j} SU.PCTH.Ind.retCon.baseline.sigmahat{SUnums(k),j}] = normfit(retbasespks);
            SU.PCTH.Ind.retCon.numT{SUnums(k),j} = length(retspks);
            SU.PCTH.Ind.retCon.Hist{SUnums(k),j} = plotHist(staIn([conSignIn{:}]>0), alnIn([conSignIn{:}]>0),.001,[-.05 .05],'k');
            SU.PCTH.Ind.retCon.z{SUnums(k),j} = bsxfun(@minus,SU.PCTH.Ind.retCon.Hist{SUnums(k),j}, SU.PCTH.Ind.retCon.baseline.muhat{SUnums(k),1});
            SU.PCTH.Ind.retCon.z{SUnums(k),j} = bsxfun(@rdivide, SU.PCTH.Ind.retCon.z{SUnums(k),j}, SU.PCTH.Ind.retCon.baseline.sigmahat{SUnums(k),j});
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
            [SU.PCTH.Ind.goCon.lambda{SUnums(k),j} SU.PCTH.Ind.goCon.lambda95{SUnums(k),j}]= poissfit(spks);
            [SU.PCTH.Ind.goCon.muhat{SUnums(k),j} SU.PCTH.Ind.goCon.sigmahat{SUnums(k),j}] = normfit(spks);
            [SU.PCTH.Ind.goCon.baseline.lambda{SUnums(k),j} SU.PCTH.Ind.goCon.baseline.lambda95{SUnums(k),j}]= poissfit(basespks);
            [SU.PCTH.Ind.goCon.baseline.muhat{SUnums(k),j} SU.PCTH.Ind.goCon.baseline.sigmahat{SUnums(k),j}] = normfit(basespks);
            SU.PCTH.Ind.goCon.numT{SUnums(k),j} = length(staIn);
            SU.PCTH.Ind.goCon.Hist{SUnums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            SU.PCTH.Ind.goCon.z{SUnums(k),j} = bsxfun(@minus,SU.PCTH.Ind.goCon.Hist{SUnums(k),j}, SU.PCTH.Ind.goCon.baseline.muhat{SUnums(k),1});
            SU.PCTH.Ind.goCon.z{SUnums(k),j} = bsxfun(@rdivide, SU.PCTH.Ind.goCon.z{SUnums(k),j}, SU.PCTH.Ind.goCon.baseline.sigmahat{SUnums(k),j});
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
            
            [SU.PCTH.Ind.nogoCon.lambda{SUnums(k),j} SU.PCTH.Ind.nogoCon.lambda95{SUnums(k),j}]= poissfit(spks);
            [SU.PCTH.Ind.nogoCon.muhat{SUnums(k),j} SU.PCTH.Ind.nogoCon.sigmahat{SUnums(k),j}] = normfit(spks);
            [SU.PCTH.Ind.nogoCon.baseline.lambda{SUnums(k),j} SU.PCTH.Ind.nogoCon.baseline.lambda95{SUnums(k),j}]= poissfit(basespks);
            [SU.PCTH.Ind.nogoCon.baseline.muhat{SUnums(k),j} SU.PCTH.Ind.nogoCon.baseline.sigmahat{SUnums(k),j}] = normfit(basespks);
            
            SU.PCTH.Ind.nogoCon.numT{SUnums(k),j} = length(staIn);
            SU.PCTH.Ind.nogoCon.Hist{SUnums(k),j} = plotHist(staIn, alnIn,.001,[-.05 .05],'k');
            SU.PCTH.Ind.nogoCon.z{SUnums(k),j} = bsxfun(@minus,SU.PCTH.Ind.nogoCon.Hist{SUnums(k),j}, SU.PCTH.Ind.nogoCon.baseline.muhat{SUnums(k),1});
            SU.PCTH.Ind.nogoCon.z{SUnums(k),j} = bsxfun(@rdivide, SU.PCTH.Ind.nogoCon.z{SUnums(k),j}, SU.PCTH.Ind.nogoCon.baseline.sigmahat{SUnums(k),j});
            
        end
    end
    
end
%print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PCTHforDan_nonC2_con25.eps')
%%
for i = 1:52
    for j = find(cellfun(@(x)~isempty(x),SU.PCTH.Ind.allCon.Hist(i,:)));
        spikesAddedAll{i}(j)  = (mean(SU.PCTH.Ind.allCon.Hist{i,j}(56:101))  - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        spikesAddedGo{i}(j)   = (mean(SU.PCTH.Ind.goCon.Hist{i,j}(56:101))   - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        spikesAddedNogo{i}(j) = (mean(SU.PCTH.Ind.nogoCon.Hist{i,j}(56:101)) - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedAll{i}(j)  = (std(SU.PCTH.Ind.allCon.Hist{i,j}(56:101))  - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedGo{i}(j)   = (mean(SU.PCTH.Ind.goCon.Hist{i,j}(56:101))   - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        %     stdAddedNogo{i}(j) = (mean(SU.PCTH.Ind.NogoCon.Hist{i,j}(56:101)) - SU.PCTH.Ind.allCon.mu{i,1})*.045;
        
        
    end
end

% figure(1);clf;
% for i = 1:length(SU.PCTH.sharpTouchCells)
%     
%     subplot(4,4,i);hold on
%     plot(spikesAddedAll{SU.PCTH.sharpTouchCells(i)},'-ok','markersize',3);
%     plot(spikesAddedNogo{SU.PCTH.sharpTouchCells(i)},'-or','markersize',3);
%     
%     plot(spikesAddedGo{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
%     
%     plot([0 15],[0 0],'k')
% end

figure(1);clf;
plotidx = 1
for i = SUnums_L4
    
    subplot(4,4,plotidx);hold on
    plotidx = plotidx + 1
    ci = [SU.PCTH.Ind.allCon.lambda95{i,:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
    plot([0 10], repmat(SU.PCTH.Ind.allCon.mu{i,1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
        plot([SU.PCTH.Ind.allCon.lambda{i,:}],'k.-')

    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end
figure(5);clf;
plotidx = 1
for i = SUnums_L4
    
    subplot(4,4,plotidx);hold on
    plotidx = plotidx + 1
    bar(-50:50,SU.PCTH.Ind.allCon.Hist{i})
    set(gca,'xlim',[-50 50])
end

    
    
figure(2);clf;
for i = 1:length(SU.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [SU.PCTH.Ind.goCon.lambda95{SU.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'b','edgecolor','none')
    ci = [SU.PCTH.Ind.nogoCon.lambda95{SU.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))

    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'r','edgecolor','none')

 %   plot([SU.PCTH.Ind.allCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'k-')
    plot([SU.PCTH.Ind.goCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'b.-')
    plot([SU.PCTH.Ind.nogoCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'r.-')
    plot([0 10], repmat(SU.PCTH.Ind.allCon.mu{SU.PCTH.sharpTouchCells(i),1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end

figure(3);clf;
for i = 1:length(SU.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [SU.PCTH.Ind.proCon.lambda95{SU.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'c','edgecolor','none')
    ci = [SU.PCTH.Ind.retCon.lambda95{SU.PCTH.sharpTouchCells(i),:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))

    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'m','edgecolor','none')

 %   plot([SU.PCTH.Ind.allCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'k-')
    plot([SU.PCTH.Ind.proCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'c.-')
    plot([SU.PCTH.Ind.retCon.lambda{SU.PCTH.sharpTouchCells(i),:}],'m.-')
    plot([0 10], repmat(SU.PCTH.Ind.allCon.mu{SU.PCTH.sharpTouchCells(i),1}*.045,1,2),'k--')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    axis
    set(gca,'xlim',[1 6])
    % figure(2);clf
    % plot(spikesAdded{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end

% Added spikes per contact
figure(4);clf;
for i = 1:length(SU.PCTH.sharpTouchCells)
    subplot(4,4,i);hold on
    ci = [SU.PCTH.Ind.allCon.lambda95{SU.PCTH.sharpTouchCells(i),:}]-SU.PCTH.Ind.allCon.baseline.lambda{SU.PCTH.sharpTouchCells(i),1} ;
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
                h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
        plot([SU.PCTH.Ind.allCon.lambda{SU.PCTH.sharpTouchCells(i),:}]-SU.PCTH.Ind.allCon.baseline.lambda{SU.PCTH.sharpTouchCells(i),1},'k.-')

    axis
    set(gca,'xlim',[1 6])
    set(gcf,'name','Added spikes per contact')
     % figure(2);clf
    % plot(spikesAdded{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end
