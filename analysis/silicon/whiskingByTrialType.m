faTrials = find(T.falseAlarmTrialInds);
hitTrials = find(T.hitTrialInds);
missTrials = find(T.missTrialInds);
crTrials = find(T.correctRejectionTrialInds) ;


faWhiskArray = nan(201,length(faTrials));
hitWhiskArray = nan(201,length(hitTrials));
missWhiskArray = nan(201,length(missTrials));
crWhiskArray = nan(201,length(crTrials));



for i = 1:length(faTrials)
    t = find(T.trials{faTrials(i)}.whiskerTrial.time{1} >= T.trials{i}.behavTrial.pinAscentOnsetTime & ...
        T.trials{faTrials(i)}.whiskerTrial.time{1} < T.trials{i}.behavTrial.pinAscentOnsetTime +.2);
    faWhiskArray(t-round( T.trials{i}.behavTrial.pinAscentOnsetTime*1000)+1,i) = ([0 diff([ T.trials{faTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]); 
   
end


for i = 1:length(hitTrials)
   t = find(T.trials{hitTrials(i)}.whiskerTrial.time{1} >= T.trials{i}.behavTrial.pinAscentOnsetTime & ...
        T.trials{hitTrials(i)}.whiskerTrial.time{1} < T.trials{i}.behavTrial.pinAscentOnsetTime +.2);
    hitWhiskArray(t-round( T.trials{i}.behavTrial.pinAscentOnsetTime*1000)+1,i) = ([0 diff([T.trials{hitTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]); 
   
end
for i = 1:length(missTrials)
   t = find(T.trials{missTrials(i)}.whiskerTrial.time{1} >= T.trials{i}.behavTrial.pinAscentOnsetTime & ...
        T.trials{missTrials(i)}.whiskerTrial.time{1} < T.trials{i}.behavTrial.pinAscentOnsetTime +.2);
    missWhiskArray(t-round( T.trials{i}.behavTrial.pinAscentOnsetTime*1000)+1,i) = ([0 diff([ T.trials{missTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]); 
   
end
for i = 1:length(crTrials)
   t = find(T.trials{crTrials(i)}.whiskerTrial.time{1} >= T.trials{i}.behavTrial.pinAscentOnsetTime & ...
        T.trials{crTrials(i)}.whiskerTrial.time{1} < T.trials{i}.behavTrial.pinAscentOnsetTime +.2);
    crWhiskArray(t-round( T.trials{i}.behavTrial.pinAscentOnsetTime*1000)+1,i) = ([0 diff([ T.trials{crTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]); 
   
end

figure(1);cla;hold on
plot(nanmean(faWhiskArray,2),'g')
plot(nanmean(missWhiskArray,2),'k')
plot(nanmean(crWhiskArray,2),'r')
plot(nanmean(hitWhiskArray,2),'b')

T.trials{1}.behavTrial.pinAscentOnsetTime