
S_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
S_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\')

Snums = 1:148;
for k=1:length(Snums);
  
    % Open next array if current array does not match name in summary
    if ~strcmp( S.trialArrayName{k}(5:17), T.sessionName(4:16))
        display(['Loading '  S.trialArrayName{k}])
        load([Si_TDir S.trialArrayName{k}])
        load([Si_ConDir S.contactsArrayName{k}]);
    end
    
    % Find cluster index for this cell and session
     clustInd = find(T.cellNum == S.clust{k} & T.shankNum==S.shank{k})
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindHit = find(T.hitTrialInds & T.whiskerTrialInds)
    tindMiss = find(T.missTrialInds & T.whiskerTrialInds)
    tindFA = find(T.falseAlarmTrialInds & T.whiskerTrialInds)
    tindCR = find(T.correctRejectionTrialInds & T.whiskerTrialInds)
    
    % Crop timeframe to relevant one
    cropInd = {};
    cropSpikes = {};
    
    useFlag = find(cellfun(@(x)x.shanksTrial.clustData{clustInd}.useFlag,T.trials));
        
          
    for i = intersect(useFlag,find(T.whiskerTrialInds));
    ampThresh = 2.5;
    [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] = SAHWhiskerDecomposition(T.trials{i}.whiskerTrial.thetaAtBase{1});
    time  = T.trials{i}.whiskerTrial.time{1};
    ampInd = amplitudeS' > ampThresh;
    ansInd = time <= min([T.trials{i}.answerLickTime T.trials{i}.pinAscentOnsetTime]) & ...
        time >= T.trials{i}.pinDescentOnsetTime+.5;
    
    cropInd{i} = ampInd & ansInd;
    cropSpikes{i} = intersect(round((time(cropInd{i})-wTTO)*1000), round(double(T.trials{i}.shanksTrial.clustData{clustInd}.spikeTimes)/19.530));
    end
    
    S.samplingWindowSpikes.tindHit{Snums(k)} = tindHit;
    S.samplingWindowSpikes.tindMiss{Snums(k)} = tindMiss;
    S.samplingWindowSpikes.tindFA{Snums(k)} = tindFA;
    S.samplingWindowSpikes.tindCR{Snums(k)} = tindCR;
    S.samplingWindowSpikes.cropInd{Snums(k)} = cropInd;
    S.samplingWindowSpikes.cropSpikes{Snums(k)} = cropSpikes;

end