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
if ismember('shanksTrial',fieldnames(T.trials{1}))
    sfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.shanksTrial.sampleRate; % Spike Sampling Rate
elseif  ismember('spikesTrial',fieldnames(T.trials{1}))
    
    sfS        = T.trials{find(T.whiskerTrialInds,1,'first')}.spikesTrial.sampleRate; % Spike Sampling Rate
    
end

wTTO       = T.whiskerTrialTimeOffset;
time(whiskerTIN) = cellfun(@(x)x.whiskerTrial.time{1}, T.trials(whiskerTIN),'UniformOutput',0);

% Setup Contact Indicies


tic
% SpikeTimes is {clust}{trials}(spikeTime)
if ismember('shanksTrial',fieldnames(T.trials{1}))
    spikeTimes  = cell(length(T.cellNum),1);
smoothSR    = cell(length(T.cellNum),1);
    
    for i=1:length(T.cellNum)
        
        spikeTimes{i} = cellfun(@(x)(1000*x.shanksTrial.clustData{i}.spikeTimes) ./ sfS + 1000*wTTO,T.trials,'UniformOutput',0) ;
        
    
    
    for trial = 1:max(whiskerTIN);
        smoothSR{i}{trial} = zeros(4500,1);
        smoothSR{i}{trial}(spikeTimes{i}{trial}(spikeTimes{i}{trial} > 0)) = 1;
        smoothSR{i}{trial} = smooth(smoothSR{i}{trial},span,'moving')*1000;
        
    end
    end
% SpikeTimes is {trials}(spikeTime)
elseif  ismember('spikesTrial',fieldnames(T.trials{1}))
    spikeTimes  = {};
smoothSR    = {};

        spikeTimes{1} = cellfun(@(x)(1000*x.spikesTrial.spikeTimes) ./ sfS + 1000*wTTO,T.trials,'UniformOutput',0) ;
        

    
    for trial = 1:max(whiskerTIN);
        smoothSR{1}{trial} = zeros(4500,1);
        smoothSR{1}{trial}(round(spikeTimes{1}{trial}(spikeTimes{1}{trial} > 0))) = 1;
        smoothSR{1}{trial} = smooth(smoothSR{1}{trial},span,'moving')*1000;
        
    end
end
end


% smoothSR is {clusts}{trials}(milliseconds)

