phaseSRMean = [];
phaseBinMean = [];

savedir = 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PhaseSR\'

for cellNum = 8:53
    
    
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
    spikeRateWhisking   = {};
    cropInd         = {};
    timeCrop        = {};
    phaseCrop       = {};
    tCropInd        = {};
    spikeArray = {};
    smoothSpikeArray ={};
    shuffledSpikeRateWhisking = {};
    spikeArrayCrop ={};
    SUdir = 'Z:\users\Andrew\Whisker Project\SingleUnit\';
    
    load([SUdir 'TrialArrays\' SU.trialArrayName{cellNum}])
    load([SUdir 'ConTA\' SU.contactsArrayName{cellNum}])
    
    
    ctind = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    tct = ctind(find(cellfun(@(x)x.trialContactType == 0,contacts(ctind)))); % find trial indicies of non-contact trials
    tct = tct(T.trialNums(tct) >= T.performanceRegion(1) & T.trialNums(tct) <= T.performanceRegion(2)); % Crop analysis to performing trials
    tct = tct(cellfun(@(x)length(x.whiskerTrial.time{1})>500,T.trials(tct))); % exclude trials with extremely short whisker data
    
     
   
    perfT = ctind(T.trialNums(ctind) >= T.performanceRegion(1) & T.trialNums(ctind) <= T.performanceRegion(2)); % Crop analysis to performing trials
    perfT = perfT(cellfun(@(x)length(x.whiskerTrial.time{1})>500,T.trials(perfT))); % exclude trials with extremely short whisker data
    
    %  tct2 = ctind(find(cellfun(@(x)x.trialContactType == 2,contacts(ctind))));
    %  tct2 = tct2(tct2 >= T.performanceRegion(1) & tct2 <= T.performanceRegion(2))
    %
    %  tct = cat(2,tct,tct2)
    
    latency = SU.latency{cellNum};
    
    sfS = T.trials{find(T.whiskerTrialInds,1,'first')}.spikesTrial.sampleRate;
    wTTO       = T.whiskerTrialTimeOffset;
    
    
    spikeTimes = cellfun(@(x)x.spikesTrial.spikeTimes,T.trials,'UniformOutput',0);
    
    
    
    spikeRateCat = [];
    phaseCat = [];
    shuffledSpikeRateCat = [];
    nbins = 8;
    smoothWindow = 5;
    shuffleSize = 100;
    whiskingSpikes = [];
    nonwhiskingSpikes = [];
 
    
    for i = 1:length(perfT);
        
        cW = T.trials{perfT(i)}.whiskerTrial;
        sweepLength = T.trials{perfT(i)}.spikesTrial.sweepLengthInSamples / sfS * 1000;
        theta{perfT(i)} = cW.thetaAtBase{1}(~isnan(cW.thetaAtBase{1}));
        time{perfT(i)} = cW.time{1}(~isnan(cW.thetaAtBase{1}));
        cS = T.trials{perfT(i)}.spikesTrial;
        
        spikeArray{perfT(i)} = zeros(sweepLength,1);
        
        spikeArray{perfT(i)}(round((double(spikeTimes{perfT(i)}(spikeTimes{perfT(i)}>(wTTO+.001)*sfS)) / sfS - wTTO)*1000)) = 1000; % Timeshift all spikeTimes for the trial
        
        
        smoothSpikeArray{perfT(i)} = smooth(spikeArray{perfT(i)},smoothWindow);
        
        
        [hh{perfT(i)} amplitude{perfT(i)}  filteredSignal{perfT(i)} setpoint{perfT(i)} amplitudeS{perfT(i)} setpointS{perfT(i)} phase{perfT(i)} phaseS{perfT(i)}] =  SAHWhiskerDecomposition(theta{perfT(i)});
    
    end
        
        
        
    for i = 1:length(tct)

        cropInd{tct(i)}       = amplitude{tct(i)} > 1.5;
        timeCrop{tct(i)}      = time{tct(i)}(cropInd{tct(i)});
        phaseCrop{tct(i)}     = phase{tct(i)}(cropInd{tct(i)});
        tCropInd{tct(i)}      = round(timeCrop{tct(i)}*1000)+1;
        spikeArrayCrop{tct(i)}   = spikeArray{tct(i)}(tCropInd{tct(i)})';
        
        shuffleSorter = rand(shuffleSize,length(spikeArrayCrop{tct(i)}));
        shuffledSmoothSpikeArray = zeros(size(shuffleSorter));
        if ~isempty(spikeArrayCrop{tct(i)});
            for j=1:shuffleSize
                shuffledSpikeArrayExpansion = zeros(1,length(spikeArray));
                tmp =sortrows([shuffleSorter(j,:);spikeArrayCrop{tct(i)}]',1);
                shuffledSpikeArrayExpansion(round(timeCrop{tct(i)}*1000)+1) = tmp(:,2);
                shuffledSpikeArrayExpansion = smooth(shuffledSpikeArrayExpansion,smoothWindow);
                shuffledSpikeRateWhisking{tct(i)}(j,:) = shuffledSpikeArrayExpansion(tCropInd{tct(i)});
            end
        else
            shuffledSpikeRateWhisking{tct(i)} = [];
        end
        
        spikeRateWhisking{tct(i)} = smoothSpikeArray{tct(i)}(tCropInd{tct(i)})';
        
    end
    
    
    % Compare to binned phase
    for i = 1:length(tct)
        spikeRateCat = cat(2,spikeRateCat, spikeRateWhisking{tct(i)});
        shuffledSpikeRateCat = cat(2,shuffledSpikeRateCat, shuffledSpikeRateWhisking{tct(i)});
        
        phaseCat = cat(2,phaseCat,phaseCrop{tct(i)});
        
        
    end
    
    binBounds = -pi:(2*pi/nbins):pi;
    [phaseSR phaseBin phaseBounds] = binslin(phaseCat,spikeRateCat,'equalX',binBounds)
    
    for k = 1:nbins
        phaseSRMean(k) = nanmean(phaseSR{k});
        phaseBinMean(k) = nanmean(phaseBin{k});
    end
    shuffledPhaseSRMean = {};
    shuffledPhaseBinMean = {};
    for j = 1:shuffleSize
        [shuffledPhaseSR{j} shuffledPhaseBin{j} shuffledPhaseBounds{j}] = binslin(phaseCat,shuffledSpikeRateCat(j,:),'equalX',binBounds);
        for k = 1:nbins
            shuffledPhaseSRMean{j}(k) = nanmean(shuffledPhaseSR{j}{k});
            shuffledPhaseBinMean{j}(k) = nanmean(shuffledPhaseBin{j}{k});
        end
        
    end
    
    % Shuffle the phase data with respect to spikerate dataset to determine
    % significance intervals
    % There are two ways to shuffle, within the subset of points that have
    % a defined phase and high whisking amplitude, or across all points. In
    % this case we shuffle only across timepoints that are above our
    % whisking threshold.  We want to see if INSIDE the whisking epochs,
    % there is phase modulation
    
    
    
    wSpikes = [];
    nwSpikes = [];
    for i = tct
        wSpikes=cat(1,wSpikes,spikeArray{i}(cropInd{i}));
        nwSpikes=cat(1,nwSpikes,spikeArray{i}(setdiff(1:4500,cropInd{i})));
    end
    
    %% Plot results
    
    
    % find confidence interval for shuffled distributions
    maxShuffle= sort(max(cell2mat(shuffledPhaseSRMean'),[],2))
    minShuffle= sort(min(cell2mat(shuffledPhaseSRMean'),[],2))
    ciBounds = [.2 .8 .05 .95];
    shuffleci= [minShuffle(round(length(minShuffle)*ciBounds(1))) maxShuffle(round(length(maxShuffle)*ciBounds(2)))...
        minShuffle(round(length(minShuffle)*ciBounds(3))) maxShuffle(round(length(maxShuffle)*ciBounds(4)))];
    
    
    h_fig1=figure(1);clf;
    subplot(1,2,1);hold on
    
    
    
    patch([phaseBounds(1) phaseBounds(end) phaseBounds(end) phaseBounds(1)],...
        [shuffleci(3) shuffleci(3) shuffleci(4) shuffleci(4)],...
        [.8 .8 .8],'EdgeColor','none')
    
    patch([phaseBounds(1) phaseBounds(end) phaseBounds(end) phaseBounds(1)],...
        [shuffleci(1) shuffleci(1) shuffleci(2) shuffleci(2)],...
        [.6 .6 .6],'EdgeColor','none')
    
    %      for j = 1:100
    %         plot(shuffledPhaseBinMean{tct(i)}{j},shuffledPhaseSRMean{tct(i)}{j},'k-','LineWidth',.5)
    %      end
    %
    
    plot(phaseBinMean,phaseSRMean,'ro-','LineWidth',2)
    plot([-pi pi],[mean(nwSpikes) mean(nwSpikes)],'b--')
    set(gca,'XLim',[-pi pi],'YLim',[0 2*mean(phaseSRMean)])
    xlabel('Whisking Phase (radians)')
    ylabel('Spike Rate (spk/s)')
    title(SU.trialArrayName{cellNum}(13:end-4))
    
    subplot(1,2,2)   ;
    h1= polar([phaseBinMean phaseBinMean(1)],[phaseSRMean phaseSRMean(1)],'ro-');hold on;
    h2 = bullseye_SAH([.8 .8 .8], 'N', 32, 'rho', [shuffleci(3) shuffleci(4)],'tht', [0 360])
    h3 =  bullseye_SAH([.6 .6 .6], 'N', 32, 'rho', [shuffleci(1) shuffleci(2)],'tht', [0 360])
    h4 =   polar([-2*pi:pi/16:2*pi],repmat(mean(nwSpikes),1,length([-2*pi:pi/16:2*pi])),'.');
    
    h5 =   polar([phaseBinMean phaseBinMean(1)],[phaseSRMean phaseSRMean(1)],'ro-');
    
    
    print(gcf, '-depsc', [savedir 'PhaseSR_' SU.trialArrayName{cellNum}(13:end-4)]);
    
    phaseSRBinned.phaseBinMean = phaseBinMean;
    phaseSRBinned.phaseSRMean = phaseSRMean;
    phaseSRBinned.shuffleci = shuffleci;
    phaseSRBinned.ciBounds = ciBounds;
    SU.phaseSRBinned{cellNum,1} = phaseSRBinned
    
    
    CA.hh                = hh;
    CA.amplitude         = amplitude;
    CA.filteredSignal    = filteredSignal;
    CA.setpoint          = setpoint;
    CA.phase             = phase;
    CA.theta             = theta;
    CA.time              = time;
    CA.cropInd           = cropInd;
    CA.timeCrop          = timeCrop;
    CA.phaseCrop         = phaseCrop;
    CA.tCropInd          = tCropInd;
    CA.spikeArray        = spikeArray;
    CA.smoothSpikeArray  = smoothSpikeArray;
    
    save(['Z:\users\Andrew\Whisker Project\SingleUnit\CellAnalysisArrays\' SU.trialArrayName{cellNum}(13:end-4)], 'CA')
    
end

