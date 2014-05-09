[CA, T, DA, contacts, params] = loadSUData(6, SU);
figure(1);clf;hold on;set(gcf,'paperposition', [0 0 4 4],'papersize', [4 4])

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
figure(1);clf;hold on;set(gcf,'paperposition', [0 0 1.5 1.5],'papersize', [4 4])

T.plot_spike_raster(T.trialNums(goContacts),'Sequential',goFirstContactTime+.01,'lines')
xlabel('Time from first touch (s)')
ylabel('Trial number')
set(gca,'xlim',[-.025 .05],'ylim',[0 75])
set(get(gca,'children'),'linewidth',.5)
title('Go contact trials')
   % title('Go - 1st contact aligned')
    print(gcf, '-depsc',  'z:\users\Andrew\Whisker Project\Figures\Fig1GoSpikes.eps')
%%
figure(2);clf;hold on;set(gcf,'paperposition', [0 0 1.5 1.5],'papersize', [1.5 1.5])

T.plot_spike_raster(T.trialNums(noGoContacts),'Sequential',noGoFirstContactTime+.01,'lines')
xlabel('Time from first touch (s)')
ylabel('Trial number')
title('Nogo contact trials')
set(gca,'xlim',[-.025 .05],'ylim',[0 75])
set(get(gca,'children'),'linewidth',.5)
set(gca,'ytick',[0 20 40])
   % title('Nogo - 1st contact aligned'
    print(gcf, '-depsc',  'z:\users\Andrew\Whisker Project\Figures\Fig1NogoSpikes.eps')

%%
contactNumbers = 1;
SUnums = 6;%SUnums(depthOrder)
for k = 1:length(SUnums)
figure(3);clf;hold on;set(gcf,'paperposition', [0 0 1.5 1.5],'papersize', [1.5 1.5])


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
          xlabel('Time from first touch (s)')
    ylabel('Spks / s')
   
%     
    h = findobj(gca,'Type','patch');
    set(h,'linewidth',.25,'facealpha',0.25)
  %  title('1st contact PCTH')
    
    print(gcf, '-dtiff', '-r1200',  'z:\users\Andrew\Whisker Project\Figures\Fig1ExampleTrialPCTH.tif')

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
%%
figure(4);clf;hold on;set(gcf,'paperposition', [0 0 2 2],'papersize', [2 2])

    plot(goTheta,goSpikesContact,'bo','markersize',4)
    plot(noGoTheta,noGoSpikesContact,'ro','markersize',4)
    ylabel('Spikes in contact')
    xlabel('\theta at first touch (deg)')
    axis([-10 30 -.1 3.1])
    set(gca,'ytick', [0:3])
    print(gcf, '-depsc',  'z:\users\Andrew\Whisker Project\Figures\Fig1ContactTriggeredTheta.eps')
%%
figure(5);clf;hold on;set(gcf,'paperposition', [0 0 1.5 1.5],'papersize', [1.5 1.5])

    nogozeros = cell(length(spikeTimesNogo),1)
    nogozeros(:) = {0}
        gozeros = cell(length(spikeTimesGo),1)
    gozeros(:) = {0}
    plotHist(spikeTimesNogo,nogozeros,.1,[0 1.6],'r')
        plotHist(spikeTimesGo,gozeros,.1,[0 1.6],'b')
            h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    xlabel('Time from trial start (s)')
    ylabel('Spks / s')
    plot(repmat(mean(cellfun(@(x)x.answerLickTime,T.trials(find(cellfun(@(x)~isempty(x.answerLickTime),T.trials))))),2,1),[0 8],'k--')
print(gcf, '-dtiff', '-r1200', 'z:\users\Andrew\Whisker Project\Figures\Fig1ExampleTrialHistogram.tif')
%%
    figure(6);clf;hold on;set(gcf,'paperposition', [0 0 3 3],'papersize', [3 3])

    xlabel('Trial aligned time (s)')
    ylabel('Theta At Base')
    title([SU.cellName{SUnums(k)} ' Trials 36 & 37'])
    plot(T.trials{29}.whiskerTrial.time{1},T.trials{29}.whiskerTrial.thetaAtBase{1}+70,'ko-','linewidth',.5,'markersize',1,'markeredgecolor','none','markerfacecolor',[.2 .2 .2])
plot(T.trials{29}.whiskerTrial.time{1}(contacts{29}.contactInds{1}),T.trials{29}.whiskerTrial.thetaAtBase{1}(contacts{29}.contactInds{1})+70,'o','linewidth',.5,'markeredgecolor','none','markersize',1,'markerfacecolor','c')
plot(T.trials{30}.whiskerTrial.time{1},T.trials{30}.whiskerTrial.thetaAtBase{1},'ko-','linewidth',.5,'markersize',1,'markeredgecolor','none','markerfacecolor',[.2 .2 .2])
plot(T.trials{30}.whiskerTrial.time{1}(contacts{30}.contactInds{1}),T.trials{30}.whiskerTrial.thetaAtBase{1}(contacts{30}.contactInds{1}),'o','linewidth',.5,'markeredgecolor','none','markersize',1,'markerfacecolor','c')
text(-.2,123,'Pole')
text(-.2,116,'Hit')
text(-.2,111,'Licks')
text(-.2,105,'Spikes')
text(-.2,52,'Correct Rejection')
text(-.2,46,'Licks')
text(-.2,40,'Spikes')

plot(repmat(T.trials{29}.spikesTrial.spikeTimes /10000,1,2)',repmat([103 107],length(T.trials{29}.spikesTrial.spikeTimes),1)','k-','linewidth',.5)
plot(repmat(T.trials{30}.spikesTrial.spikeTimes /10000,1,2)',repmat([38 42],length(T.trials{30}.spikesTrial.spikeTimes),1)','k-','linewidth',.5)
plot(repmat(T.trials{29}.beamBreakTimes,1,2)',repmat([111],length(T.trials{29}.beamBreakTimes),1)','*m','linewidth',.5,'markersize',4)
plot([0 0.085],[120 120],'color',[.6 .6 .6],'linewidth',2)
plot([.082 .712],[120 124.621],'color',[.6 .6 .6],'linewidth',2)
plot([.712 .9],[124.621 126],'color','k','linewidth',2)
plot([.898 1.582],[126 126],'color','k','linewidth',2)


h_x6 = text(-.07, -8,'500ms')
h_y6 = text(-.13, -10,['20' char(176)],'rotation',90)
plot([-0.1 .35],[-12 -12],'k-','linewidth',2)
plot([-0.1 -.1]+.01,[-12 -2]-.85,'k-','linewidth',2)
axis([-.12 1.582 -25 128])
set(gca,'visible','off')
print(gcf, '-depsc2', 'z:\users\Andrew\Whisker Project\Figures\Fig1WhiskExample.eps')
%print(gcf, '-depsc',  'z:\users\Andrew\Whisker Project\Figures\Fig1forDan.eps')