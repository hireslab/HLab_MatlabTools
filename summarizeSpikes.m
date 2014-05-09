function summarizeSpikes(array, contacts, params)


smoothSpan=50
g=params;

hitNums=(array.hitTrialNums(array.hitTrialNums >= params.trialRange(1) & array.hitTrialNums <= params.trialRange(2)));
missNums=(array.missTrialNums(array.missTrialNums >= params.trialRange(1) & array.missTrialNums <= params.trialRange(2)));
falseAlarmNums=(array.falseAlarmTrialNums(array.falseAlarmTrialNums >= params.trialRange(1) & array.falseAlarmTrialNums <= params.trialRange(2)));
correctRejectionNums=(array.correctRejectionTrialNums(array.correctRejectionTrialNums >= params.trialRange(1) & array.correctRejectionTrialNums <= params.trialRange(2)));
allNums=(array.trialNums(array.trialNums >= params.trialRange(1) & array.trialNums <= params.trialRange(2)));

xmax=array.trials{1}.spikesTrial.sweepLengthInSamples/array.trials{2}.spikesTrial.sampleRate;
ymax=max([length(hitNums),length(array.missTrialNums),...
    length(correctRejectionNums),length(falseAlarmNums)]);

h = waitbar(0,'Plotting Spike Rasters');

h_spikes=figure; 
subplot(2,4,1);cla;hold on;
array.plot_lick_raster(hitNums,'Sequential',[],'lines');
array.plot_spike_raster(hitNums,'Sequential',[],'lines');
axis([0 xmax 0 ymax]);
title('Hit Trials')
waitbar(1/5,h);

subplot(2,4,2);cla;hold on;
array.plot_lick_raster(missNums,'Sequential',[],'lines');
array.plot_spike_raster(missNums,'Sequential',[],'lines');
axis([0 xmax 0 ymax]);
waitbar(2/5,h);
title('Miss Trials')

subplot(2,4,5);cla;hold on;
array.plot_lick_raster(falseAlarmNums,'Sequential',[],'lines');
array.plot_spike_raster(falseAlarmNums,'Sequential',[],'lines');
axis([0 xmax 0 ymax]);
waitbar(3/5,h);
title('False Alarm Trials')

subplot(2,4,6);cla;hold on;
array.plot_lick_raster(correctRejectionNums,'Sequential',[],'lines');
array.plot_spike_raster(correctRejectionNums,'Sequential',[],'lines');
axis([0 xmax 0 ymax]);
waitbar(4/5,h);
title('Correct Rejection Trials')

subplot(2,4,[3 4]);cla;hold on;
array.plot_lick_raster(allNums,'BehavTrialNum',[],'lines');
array.plot_spike_raster(allNums,'BehavTrialNum',[],'lines');
axis([0 xmax allNums(1) allNums(end)]);
waitbar(5/5,h);
title('All Trials')
close(h)

subplot(2,4,[7 8]);

spikeIndex=cell(1,array.length);

h = waitbar(0,'Building Spike Arrays');
j=array.length;
   
for k=1:array.length
    waitbar(k/j,h);
    spikeIndex{k}=zeros(array.trials{k}.spikesTrial.sweepLengthInSamples,1);
    % Calculate the spike rate across trials
    try
        spikeIndex{k}(array.trials{k}.spikesTrial.spikeTimes)=1;
    catch
    end
end
close(h)

h = waitbar(0, 'Finding mean spike Rates');

sampleRate=array.trials{k}.spikesTrial.sampleRate;
[~,useTrials,~]=intersect(array.trialNums,allNums);

hitSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(array.hitTrialInds(useTrials)),'UniformOutput',0));
hitSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data

waitbar(1/4,h);

missSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(array.missTrialInds(useTrials)),'UniformOutput',0));
  waitbar(2/4,h);
missSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN;
  
falseAlarmSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(array.falseAlarmTrialInds(useTrials)),'UniformOutput',0));
falseAlarmSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN;
 waitbar(3/4,h); 
 
correctRejectionSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(array.correctRejectionTrialInds(useTrials)),'UniformOutput',0));
correctRejectionSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN;
waitbar(1,h);
 
% need to add useTrials functionality to contact segregated plots

waitbar(1/5,h);
noneSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==0),useTrials)),'UniformOutput',0));
noneSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data


waitbar(2/5,h);

gpSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==1),useTrials)),'UniformOutput',0));
gpSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data

waitbar(3/5,h);

grSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==2),useTrials)),'UniformOutput',0));
grSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data

waitbar(4/5,h);

npSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==3),useTrials)),'UniformOutput',0));
npSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data

waitbar(5/5,h);

if sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==4)
    nrSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
        ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==4),useTrials)),'UniformOutput',0));
    nrSpikeRate([1:round(params.spikeRateWindow*sampleRate/2) end-round(params.spikeRateWindow*sampleRate/2)+1:end])=NaN; % NaN endtimeperiods with incomplete data
else 
    nrSpikeRate=zeros(size(noneSpikeRate,1),1);
end

 close(h)
 
x=[1+round(params.spikeRateWindow*sampleRate/2):10:46000-round(params.spikeRateWindow*sampleRate/2)];

hold on
y=mean(missSpikeRate(x,:),2);
yerr=std(missSpikeRate(x,:),0,2)/sqrt(length(missNums));
patch([x x(end:-1:1)]/sampleRate,[y+yerr;y(end:-1:1)-yerr(end:-1:1)],[.8 .8 .8],'EdgeColor','none');
ymax=max(y+yerr);

y=mean(falseAlarmSpikeRate(x,:),2);
yerr=std(falseAlarmSpikeRate(x,:),0,2)/sqrt(length(falseAlarmNums));
patch([x x(end:-1:1)]/sampleRate,[y+yerr;y(end:-1:1)-yerr(end:-1:1)],[.8 1 .8],'EdgeColor','none');
ymax=max([ymax max(y+yerr)]);

y=mean(correctRejectionSpikeRate(x,:),2);
yerr=std(correctRejectionSpikeRate(x,:),0,2)/sqrt(length(correctRejectionNums));
patch([x x(end:-1:1)]/sampleRate,[y+yerr;y(end:-1:1)-yerr(end:-1:1)],[1 .8 .8],'EdgeColor','none');
ymax=max([ymax max(y+yerr)]);

y=mean(hitSpikeRate(x,:),2);
yerr=std(hitSpikeRate(x,:),0,2)/sqrt(length(hitNums));
patch([x x(end:-1:1)]/sampleRate,[y+yerr;y(end:-1:1)-yerr(end:-1:1)],[.8 .8 1],'EdgeColor','none');
ymax=max([ymax max(y+yerr)]);

plot(x/sampleRate,smooth(mean(missSpikeRate(x,:),2),smoothSpan),'k');
plot(x/sampleRate,smooth(mean(falseAlarmSpikeRate(x,:),2),smoothSpan),'g');
plot(x/sampleRate,smooth(mean(hitSpikeRate(x,:),2),smoothSpan),'b');
plot(x/sampleRate,smooth(mean(correctRejectionSpikeRate(x,:),2),smoothSpan),'r');

axis([0 xmax 0 ymax]);
title('Mean Spike Rates')
xlabel('Time (s)');
ylabel('Spike Rate (Hz)');
legend('Miss','FA','CR','Hit')
set(h_spikes,'PaperOrientation','landscape','PaperPosition',[0 0 15 6.5])
print(h_spikes, '-depsc',[array.mouseName '-' array.cellNum '-' 'spikes.eps']);

xmax=array.trials{1}.spikesTrial.sweepLengthInSamples/array.trials{2}.spikesTrial.sampleRate;
ymax=max([size(noneSpikeRate,2), size(gpSpikeRate,2), size(grSpikeRate,2), size(npSpikeRate,2), size(nrSpikeRate,2)]);

h_contactspikes=figure; 

touchTitles={'None', 'Go/Pro', 'Go/Ret', 'Nogo/Pro', 'No/Ret','Mean Spike Rates'};
for i=1:5
    subplot(2,3,i);cla;
    if sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1))

        array.plot_lick_raster(array.trialNums(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1)),useTrials)),'Sequential',[],'lines');
        hold on;
        array.plot_spike_raster(array.trialNums(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1)),useTrials)),'Sequential',[],'lines');
        end
    axis([0 xmax 0 ymax]);
    title(touchTitles{i});
end
subplot(2,3,6);
cla;

hold on;
plot(x/sampleRate,smooth(mean(nrSpikeRate(x,:),2),smoothSpan),'c');
plot(x/sampleRate,smooth(mean(npSpikeRate(x,:),2),smoothSpan),'b');
plot(x/sampleRate,smooth(mean(noneSpikeRate(x,:),2),smoothSpan),'k');
plot(x/sampleRate,smooth(mean(grSpikeRate(x,:),2),smoothSpan),'m');
plot(x/sampleRate,smooth(mean(gpSpikeRate(x,:),2),smoothSpan),'r');
xlim([0 4.5]);
title(touchTitles{6});
print(h_contactspikes, '-depsc',[array.mouseName '-' array.cellNum '-' 'contact-spikes.eps']);

