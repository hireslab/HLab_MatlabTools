figure(1);clf
set(gcf,'paperposition', [0 0 12 8],'papersize', [12 8])
%[CA, T, contacts, params] = loadSUdata(6,SU);

noGoContacts = find(cellfun(@(x)x.trialContactType >=3,contacts) & cellfun(@(x)~isempty(x.segmentInds{1}),contacts))
goContacts= find(cellfun(@(x)x.trialContactType ==2 | x.trialContactType ==1,contacts) & cellfun(@(x)~isempty(x.segmentInds{1}),contacts))

% noGoContacts = noGoContacts(find(cellfun(@(x)x.segmentInds{1}(1)<1600,contacts(noGoContacts))))
% goContacts = goContacts(find(cellfun(@(x)x.segmentInds{1}(1)<1600,contacts(goContacts))))

noGoFirstContactTime=[];
goFirstContactTime=[];
for i = 1:length(noGoContacts)
noGoFirstContactTime(i) = T.trials{noGoContacts(i)}.whiskerTrial.time{1}(contacts{noGoContacts(i)}.segmentInds{1}(1))
end
for i = 1:length(goContacts)
    goFirstContactTime(i) = T.trials{goContacts(i)}.whiskerTrial.time{1}(contacts{goContacts(i)}.segmentInds{1}(1))
end

subplot(2,3,1);cla
T.plot_spike_raster(T.trialNums(goContacts),'Sequential',goFirstContactTime+.01,'lines')
set(gca,'xlim',[-.025 .05],'ylim',[0 75])
set(get(gca,'children'),'linewidth',2)
    title('Go - 1st contact aligned')

subplot(2,3,4);cla
T.plot_spike_raster(T.trialNums(noGoContacts),'Sequential',noGoFirstContactTime+.01,'lines')
set(gca,'xlim',[-.025 .05],'ylim',[0 75])
set(get(gca,'children'),'linewidth',2)
    title('Nogo - 1st contact aligned')


contactNumbers = 1;
SUnums = 6;%SUnums(depthOrder)
for k = 1:length(SUnums)
subplot(2,3,2);cla;hold on

    firstLick = cell(length(T.trials),1);

    
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindGo = goContacts;
    tindNogo = noGoContacts;
    
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
%                 if T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1)) <= min([T.trials{tindGo(i)}.answerLickTime 2.5]);
                    spikeTimesGo{i,j} = double(T.trials{tindGo(i)}.spikesTrial.spikeTimes)/10000-wTTO;
                    alignTimesGo{i,j} = T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1));
%                 end
                
            end
        end
    end
    for i = 1:length(tindNogo)
             if ~isempty(T.trials{tindNogo(i)}.beamBreakTimes)
    firstLick{tindNogo(i)} = T.trials{i}.beamBreakTimes(find(T.trials{i}.beamBreakTimes > T.trials{i}.pinDescentOnsetTime + .5,1,'first'));
        end
        for j = contactNumbers
            if size(contacts{tindNogo(i)}.segmentInds{1},1)>=j
%                 if T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1)) <= min([2.5 firstLick{i} T.trials{i}.pinAscentOnsetTime]);
                    
                    spikeTimesNogo{i,j} = double(T.trials{tindNogo(i)}.spikesTrial.spikeTimes)/10000-wTTO;
                    alignTimesNogo{i,j} = T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1));
%                 end
            end
        end
        
    end
    spikeTimesGo = spikeTimesGo(cellfun(@(x)~isempty(x),spikeTimesGo))
    alignTimesGo = alignTimesGo(cellfun(@(x)~isempty(x),alignTimesGo))
    spikeTimesNogo = spikeTimesNogo(cellfun(@(x)~isempty(x),spikeTimesNogo))
    alignTimesNogo = alignTimesNogo(cellfun(@(x)~isempty(x),alignTimesNogo))
    

      plotHist(spikeTimesNogo, alignTimesNogo,.001,[-.025 .05],'r');
      plotHist(spikeTimesGo, alignTimesGo,.001,[-.025 .05],'b')
          xlabel('1st contact aligned time (s)')
    ylabel('Spks / s')
   
