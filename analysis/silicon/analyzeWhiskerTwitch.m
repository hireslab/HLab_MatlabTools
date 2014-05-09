
crTrials = find(T.correctRejectionTrialInds) ;
crConWhiskArray=[];
crNoconWhiskArray=[];

crCon = crTrials(find(cellfun(@(x)x.trialContactType,contacts(crTrials))))
crNocon = crTrials(find(cellfun(@(x)x.trialContactType,contacts(crTrials))==0))

for i = 1:length(crCon)
   t = find(T.trials{crCon(i)}.whiskerTrial.time{1} >= T.trials{crCon(i)}.behavTrial.pinDescentOnsetTime & ...
        T.trials{crCon(i)}.whiskerTrial.time{1} < T.trials{crCon(i)}.behavTrial.pinDescentOnsetTime +.2);
    crConWhiskArray(t-round( T.trials{crCon(i)}.behavTrial.pinDescentOnsetTime*1000)+1,i) = smooth(([0 diff([ T.trials{crTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]),5); 
   
end

for i = 1:length(crNocon)
   t = find(T.trials{crNocon(i)}.whiskerTrial.time{1} >= T.trials{crNocon(i)}.behavTrial.pinDescentOnsetTime & ...
        T.trials{crNocon(i)}.whiskerTrial.time{1} < T.trials{crNocon(i)}.behavTrial.pinDescentOnsetTime +.2);
    crNoconWhiskArray(t-round( T.trials{crNocon(i)}.behavTrial.pinDescentOnsetTime*1000)+1,i) = smooth(([0 diff([ T.trials{crTrials(i)}.whiskerTrial.thetaAtBase{1}(t)])]),5); 
   
end

figure(1);cla;hold on

%  plot(crConWhiskArray),'g')
%  plot(nanmean(crNoconWhiskArray,2),'k')


figure(1);cla;hold on

colors=prism(20)    
[tmp,sind]=sortrows(mean(abs(crNoconWhiskArray(40:50,:)))')

for i=1:length(crNocon)
plot(4*crNoconWhiskArray(:,sind(i))+(i),'-','color',[.5 .5 .5])    

    cS=T.trials{crNocon(i)}.shanksTrial;

for j = 1:length(cS.clustData)
        try
            st = double(cS.clustData{j}.spikeTimes)/cS.sampleRate+T.whiskerTrialTimeOffset-T.trials{crNocon(i)}.behavTrial.pinDescentOnsetTime;
            st = st(st>0 & st<.1)*1000;
            
            
            plot(st,sind(i)+.01*j,'.','color',colors(j,:))
        
        end
 

end
    
end
set(gca,'XLim',[0 100])
xlabel('Time from pole Descent (ms)')
ylabel('Trial')
title([T.sessionName ' NonContact CR'])

figure(2);cla;hold on

colors=prism(20)    
[tmp,sind]=sortrows(mean(abs(crConWhiskArray(40:50,:)))')

for i=1:length(crCon)
plot(4*crConWhiskArray(:,sind(i))+(i),'-','color',[.5 .5 .5])    

    cS=T.trials{crCon(i)}.shanksTrial;

for j = 1:length(cS.clustData)
        try
            st = double(cS.clustData{j}.spikeTimes)/cS.sampleRate+T.whiskerTrialTimeOffset-T.trials{crCon(i)}.behavTrial.pinDescentOnsetTime;
            st = st(st>0 & st<.1)*1000;
            
            
            plot(st,sind(i)+.01*j,'.','color',colors(j,:))
        
        end
 

end
    
end
set(gca,'XLim',[0 100])
xlabel('Time from pole Descent (ms)')
ylabel('Trial')
title([T.sessionName ' Contact CR'])