k=83 
tmax=T.trials{1}.spikesTrial.sweepLengthInSamples/T.trials{1}.spikesTrial.sampleRate;
cropind=[];   cind=[];   y1=[];   x1=[];    y2=[];   x2=[];
    cropind=T.trials{k}.whiskerTrial.time{1} > params.poleOffset+T.trials{k}.behavTrial.pinDescentOnsetTime & T.trials{k}.whiskerTrial.time{1} < .3+T.trials{k}.behavTrial.pinAscentOnsetTime;
    cind=contacts{params.sweepNum}.contactInds{1};
    
    M0combo=T.trials{k}.whiskerTrial.M0I{1};
    M0combo(abs(M0combo)>1e-7)=NaN;
    M0combo(cind)=T.trials{k}.whiskerTrial.M0{1}(cind);
    set(gca,'XLim',[0 tmax]);
    figure
    
    subplot(5,1,1)
    plot(T.trials{k}.whiskerTrial.time{1},T.trials{k}.whiskerTrial.thetaAtBase{1},'-k.','MarkerSize',6)    
    xlim([.5 1.5])
    set(gca,'XTickLabel',[])
    ylabel('Theta at base (deg)')

    subplot(5,1,2)
     plot(T.trials{k}.whiskerTrial.time{1},smooth(diff([0 T.trials{k}.whiskerTrial.thetaAtBase{1}])/1e-3,5),'-k.','MarkerSize',6)
    xlim([.5 1.5])
    set(gca,'XTickLabel',[])
    ylabel('Velocity (deg/s)')

    
    subplot(5,1,3)
    plot(T.trials{k}.whiskerTrial.time{1},smooth(diff(diff([0 0 T.trials{k}.whiskerTrial.thetaAtBase{1}]))/1e-6,5),'-k.','MarkerSize',6)
    xlim([.5 1.5])
    set(gca,'XTickLabel',[])
        ylabel('Acceleration (deg/s^2)')

        
    subplot(5,1,4)

    cla;
    plot(T.trials{k}.whiskerTrial.time{1},M0combo,'-k.','MarkerSize',6)
    hold on;
    plot(T.trials{k}.whiskerTrial.time{1}(cind),T.trials{k}.whiskerTrial.M0{1}(cind),'r.','MarkerSize',6)
   % plot(repmat(T.trials{k}.spikesTrial.spikeTimes/10000+.01,1,2)',repmat([.5e-7 1e-7],length(T.trials{k}.spikesTrial.spikeTimes),1)','-k')
   % plot(repmat(T.trials{k}.beamBreakTimes+.01,1,2)',repmat([.5e-7 1e-7],length(T.trials{k}.beamBreakTimes+.01),1)','-m')

    T.trials{k}.beamBreakTimes+.01
    ylabel('M0 (N*m)');
    xlim([.5 1.5])
    ylim([-3 1]*1e-7)
    set(gca,'XTickLabel',[])

    subplot(5,1,5)
    plot(T.trials{k}.whiskerTrial.time{1},contacts{k}.FaxialAdj{1},'-k.','MarkerSize',6)
    hold on
    plot(T.trials{k}.whiskerTrial.time{1}(cind),contacts{k}.FaxialAdj{1}(cind),'r.','MarkerSize',6)

    xlim([.5 1.5])
        ylim([-2 .5]*1e-5)

    xlabel('Time (s)')
    ylabel('Faxial (N)')
    
    set(gca,'XLim',[.5 1.5]);
    set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 7 7])
print(gcf, '-depsc',['TrialCaluclationsExample.eps']);


