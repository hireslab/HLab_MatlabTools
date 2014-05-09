h_fig4 = figure(4);clf;hold on;
set(gcf,'Position',[25 25 1500 1000],'PaperOrientation','portrait','PaperPosition',[0 0 15 10],'PaperSize',[15 10]);

ctind = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
tct = ctind(find(cellfun(@(x)x.trialContactType == 0,contacts(ctind))));
%tct = tct(1:end)
 tct = tct([15:35]);
% tct2 = ctind(find(cellfun(@(x)x.trialContactType == 2,contacts(ctind))));
% tct = cat(2,tct,tct2)
cellID=3

for i = 1:20
    cW = T.trials{tct(i)}.whiskerTrial;
    theta = cW.thetaAtBase{1}(~isnan(cW.thetaAtBase{1}));
    cS = T.trials{tct(i)}.shanksTrial.clustData{cellID};
    cind = contacts{tct(i)}.contactInds{1};
    yshift =30*i;
    %M0combo=cW.M0I{1};
    %M0combo(abs(M0combo)>1e-7)=NaN;
    %M0combo(cind)=cW.M0{1}(cind);
    
    [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] =  SAHWhiskerDecomposition(theta);
    
    timeshift = cW.time{1}(find(amplitude >10 , 1,'first'))

    
    try
    plot(T.trials{tct(i)}.whiskerTrial.time{1}(~isnan(cW.thetaAtBase{1}))-timeshift,theta+yshift,'.',...
        'Color',[.7 .7 .7], 'MarkerSize',6)
    %plot(T.trials{tct(i)}.whiskerTrial.time{1}(cind)-timeshift,-contacts{tct(i)}.M0comboAdj{1}(cind)+yshift,'r.','MarkerSize',8)
    end
    
    
    
    try
        plot(double(cS.spikeTimes)/cS.sampleRate-T.whiskerTrialTimeOffset-timeshift,yshift,'k.','MarkerSize',10);
        
    end
    
    
    
    try
    plot(T.trials{tct(i)}.behavTrial.beamBreakTimes-timeshift,yshift,'mo','MarkerSize',8,'LineWidth',3)
    end
end
title(['Amplitude, Spikes & Licks ' T.mouseName ' ' num2str(T.shankNum(cellID)) '-' num2str(T.cellNum(cellID))...
    ' (20 Example Trials)'])

set(gca,'XLim',[-0.1 .3],'YLim', [0 1.05]*yshift,'Color','w');
xlabel('Time from Amplitude Crossing (s)')
ylabel('Whisking Amplitude')
print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\ExampleTraces\WhiskAmpSpikes_' T.mouseName '_Cell_'...
    num2str(T.shankNum(cellID)) '-' num2str(T.cellNum(cellID))])
grid off