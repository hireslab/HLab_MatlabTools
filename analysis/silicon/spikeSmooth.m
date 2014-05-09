function smoothSR = spikeSmooth(T, span)

% Build Smoothed SpikeRate and slide to whisker frame time
% Basic Setup
whiskerTIN  = find(T.whiskerTrialInds)
timeWindow  = [.01 .050];
maxConNum   = 10;
proConSR    ={};
useFlag     ={};
csind       ={};
cind        ={};


wfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.whiskerTrial.framePeriodInSec; % Whisker Frame Duration
sfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.shanksTrial.sampleRate; % Spike Sampling Rate
wTTO       = T.whiskerTrialTimeOffset;
time(whiskerTIN) = cellfun(@(x)x.whiskerTrial.time{1}, T.trials(whiskerTIN),'UniformOutput',0);

% Setup Contact Indicies

spikeTimes  = cell(length(T.cellNum),1);
smoothSR    = cell(length(T.cellNum),1);
tic
% SpikeTimes is {clust}{trials}(spikeTime)
for i=1:length(T.cellNum)
    spikeTimes{i} = cellfun(@(x)(1000*x.shanksTrial.clustData{i}.spikeTimes) ./ sfS - 1000*wTTO,T.trials,'UniformOutput',0) ;
    
    for trial = 1:max(whiskerTIN);
        smoothSR{i}{trial} = zeros(4500,1);
        smoothSR{i}{trial}(spikeTimes{i}{trial}(spikeTimes{i}{trial} > 0)) = 1; 
        smoothSR{i}{trial} = smooth(smoothSR{i}{trial},span,'moving')*1000;

    end
end

% smoothSR is {clusts}{trials}(milliseconds)

