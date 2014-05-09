
S_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
S_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\')

figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize', [16 12])
% figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 4 4],'PaperSize', [4 4]);hold on

Snums_L23 = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) < .418 ));
Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588));
Snums_L56 = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .588));

Snums_Lall = find([S.dist{:}] > .250);
Snums= Snums_L4;
load('z:\users\Andrew\Whisker Project\Silicon\CTA\CTA_140536_110823.mat')
contactNumbers = 1:15;
[~, depthOrder] = sort(cellfun(@(x)x(3),S.recordingLocation(Snums))); 
Snums = 1:148
for k = 1:length(Snums)
    %subplot(5,6,k);hold on
    
       % Open next array if current array does not match name in summary
    if ~strcmp( S.trialArrayName{Snums(k)}(5:17), T.sessionName(4:16))
        display(['Loading '  S.trialArrayName{Snums(k)}])
        load([Si_TDir S.trialArrayName{Snums(k)}])
        load([Si_ConDir S.contactsArrayName{Snums(k)}]);
    end
    
    % Find cluster index for this cell and session
     clustInd = find(T.cellNum == S.clust{Snums(k)} & T.shankNum==S.shank{Snums(k)});
    % Trial Index of All Contact trials
    useFlag = find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag,T.trials));

    tindHit  = intersect(find(T.hitTrialInds & T.whiskerTrialInds),useFlag);
    tindMiss = intersect(find(T.missTrialInds & T.whiskerTrialInds),useFlag);
    tindFA   = intersect(find(T.falseAlarmTrialInds & T.whiskerTrialInds),useFlag);
    tindCR   = intersect(find(T.correctRejectionTrialInds & T.whiskerTrialInds),useFlag);
    
    % Crop timeframe to relevant one
    cropInd = {};
    cropSpikes = {};
    
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindGo = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) >= 1 & ...
        cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
     tindNogo = intersect(useFlag,whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 & ...
         cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN))));
%     
    spikeTimesGo = {};
    alignTimesGo = {};
    spikeTimesNogo = {};
    alignTimesNogo = {};
    
        firstLick = cell(length(T.trials),1);

    
    for i = 1:length(tindGo)
        for j = contactNumbers
            if size(contacts{tindGo(i)}.segmentInds{1},1)>=j
                if T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1)) <= min([firstLick{tindGo(i)} 2]);
                    spikeTimesGo{i,j} = double(T.trials{tindGo(i)}.shanksTrial.clustData{clustInd}.spikeTimes)/19530-wTTO;
                    alignTimesGo{i,j} = T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1));
                end
                
            end
        end
    end
    
%     for i = 1:length(tindNogo)
%         for j = contactNumbers
%             if size(contacts{tindNogo(i)}.segmentInds{1},1)>=j
%                 if T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1)) <= min([firstLick{tindNogo(i)} 2]);
%                     
%                     spikeTimesNogo{i,j} = double(T.trials{tindNogo(i)}.shanksTrial.clustData{clustInd}.spikeTimes)/19530-wTTO;
%                     alignTimesNogo{i,j} = T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1));
%                 end
%             end
%         end
%         
%     end
    spikeTimesGo = spikeTimesGo(cellfun(@(x)~isempty(x),spikeTimesGo));
    alignTimesGo = alignTimesGo(cellfun(@(x)~isempty(x),alignTimesGo));
%     spikeTimesNogo = spikeTimesNogo(cellfun(@(x)~isempty(x),spikeTimesNogo));
%     alignTimesNogo = alignTimesNogo(cellfun(@(x)~isempty(x),alignTimesNogo));
    
    
%     plotHist(spikeTimesNogo, alignTimesNogo,.001,[-.02 .05],'r')
    S.PCTH.Con210.plotLims{k} = [-.05 .05];
    S.PCTH.Con210.binSize{k} = .001;
    S.PCTH.Con210.allHist{k} = plotHist(spikeTimesGo, alignTimesGo,.001,[-.05 .05],'k');
    
%     h = findobj(gca,'Type','patch');
%     set(h,'linewidth',.25,'facealpha',0.25)
%     title([num2str(S.recordingLocation{Snums(k)}(3)) ' ' S.filename{Snums(k)}(1:17) ' ' num2str(S.shank{Snums(k)}) '-' num2str(S.clust{Snums(k)})  ])
%     
    S.PCTH.Con210.mu{k} = mean(S.PCTH.Con210.allHist{k}(1:50));
    sigma{k} = std(S.PCTH.Con210.allHist{k}(1:50));
    S.PCTH.Con210.sigma0{k} = sigma{k};
    S.PCTH.Con210.sigma0{k}(S.PCTH.Con210.sigma0{k}==0) = 1;
    S.PCTH.Con210.z{k} = bsxfun(@minus,S.PCTH.Con210.allHist{k}, S.PCTH.Con210.mu{k});
    S.PCTH.Con210.z{k} = bsxfun(@rdivide, S.PCTH.Con210.z{k}, S.PCTH.Con210.sigma0{k});
    
end
%print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Silicon\Figures\PCTHforDan_L4C2_AllCon210.eps')
%%
figure(4);clf

zedges          = -.05:.001:.050;


% for k = 1:148
%     tmpHist{k} = mean(reshape(S.PCTH.Con210.allHist{k}(1:100),2,50))
% end
% 
% 
% for k = 1:148
%     tmu{k} = mean(tmpHist{k}(1:25));
%     sigma{k} = std(tmpHist{k}(1:25));
%     tsigma0{k} = sigma{k};
%     tsigma0{k}(tsigma0{k}==0) = 1;
%     tz{k} = bsxfun(@minus,tmpHist{k}, tmu{k});
%     tz{k} = bsxfun(@rdivide, tz{k}, tsigma0{k});
%     
% end


S.PCTH.Con210.sharpTouchCells = find(cellfun(@(x)sum(x(54:75)>4),S.PCTH.Con210.z)>=2)
figure(5);clf

for k=1:length(S.PCTH.Con210.sharpTouchCells)
 subplot(4,8,k);hold on

bar(zedges+.001/2,S.PCTH.Con210.z{S.PCTH.Con210.sharpTouchCells(k)},'k','edgecolor','k')
plot([-.05 .05],[4 4],'r-')
plot([-.05 .05],[3 3],'b-')
set(gca,'Xlim',[-0.05 .05])
title(num2str(S.PCTH.Con210.sharpTouchCells(k)));
end
figure(6);clf

for k=1:length(S.PCTH.Con210.sharpTouchCells)
 subplot(4,8,k);hold on

bar(zedges+.001/2,S.PCTH.Con210.allHist{S.PCTH.Con210.sharpTouchCells(k)},'k','edgecolor','k')
plot([-.05 .05],[4 4],'r-')
plot([-.05 .05],[3 3],'b-')
set(gca,'Xlim',[-0.05 .05])
title(num2str(S.PCTH.Con210.sharpTouchCells(k)));
end