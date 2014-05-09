phase=nan(length(contacts),1);
pos=nan(length(contacts),1);
vel=nan(length(contacts),1);
figure(2);cla;hold on;
trialTypes=T.hitTrialInds+2*T.missTrialInds+3*T.falseAlarmTrialInds+4*T.correctRejectionTrialInds;
trialColor={'b','k','g','r'};


for k=find(cellfun(@(x)x.trialContactType,contacts))
   try
       
       firstContact{k}=contacts{k}.segmentInds{1}(1,1);
        y=hilbert(smooth(T.trials{k}.whiskerTrial.thetaAtBase{1},5));
        a=angle(y);
        phase(k)=a(firstContact{k});
        pos(k)=T.trials{k}.whiskerTrial.thetaAtBase{1}(firstContact{k});
        vel(k)=500*(T.trials{k}.whiskerTrial.thetaAtBase{1}(firstContact{k}-2)-T.trials{k}.whiskerTrial.thetaAtBase{1}(firstContact{k}));
        
        tmp=find(abs(diff(a))>6);
        tmp2=tmp(tmp<firstContact{k});
        tmp3=tmp(tmp>firstContact{k});
       % tmp=find(find(abs(diff(a))>6)<firstContact{k});
        phaseBounds(k,:)=[tmp2(end),tmp3(1)];
        
        %phase(k)=angle(real(y(firstContact{k})),imag(y(firstContact{k})));
        plot(1:phaseBounds(k,2)-phaseBounds(k,1),a(phaseBounds(k,1)+1:phaseBounds(k,2)),trialColor{trialTypes(k)});
        plot(firstContact{k}-phaseBounds(k,1),a(firstContact{k}),['o' trialColor{trialTypes(k)}])
   end

end
trials=1:length(T.trials)
figure(1);cla;
plot(trials(T.correctRejectionTrialInds),phase(T.correctRejectionTrialInds),'r.')
hold on 
plot(trials(T.hitTrialInds),phase(T.hitTrialInds),'.')
plot(trials(T.missTrialInds),phase(T.missTrialInds),'.k')
plot(trials(T.falseAlarmTrialInds),phase(T.falseAlarmTrialInds),'.g')   
ylabel('phase @ contact');


figure(3);cla;
plot(trials(T.correctRejectionTrialInds),pos(T.correctRejectionTrialInds),'r.')
hold on 
plot(trials(T.hitTrialInds),pos(T.hitTrialInds),'.')
plot(trials(T.missTrialInds),pos(T.missTrialInds),'.k')
plot(trials(T.falseAlarmTrialInds),pos(T.falseAlarmTrialInds),'.g')
ylabel('theta @ contact');

figure(4);cla;
plot(trials(T.correctRejectionTrialInds),vel(T.correctRejectionTrialInds),'r.')
hold on 
plot(trials(T.hitTrialInds),vel(T.hitTrialInds),'.')
plot(trials(T.missTrialInds),vel(T.missTrialInds),'.k')
plot(trials(T.falseAlarmTrialInds),vel(T.falseAlarmTrialInds),'.g')   
ylabel('velocity @ contact');


