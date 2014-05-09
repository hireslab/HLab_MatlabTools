figure
ymax=max([length(T.hitTrialNums) length(T.correctRejectionTrialNums) length(T.falseAlarmTrialNums)])
subplot(2,2,1);
T.plot_lick_raster(T.hitTrialNums)
hold on
T.plot_spike_raster(T.hitTrialNums)
title('Hit')
ylim([0 ymax])

subplot(2,2,2);
T.plot_spike_raster(T.missTrialNums)
hold on
T.plot_lick_raster(T.missTrialNums)
title('Miss')
ylim([0 ymax])

subplot(2,2,3);
T.plot_spike_raster(T.correctRejectionTrialNums)
hold on
T.plot_lick_raster(T.correctRejectionTrialNums)
title('CR')
ylim([0 ymax])

subplot(2,2,4);
T.plot_spike_raster(T.falseAlarmTrialNums)
hold on
T.plot_lick_raster(T.falseAlarmTrialNums)
title('FA')
ylim([0 ymax])