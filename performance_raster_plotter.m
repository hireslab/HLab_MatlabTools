res =.2
figure
hold on
plot([res/2:res:5],T.PSTH([T.hitTrialNums],[res/2:res:5]))
plot([res/2:res:5],T.PSTH([T.missTrialNums],[res/2:res:5]),'-k')
plot([res/2:res:5],T.PSTH([T.falseAlarmTrialNums],[res/2:res:5]),'-g')
plot([res/2:res:5],T.PSTH([T.correctRejectionTrialNums],[res/2:res:5]),'-r')
set(gca,'box','off','TickDir','out','FontSize',20,'LineWidth',2); xlabel('Sec'); ylabel('Spikes/sec')

figure
subplot(4,1,1)
 T.plot_spike_raster(T.hitTrialNums,'Sequential',[],'lines')
 subplot(4,1,2)
 T.plot_spike_raster(T.missTrialNums,'Sequential',[],'lines')
 subplot(4,1,3)
 T.plot_spike_raster(T.falseAlarmTrialNums,'Sequential',[],'lines')
 subplot(4,1,4)
 T.plot_spike_raster(T.correctRejectionTrialNums,'Sequential',[],'lines')
 
 set(h_spikes,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 3.25])
print(h_spikes, '-depsc',[array.mouseName '-' array.cellNum '-' 'PerformanceRaster.eps']);
