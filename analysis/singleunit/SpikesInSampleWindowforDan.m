


SUnums_L23 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))
SUnums_L56 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.588))

SUnums_Lall = find([SU.distance{:}] < .250);
SUnums= SUnums_L4(1)

contactNumbers = 1:5
[~, depthOrder] = sort(cellfun(@(x)-x(3),SU.recordingLocation(SUnums)))
SUnums = [1:35 37:53];% SUnums(depthOrder)

for k = 1:length(SUnums)
%     subplot(4,7,k);hold on
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\' SU.contactsArrayName{SUnums(k)}]);
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\' SU.trialArrayName{SUnums(k)}]);
    
    
    
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindHit = find(T.hitTrialInds & T.whiskerTrialInds)
    tindMiss = find(T.missTrialInds & T.whiskerTrialInds)
    tindFA = find(T.falseAlarmTrialInds & T.whiskerTrialInds)
    tindCR = find(T.correctRejectionTrialInds & T.whiskerTrialInds)
    
    % Crop timeframe to relevant one
    cropInd = {};
    cropSpikes = {};
    for i = find(T.whiskerTrialInds)
    ampThresh = 2.5;
    [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] = SAHWhiskerDecomposition(T.trials{i}.whiskerTrial.thetaAtBase{1});
    time  = T.trials{i}.whiskerTrial.time{1};
    ampInd = amplitudeS' > ampThresh;
    ansInd = time <= min([T.trials{i}.answerLickTime T.trials{i}.pinAscentOnsetTime]) & ...
        time >= T.trials{i}.pinDescentOnsetTime+.5;
    
    cropInd{i} = ampInd & ansInd;
    cropSpikes{i} = intersect(round((time(cropInd{i})-wTTO)*1000), round(T.trials{i}.spikesTrial.spikeTimes/10));
    end
    
    SU.samplingWindowSpikes.tindHit{SUnums(k)} = tindHit;
    SU.samplingWindowSpikes.tindMiss{SUnums(k)} = tindMiss;
    SU.samplingWindowSpikes.tindFA{SUnums(k)} = tindFA;
    SU.samplingWindowSpikes.tindCR{SUnums(k)} = tindCR;
    SU.samplingWindowSpikes.cropInd{SUnums(k)} = cropInd;
    SU.samplingWindowSpikes.cropSpikes{SUnums(k)} = cropSpikes;

end
% h_fig3 = figure(3);clf;hold on
% plot(mean(cellfun(@(x)length(x),cropSpikes(tindCR)))

