trialEndTime=4.5;
names=fieldnames(U.AH24.info);

poleTime=mean(cellfun(@(x)x.pinDescentOnsetTime,U.AH24.behavTrials))+.75;
tmp=cellfun(@(x)x.answerLickTime,U.AH24.behavTrials,'UniformOutput',0);
meanAnswerTime=mean(cellfun(@(x)x,tmp(U.AH24.info.hitTrialInds | U.AH24.info.falseAlarmTrialInds)));

U.AH24.spikeRate.prepole=T.spikeRateInHzTimeWindow(0,poleTime);

U.AH24.spikeRate.decision=T.spikeRateInHzTimeWindow(poleTime,meanAnswerTime);

for i=find(T.hitTrialInds | T.falseAlarmTrialInds);
    U.AH24.spikeRate.decision(i)=sum(T.trials{i}.spikesTrial.spikeTimes/10000 > poleTime ...
        & T.trials{i}.spikesTrial.spikeTimes/10000 < T.trials{i}.behavTrial.answerLickTime) ...
        / (T.trials{i}.behavTrial.answerLickTime - poleTime);
end

U.AH24.spikeRate.postdecision=T.spikeRateInHzTimeWindow(meanAnswerTime,trialEndTime);

for i=find(T.hitTrialInds | T.falseAlarmTrialInds);
    U.AH24.spikeRate.postdecision(i)=sum( T.trials{i}.spikesTrial.spikeTimes/10000 > ...
        T.trials{i}.behavTrial.answerLickTime & T.trials{i}.spikesTrial.spikeTimes/10000 < trialEndTime) ...
        / (trialEndTime - T.trials{i}.behavTrial.answerLickTime);
end

for i=1:4;
    U.AH24.spikeRate.typeMeans.prepole(1,i)      = nanmean(U.AH24.spikeRate.prepole(U.AH24.info.(names{9+2*i})));
    U.AH24.spikeRate.typeMeans.decision(1,i)     = nanmean(U.AH24.spikeRate.decision(U.AH24.info.(names{9+2*i})));
    U.AH24.spikeRate.typeMeans.postdecision(1,i) = nanmean(U.AH24.spikeRate.postdecision(U.AH24.info.(names{9+2*i})));

    U.AH24.spikeRate.typeMeans.prepole(2,i)      = std(U.AH24.spikeRate.prepole(U.AH24.info.(names{9+2*i})));
    U.AH24.spikeRate.typeMeans.decision(2,i)     = std(U.AH24.spikeRate.decision(U.AH24.info.(names{9+2*i})));
    U.AH24.spikeRate.typeMeans.postdecision(2,i) = std(U.AH24.spikeRate.postdecision(U.AH24.info.(names{9+2*i})));

end

U.AH24.spikeRate.typeMeans.names={'hit','miss','FA','CR'}

for i=1:5;
    U.AH24.spikeRate.contactMeans.prepole(1,i)      = nanmean(U.AH24.spikeRate.prepole (find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));
    U.AH24.spikeRate.contactMeans.decision(1,i)     = nanmean(U.AH24.spikeRate.decision(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));
    U.AH24.spikeRate.contactMeans.postdecision(1,i) = nanmean(U.AH24.spikeRate.postdecision(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));

    U.AH24.spikeRate.contactMeans.prepole(2,i)      = std(U.AH24.spikeRate.prepole (find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));
    U.AH24.spikeRate.contactMeans.decision(2,i)     = std(U.AH24.spikeRate.decision(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));
    U.AH24.spikeRate.contactMeans.postdecision(2,i) = std(U.AH24.spikeRate.postdecision(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i-1)));

end

U.AH24.spikeRate.contactMeans.names={'none','go/pro','go/ret','nogo/pro','nogo/ret'}