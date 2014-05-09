cellNum = 16
load([SUdir 'TrialArrays\' SU.trialArrayName{cellNum}])
load([SUdir 'ConTA\' SU.contactsArrayName{cellNum}])
load([SUdir 'CellAnalysisArrays\' SU.trialArrayName{cellNum}(13:end-4)])


h_fig4 = figure(4);clf;hold on;
set(gcf,'Position',[25 25 500 500],'PaperOrientation','portrait','PaperPosition',[0 0 5 5],'PaperSize',[5 5]);

ctind = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
tct = ctind(find(cellfun(@(x)x.trialContactType >= 1,contacts(ctind))));
tct = tct(1:10);
tct2 = ctind(find(cellfun(@(x)x.trialContactType == 2,contacts(ctind))));
tct = cat(2,tct(1:5),tct2(3:8))

for i = 1:10
    cW = T.trials{tct(i)}.whiskerTrial;
    cS = T.trials{tct(i)}.spikesTrial;
    cind = contacts{tct(i)}.contactInds{1};
    timeshift = cW.time{1}(cind(1))
    yshift = 65*i;
%     M0combo=cW.M0I{1};
%     M0combo(abs(M0combo)>1e-7)=NaN;
%     M0combo(cind)=cW.M0{1}(cind);
%     
    
    
    
    plot(T.trials{tct(i)}.whiskerTrial.time{1}-timeshift,T.trials{tct(i)}.whiskerTrial.thetaAtBase{1}+yshift,'.-',...
        'Color',[0 0 0],'linewidth',2, 'MarkerSize',3,'MarkerEdgeColor',[.5 .5 .5])
    
            plot(T.trials{tct(i)}.whiskerTrial.time{1}(contacts{tct(i)}.contactInds{1})-timeshift,T.trials{tct(i)}.whiskerTrial.thetaAtBase{1}(contacts{tct(i)}.contactInds{1})+yshift,'.',...
        'Color',[0 0 0],'linewidth',2, 'MarkerSize',3,'MarkerEdgeColor',[1 0 0])
    
    %plot(T.trials{tct(i)}.whiskerTrial.time{1}(cind)-timeshift,-contacts{tct(i)}.M0comboAdj{1}(cind)+yshift,'r.','MarkerSize',8)
 
end
title(['Whisker motion aligned to first contact (5 Consecutive Protaction, Retraction Contact Trials)'])

set(gca,'XLim',[-.1 .5],'YLim', [0 1.1]*yshift,'Color','w');
xlabel('Time from first contact (s)')
ylabel('Theta at base')
print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\ExampleTraces\Theta_' T.mouseName '_Cell_' num2str(T.cellNum)])
h_fig5 = figure(5);clf;hold on;
set(gcf,'Position',[25 25 500 500],'PaperOrientation','portrait','PaperPosition',[0 0 5 5],'PaperSize',[5 5]);

for i = 1:10
    cW = T.trials{tct(i)}.whiskerTrial;
    cS = T.trials{tct(i)}.spikesTrial;
    cind = contacts{tct(i)}.contactInds{1};
    timeshift = cW.time{1}(cind(1))
    yshift = .15*i;

    
    

        plot(T.trials{tct(i)}.whiskerTrial.time{1}-timeshift,T.trials{tct(i)}.whiskerTrial.deltaKappa{1}+yshift,'.-',...
        'Color',[0 0 0],'linewidth',2, 'MarkerSize',3,'MarkerEdgeColor',[.5 .5 .5])
        plot(T.trials{tct(i)}.whiskerTrial.time{1}(contacts{tct(i)}.contactInds{1})-timeshift,T.trials{tct(i)}.whiskerTrial.deltaKappa{1}(contacts{tct(i)}.contactInds{1})+yshift,'.',...
        'Color',[0 0 0],'linewidth',2, 'MarkerSize',3,'MarkerEdgeColor',[1 0 0])
    
    
 
end
title(['Change in whisker curvature (5 Consecutive Protaction, Retraction Contact Trials)'])

set(gca,'XLim',[-.1 .5],'YLim', [0 1.1]*yshift,'Color','w');
xlabel('Time from first contact (s)')
ylabel('delta kappa')
%print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\ExampleTraces\deltaKappa_' T.mouseName '_Cell_' num2str(T.cellNum)])

