trialArrayDir = 'Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\'
contactsDir = 'Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\'
printdir = 'Z:\users\Andrew\Whisker Project\Figures\WhiskingVariables\'

h_fig1 = figure(1);clf;hold on;set(gcf,'Position',[25 25 500 500],  'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize',[16 12]);
h_fig2 = figure(2);clf;hold on;set(gcf,'Position',[525 25 500 500], 'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize',[16 12]);
h_fig3 = figure(3);clf;hold on;set(gcf,'Position',[1025 25 500 500],'PaperOrientation','portrait','PaperPosition',[0 0 16 12],'PaperSize',[16 12]);


cd(trialArrayDir)
dTrial = dir('*.mat');
cd(contactsDir)
dContacts = dir('*.mat');

for fileNum = 1 : length(dTrial)
    cd(trialArrayDir)
    load(dTrial(fileNum).name)
    
    cd(contactsDir)
    load(dContacts(fileNum).name)


trialNums = find(T.whiskerTrialInds);
for k = trialNums
    W.theta{k} =  T.trials{k}.whiskerTrial.thetaAtBase{1};
    W.time{k} = T.trials{k}.whiskerTrial.time{1};
    [W.hh{k} W.amplitude{k}  W.filteredSignal{k} W.setpoint{k} W.amplitudeS{k} W.setpointS{k} W.phase{k} W.phaseS{k}] =  SAHWhiskerDecomposition(W.theta{k});
    if isempty(T.trials{k}.behavTrial.answerLickTime)
        W.firstLick{k} = 1.5;
    else
        W.firstLick{k}=T.trials{k}.behavTrial.answerLickTime;
    end
end

W.vel = getVelocity(T,trialNums,5)';
W.acc = getAccel(T,trialNums,5)';
%%
contactProcessedTrials = find(cellfun(@(x)isfield(x,'trialContactType'),contacts))
noCon = contactProcessedTrials(cellfun(@(x)x.trialContactType == 0, contacts(contactProcessedTrials)));
yesCon = contactProcessedTrials(cellfun(@(x)x.trialContactType > 0, contacts(contactProcessedTrials)));

figure(h_fig1)
subplot(3,4,fileNum);
cla;hold on

for k = trialNums
    
    whiskingInds = find(W.amplitude{k} > 2 & W.time{k} < W.firstLick{k});
    
    if sum(noCon ==k)
        markerType = '.b';
    else
        markerType = '.r';
    end
    plot(W.phase{k}(whiskingInds),W.acc{k}(whiskingInds),markerType,'MarkerSize',4);
    
end
axis([-pi pi -600000 600000])
text(0, 550000, [T.mouseName ' ' T.sessionName]);



figure(h_fig2)
subplot(3,4,fileNum);cla;hold on

for k = trialNums
    
    whiskingInds = find(W.amplitude{k} > 2 & W.time{k} < W.firstLick{k});
    
    if sum(noCon ==k)
        markerType = '.b';
    else
        markerType = '.r';
    end
    plot(W.phase{k}(whiskingInds),W.vel{k}(whiskingInds),markerType,'MarkerSize',4);
    
end
axis([-pi pi -4000 4000])
text(0, 3600, [T.mouseName ' ' T.sessionName]);

figure(h_fig3)
subplot(3,4,fileNum);cla;hold on
for k = trialNums
    
    whiskingInds = find(W.amplitude{k} > 2 & W.time{k} < W.firstLick{k});
    
    if sum(noCon ==k)
        markerType = '.b';
    else
        markerType = '.r';
    end
    plot(W.phase{k}(whiskingInds),W.theta{k}(whiskingInds),markerType,'MarkerSize',4);
    
end
text(-3, 55, [T.mouseName ' ' T.sessionName]);
set(gca,'XLim',[-pi pi])

end


figure(h_fig1)
text(0, 500000, 'No Contact Trials', 'color','b');
text(0, 450000, 'Contact Trials', 'color','r');
xlabel('Phase (rad)')
ylabel('Accel (deg/s^2)')
title('Phase Vs. Acceleration (5ms)')

figure(h_fig2)
text(0, 3300, 'No Contact Trials', 'color','b');
text(0, 3000, 'Contact Trials', 'color','r');
xlabel('Phase (rad)')
ylabel('Velocity (deg/s)')
title('Phase Vs. Velocity (5ms)')

figure(h_fig3)
text(-3, 50, 'No Contact Trials', 'color','b');
text(-3, 45, 'Contact Trials', 'color','r');
xlabel('Phase (rad)')
ylabel('Theta (deg)')
title('Phase Vs. Theta')

print(h_fig1, '-depsc', [printdir 'PhaseVsAccel_'])% T.mouseName '_' T.sessionName])
print(h_fig2, '-depsc', [printdir 'PhaseVsVelocity_'])% T.mouseName '_' T.sessionName])
print(h_fig3, '-depsc', [printdir 'PhaseVsTheta_'])% T.mouseName '_' T.sessionName])