%     
    h = findobj(gca,'Type','patch');
    set(h,'linewidth',.25,'facealpha',0.25)
    title('1st contact PCTH')
    

end

goTheta=[];
noGoTheta=[];
for i = 1:length(goContacts)
    goTheta(i) = T.trials{goContacts(i)}.whiskerTrial.thetaAtBase{1}(contacts{goContacts(i)}.segmentInds{1}(1));
    goSpikesContact(i) = sum(spikeTimesGo{i} > alignTimesGo{i}+.005 & spikeTimesGo{i} < alignTimesGo{i}+.05)
end
for i = 1:length(noGoContacts)
    noGoTheta(i) = T.trials{noGoContacts(i)}.whiskerTrial.thetaAtBase{1}(contacts{noGoContacts(i)}.segmentInds{1}(1));
        noGoSpikesContact(i) = sum(spikeTimesNogo{i} > alignTimesNogo{i}+.005 & spikeTimesNogo{i} < alignTimesNogo{i}+.05);

end

    subplot(2,3,5);cla;hold on
    plot(goTheta,goSpikesContact,'bo')
    plot(noGoTheta,noGoSpikesContact,'ro')
    ylabel('spikes in contact')
    xlabel('thetaAtContact (deg)')
    set(gca,'xlim', [-10 30])
    
    subplot(2,3,3);cla;hold on
    nogozeros = cell(length(spikeTimesNogo),1)
    nogozeros(:) = {0}
        gozeros = cell(length(spikeTimesGo),1)
    gozeros(:) = {0}
    plotHist(spikeTimesNogo,nogozeros,.1,[0 4],'r')
        plotHist(spikeTimesGo,gozeros,.1,[0 4],'b')
            h = findobj(gca,'Type','patch');
    set(h,'linewidth',.25,'facealpha',0.25)
    xlabel('Trial aligned time (s)')
    ylabel('Spks / s')
    plot(repmat(mean(cellfun(@(x)x.answerLickTime,T.trials(find(cellfun(@(x)~isempty(x.answerLickTime),T.trials))))),2,1),[0 8],'k--')
subplot(2,3,6);cla;hold on
    xlabel('Trial aligned time (s)')
    ylabel('Theta At Base')
    title([SU.cellName{SUnums(k)} ' Trials 36 & 37'])
    plot(T.trials{29}.whiskerTrial.time{1},T.trials{29}.whiskerTrial.thetaAtBase{1}+70,'k.-')
plot(T.trials{29}.whiskerTrial.time{1}(contacts{29}.contactInds{1}),T.trials{29}.whiskerTrial.thetaAtBase{1}(contacts{29}.contactInds{1})+70,'ro','markersize',4)
plot(T.trials{30}.whiskerTrial.time{1},T.trials{30}.whiskerTrial.thetaAtBase{1},'k.-')
plot(T.trials{30}.whiskerTrial.time{1}(contacts{30}.contactInds{1}),T.trials{30}.whiskerTrial.thetaAtBase{1}(contacts{30}.contactInds{1}),'ro','markersize',4)
text(.1,100,'Hit')
text(.1,45,'Correct Rejection')
plot(repmat(T.trials{29}.spikesTrial.spikeTimes /10000,1,2)',repmat([100 105],length(T.trials{29}.spikesTrial.spikeTimes),1)','k-','linewidth',1)
plot(repmat(T.trials{30}.spikesTrial.spikeTimes /10000,1,2)',repmat([35 40],length(T.trials{30}.spikesTrial.spikeTimes),1)','k-','linewidth',1)
plot(repmat(T.trials{29}.beamBreakTimes,1,2)',repmat([95],length(T.trials{29}.beamBreakTimes),1)','*m','linewidth',1)
plot([.677 3.61],[115 115],'color',[.6 .6 .6],'linewidth',5)


%print(gcf, '-depsc',  'z:\users\Andrew\Whisker Project\Figures\Fig1forDan.eps')