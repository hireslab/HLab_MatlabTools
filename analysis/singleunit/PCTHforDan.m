figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize', [16 12])

SUnums_L23 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))
SUnums_L56 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.588))

SUnums_Lall = find([SU.distance{:}] > .250);
SUnums= SUnums_L4

contactNumbers = 2:10
[~, depthOrder] = sort(cellfun(@(x)-x(3),SU.recordingLocation(SUnums))) 
SUnums = [1:52];%SUnums(depthOrder)
for k = 1:length(SUnums)
    subplot(6,9,k);hold on
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\' SU.contactsArrayName{SUnums(k)}]);
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\' SU.trialArrayName{SUnums(k)}]);
    
    firstLick = cell(length(T.trials),1);

    
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindGo = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) >= 1 | cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    tindNogo = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    
    spikeTimesGo = {};
    alignTimesGo = {};
    spikeTimesNogo = {};
    alignTimesNogo = {};
    
    for i = 1:length(tindGo)
        if ~isempty(T.trials{tindGo(i)}.beamBreakTimes)
    firstLick{tindGo(i)} = T.trials{i}.beamBreakTimes(find(T.trials{i}.beamBreakTimes > T.trials{i}.pinDescentOnsetTime + .5,1,'first'));
        end
        
        for j = contactNumbers
            if size(contacts{tindGo(i)}.segmentInds{1},1)>=j
                if T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1)) <= min([firstLick{tindGo(i)} 2]);
                    spikeTimesGo{i,j} = double(T.trials{tindGo(i)}.spikesTrial.spikeTimes)/10000-wTTO;
                    alignTimesGo{i,j} = T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1));
                end
                
            end
        end
    end
    
%     for i = 1:length(tindNogo)
%              if ~isempty(T.trials{tindNogo(i)}.beamBreakTimes)
%     firstLick{tindNogo(i)} = T.trials{i}.beamBreakTimes(find(T.trials{i}.beamBreakTimes > T.trials{i}.pinDescentOnsetTime + .5,1,'first'));
%         end
%         for j = contactNumbers
%             if size(contacts{tindNogo(i)}.segmentInds{1},1)>=j
%                 if T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1)) <= min([1.5 firstLick{tindNogo(i)} T.trials{i}.pinAscentOnsetTime]);
%                     
%                     spikeTimesNogo{i,j} = double(T.trials{tindNogo(i)}.spikesTrial.spikeTimes)/10000-wTTO;
%                     alignTimesNogo{i,j} = T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1));
%                 end
%             end
%         end
%         
%     end
    spikeTimesGo = spikeTimesGo(cellfun(@(x)~isempty(x),spikeTimesGo))
    alignTimesGo = alignTimesGo(cellfun(@(x)~isempty(x),alignTimesGo))
%     spikeTimesNogo = spikeTimesNogo(cellfun(@(x)~isempty(x),spikeTimesNogo))
%     alignTimesNogo = alignTimesNogo(cellfun(@(x)~isempty(x),alignTimesNogo))
    
    SU.PCTH.Con210.plotLims{SUnums(k)} = [-.05 .05];
    SU.PCTH.Con210.binSize{SUnums(k)} = .001;
    SU.PCTH.Con210.allHist{SUnums(k)} = plotHist(spikeTimesGo, alignTimesGo,.001,[-.05 .05],'k');
    
%     h = findobj(gca,'Type','patch');
%     set(h,'linewidth',.25,'facealpha',0.25)
%     title([num2str(S.recordingLocation{Snums(k)}(3)) ' ' S.filename{Snums(k)}(1:17) ' ' num2str(S.shank{Snums(k)}) '-' num2str(S.clust{Snums(k)})  ])
%     
    SU.PCTH.Con210.mu{SUnums(k)} = mean(SU.PCTH.Con210.allHist{SUnums(k)}(1:50));
    sigma{SUnums(k)} = std(SU.PCTH.Con210.allHist{SUnums(k)}(1:50));
    SU.PCTH.Con210.sigma0{SUnums(k)} = sigma{SUnums(k)};
    SU.PCTH.Con210.sigma0{SUnums(k)}(SU.PCTH.Con210.sigma0{SUnums(k)}==0) = 1;
    SU.PCTH.Con210.z{SUnums(k)} = bsxfun(@minus,SU.PCTH.Con210.allHist{SUnums(k)}, SU.PCTH.Con210.mu{SUnums(k)});
    SU.PCTH.Con210.z{SUnums(k)} = bsxfun(@rdivide, SU.PCTH.Con210.z{SUnums(k)}, SU.PCTH.Con210.sigma0{SUnums(k)});
    
%     plotHist(spikeTimesNogo, alignTimesNogo,.002,[-.02 .05],'r')
%     plotHist(spikeTimesGo, alignTimesGo,.002,[-.02 .05],'b')
%     
    h = findobj(gca,'Type','patch');
    set(h,'linewidth',.25,'facealpha',0.25)
    title([num2str(SU.recordingLocation{SUnums(k)}(3)) ' ' SU.cellName{SUnums(k)}])
    
    SU.PCTH.Con210.sharpTouchCells = find(cellfun(@(x)sum(x(54:75)>4),SU.PCTH.Con210.z)>=2)

end
%print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PCTHforDan_nonC2_con25.eps')
