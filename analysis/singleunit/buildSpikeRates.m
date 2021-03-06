for cellNum = 1
    
    hh              = {};
    amplitude       = {};
    filteredSignal  = {};
    setpoint        = {};
    amplitudeS      = {};
    setpointS       = {};
    phase           = {};
    phaseS          = {};
    theta           = {};
    time            = {};
    cropInd         = {};
    spikeRateCrop   = {};
    cropInd         = {};
    timeCrop        = {};
    phaseCrop       = {};
    tCropInd        = {};
    spikeArray  = {};
    shuffledSpikeRateCrop = {};
    SUdir = 'Z:\users\Andrew\Whisker Project\SingleUnit\';
    
    load([SUdir 'TrialArrays\' SU.trialArrayName{cellNum}])
    load([SUdir 'ConTA\' SU.contactsArrayName{cellNum}])
        ctind = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    tct = ctind(find(cellfun(@(x)x.trialContactType == 0,contacts(ctind)))); % find trial indicies of non-contact trials
    tct = tct(T.trialNums(tct) >= T.performanceRegion(1) & T.trialNums(tct) <= T.performanceRegion(2)); % Crop analysis to performing trials
        tct = tct(cellfun(@(x)length(x.whiskerTrial.time{1})>500,T.trials(tct))); % exclude trials with extremely short whisker data

    %  tct2 = ctind(find(cellfun(@(x)x.trialContactType == 2,contacts(ctind))));
    %  tct2 = tct2(tct2 >= T.performanceRegion(1) & tct2 <= T.performanceRegion(2))
    %
    %  tct = cat(2,tct,tct2)
   
    latency = SU.latency{cellNum};
    
    sfS = T.trials{find(T.whiskerTrialInds,1,'first')}.spikesTrial.sampleRate;
    wTTO       = T.whiskerTrialTimeOffset;
    
    
    spikeTimes = cellfun(@(x)x.spikesTrial.spikeTimes,T.trials,'UniformOutput',0);
    
    whiskingSpikes = [];
    nonwhiskingSpikes = [];

    for i = 1:length(tct)
        cW = T.trials{tct(i)}.whiskerTrial;
        sweepLength = T.trials{tct(i)}.spikesTrial.sweepLengthInSamples / sfS * 1000;
        theta{i} = cW.thetaAtBase{1}(~isnan(cW.thetaAtBase{1}));
        time{i} = cW.time{1}(~isnan(cW.thetaAtBase{1}));
        cS = T.trials{tct(i)}.spikesTrial;
        
        
                
        
        
        
        spikeArray{i} = zeros(sweepLength,1);
        
        spikeArray{i}(round((double(spikeTimes{i}(spikeTimes{i}>wTTO*sfS)) / sfS - wTTO)*1000)) = 1000; % Timeshift all spikeTimes for the trial
        
        
     
        
        
        [hh{i} amplitude{i}  filteredSignal{i} setpoint{i} amplitudeS{i} setpointS{i} phase{i} phaseS{i}] =  SAHWhiskerDecomposition(theta{i});
            
        cropInd{i}       = amplitude{i} > 1.5;
        timeCrop{i}      = time{i}(cropInd{i});
        phaseCrop{i}     = phase{i}(cropInd{i});
        tCropInd{i}      = round(timeCrop{i}*1000)+1;
        %spikeArrayCrop{i}   = spikeArray{i}(tCropInd{i})';
      
        whiskingSpikes = cat(1, whiskingSpikes, spikeArray{i}(tCropInd{i}));
        nonwhiskingSpikes = cat(1, nonwhiskingSpikes, spikeArray{i}( setdiff(1:length(spikeArray{i}),tCropInd{i})));
    end
     
     
      whiskingSR =  mean(whiskingSpikes)
      nonwhiskingSR = mean(nonwhiskingSpikes)
      
end
      