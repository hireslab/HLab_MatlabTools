% Spiketimes rounded to nearest ms, and adjusted to the start of the video
% variables per trial
% number of contacts prior to lick
% number of spikes prior to lick
% number of spikes prior to lick during whisking
% mean spike triggered theta
% mean spike triggered phase
% mean spike triggered amp
% mean spike triggered setpoint
% mean spike triggered velocity
% mean M0 in sampling period
% peak M0 in sampling period
% sum M0 in sampling period
% two rows of plots
% top is go / nogo
% bottom is lick / no lick
Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588));

for cellNum = 1:148%Snums_L4


[CA, T, contacts, clustInd] = loadSiData(cellNum, S);

DA = struct;
time = cell(length(T.trials),1);
DA.recordinglocation = S.recordingLocation{cellNum};
DA.spikeTimes = cell(length(T.trials),1);
DA.samplingPeriod = cell(length(T.trials),1);
DA.spikeTimesInSamplingPeriod = cell(length(T.trials),1);
DA.firstLick = cell(length(T.trials),1);
DA.theta = cell(length(T.trials),1);

DA.whiskingThreshold = 2.5; % amplitudeS to cut off
whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts)); % Trials indicies with whisker data
wTTO = T.whiskerTrialTimeOffset;
useFlag = find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag,T.trials));
DA.samplePeriodCutoff = 1.5; % in seconds;
DA.samplePeriodPoleDelay = 0; % in seconds
DA.hitInd = intersect(useFlag, find(T.hitTrialInds));
DA.missInd = intersect(useFlag, find(T.missTrialInds));
DA.FAInd = intersect(useFlag, find(T.falseAlarmTrialInds));
DA.CRInd  = intersect(useFlag, find(T.correctRejectionTrialInds));

for i = whiskerTIN%intersect(useFlag, whiskerTIN)
    
    if ~isempty(T.trials{i}.beamBreakTimes)
    DA.firstLick{i} = T.trials{i}.beamBreakTimes(find(T.trials{i}.beamBreakTimes > T.trials{i}.pinDescentOnsetTime + .5,1,'first'));
    end
    
    DA.spikeTimes{i} = round(double(T.trials{i}.shanksTrial.clustData{clustInd}.spikeTimes)/19.530-1000*wTTO); % Spiketimes in this trial, aligned to video start
    
    time{i}  = T.trials{i}.whiskerTrial.time{1}; % Placeholder for time values of this trial
    DA.samplingPeriodIdx{i} = time{i} <= min([DA.samplePeriodCutoff DA.firstLick{i} T.trials{i}.pinAscentOnsetTime]) & ...
        time{i} >= T.trials{i}.pinDescentOnsetTime+DA.samplePeriodPoleDelay;
    DA.samplingPeriod{i} = time{i}(DA.samplingPeriodIdx{i}); % Time elements in sampling period in seconds
    DA.samplingPeriodinMs{i} = round(1000* DA.samplingPeriod{i});
    DA.spikeTimesInSamplingPeriod{i} = intersect(DA.spikeTimes{i}, round(1000*DA.samplingPeriod{i}));
    DA.timeInMs{i} = round(1000*time{i});
    
    if ~isempty(contacts{i}.segmentInds{1})
    DA.contactTimesInSamplingPeriod{i} = intersect(DA.samplingPeriodinMs{i}, round(1000*T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(:,1))));
    end
    
    DA.theta{i} = T.trials{i}.whiskerTrial.thetaAtBase{1}(DA.samplingPeriodIdx{i});
end

   [~, DA.amplitude(whiskerTIN),  ~, DA.setpoint(whiskerTIN), DA.amplitudeS(whiskerTIN), DA.setpointS(whiskerTIN), DA.phase(whiskerTIN), DA.phaseS(whiskerTIN)] = getDecompFromTime(DA.samplingPeriodinMs(whiskerTIN), whiskerTIN, T);

   for i = whiskerTIN
       DA.whiskSamplingPeriod{i} = DA.samplingPeriod{i}(DA.amplitudeS{i}>DA.whiskingThreshold); % in seconds
       DA.spikeTimesInWhiskSamplingPeriod{i} = intersect(DA.spikeTimesInSamplingPeriod{i}, round(1000*DA.whiskSamplingPeriod{i})); % in ms
        [~,tidx,~] =  intersect(DA.timeInMs{i}, DA.spikeTimesInSamplingPeriod{i});
       DA.samplingSpikeTriggered.theta{i} = T.trials{i}.whiskerTrial.thetaAtBase{1}(tidx);
        [~,tidx,~] =  intersect(DA.timeInMs{i}, DA.spikeTimesInWhiskSamplingPeriod{i});
       DA.whiskSamplingSpikeTriggered.theta{i} = T.trials{i}.whiskerTrial.thetaAtBase{1}(tidx);
   
   end
      [~, DA.samplingSpikeTriggered.amplitude(whiskerTIN),  ~, DA.samplingSpikeTriggered.setpoint(whiskerTIN), DA.samplingSpikeTriggered.amplitudeS(whiskerTIN), DA.samplingSpikeTriggered.setpointS(whiskerTIN), DA.samplingSpikeTriggered.phase(whiskerTIN), DA.samplingSpikeTriggered.phaseS(whiskerTIN)] = getDecompFromTime(DA.spikeTimesInSamplingPeriod(whiskerTIN), whiskerTIN, T);
      [~, DA.whiskSamplingSpikeTriggered.amplitude(whiskerTIN),  ~, DA.whiskSamplingSpikeTriggered.setpoint(whiskerTIN), DA.whiskSamplingSpikeTriggered.amplitudeS(whiskerTIN), DA.whiskSamplingSpikeTriggered.setpointS(whiskerTIN), DA.whiskSamplingSpikeTriggered.phase(whiskerTIN), DA.whiskSamplingSpikeTriggered.phaseS(whiskerTIN)] = getDecompFromTime(DA.spikeTimesInWhiskSamplingPeriod(whiskerTIN), whiskerTIN, T);
    
   DA.spikeCountInSamplingPeriod = cellfun(@numel, DA.spikeTimesInSamplingPeriod);
   DA.spikeCountInWhiskSamplingPeriod = cellfun(@numel, DA.spikeTimesInWhiskSamplingPeriod);

save(['z:\users\Andrew\Whisker Project\Silicon\DiscrimAnalysisArrays\DA_' num2str(cellNum) '_' S.filename{cellNum}(1:end-4)], 'DA')
end

   %%
   
figure(1);clf;hold on
subplot(2,8,1);cla;hold on
plot(1, cellfun(@(x)nanmean(x),DA.phase(find(T.hitTrialInds | T.missTrialInds))),'bo')
plot(2, cellfun(@(x)nanmean(x),DA.phase(find(T.correctRejectionTrialInds | T.falseAlarmTrialInds))),'ro')
set(gca,'xlim',[0 3])
title('ST phase')
ylabel('Go/Nogo')

subplot(2,8,9);cla;hold on
plot(1, cellfun(@(x)nanmean(x),DA.phase(find(T.hitTrialInds | T.falseAlarmTrialInds))),'go')
plot(2, cellfun(@(x)nanmean(x),DA.phase(find(T.correctRejectionTrialInds | T.missTrialInds))),'ro')
set(gca,'xlim',[0 3])
title('ST phase')
ylabel('lick/nolick')