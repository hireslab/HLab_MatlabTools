h_fig4 = figure(4);clf;hold on;
set(gcf,'Position',[25 25 1500 1000],'PaperOrientation','portrait','PaperPosition',[0 0 9 6],'PaperSize',[9 6]);

ctind = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
tct = ctind(find(cellfun(@(x)x.trialContactType == 1,contacts(ctind))));
tct = tct(40:end)
 tct = tct(1:10);
 tct2 = ctind(find(cellfun(@(x)x.trialContactType == 2,contacts(ctind))));
 tct = cat(2,tct,tct2(10:20))
cellID1=1
cellID2=2

for i = 1:20
    cW = T.trials{tct(i)}.whiskerTrial;
    cS1 = T.trials{tct(i)}.shanksTrial.clustData{cellID1};
    cS2 = T.trials{tct(i)}.shanksTrial.clustData{cellID2};

    cind = contacts{tct(i)}.contactInds{1};
    timeshift = cW.time{1}(cind(1))
    yshift = 4e-7*i;
    M0combo=cW.M0I{1};
    M0combo(abs(M0combo)>1e-7)=NaN;
    M0combo(cind)=cW.M0{1}(cind);
    
    
    
    
    plot(T.trials{tct(i)}.whiskerTrial.time{1}(setdiff(cind,1:2000))-timeshift,repmat(yshift,length(setdiff(cind,1:2000)),1),'-',...
        'Color',[.7 .7 .7], 'MarkerSize',6)
    plot(T.trials{tct(i)}.whiskerTrial.time{1}(cind)-timeshift,contacts{tct(i)}.M0comboAdj{1}(cind)+yshift,'c.','MarkerSize',6)
    
    
    
    
    try
        %plot(double(cS1.spikeTimes)/cS1.sampleRate-T.whiskerTrialTimeOffset-timeshift,yshift,'k.','MarkerSize',6);
        plot(double(cS2.spikeTimes)/cS2.sampleRate-T.whiskerTrialTimeOffset-timeshift,yshift,'r.','MarkerSize',6);

    end
    
    
    
    try
    plot(T.trials{tct(i)}.behavTrial.beamBreakTimes-timeshift,yshift,'mo','MarkerSize',6,'LineWidth',1)
    end
end
title(['Moment, Spikes & Licks '])

set(gca,'XLim',[-.5 .7],'YLim', [0 1.05]*yshift,'Color','w');
xlabel('Time from first touch (s)')
ylabel('Moment (N * m')
print('-depsc', ['Z:\users\Andrew\Whisker Project\Interesting Analysis\S94ExampleM0Spikes'])

