figure(11);clf;
subplot(2,2,1)
  T.plot_spike_raster(T.hitTrialNums)
  title('Hit')
  subplot(2,2,2)
  T.plot_spike_raster(T.correctRejectionTrialNums)
  
    title('CR')

  subplot(2,2,3)
  T.plot_spike_raster(T.falseAlarmTrialNums)
  
    title('FA')

  subplot(2,2,4)
  T.plot_spike_raster(T.missTrialNums)
  
    title('Miss')

 
  
  figure(12);clf;
subplot(2,2,1)
  T.plot_spike_raster(T.hitTrialNums,'BehavTrialNum')
  title('Hit')
  subplot(2,2,2)
  T.plot_spike_raster(T.correctRejectionTrialNums,'BehavTrialNum')
  
    title('CR')

  subplot(2,2,3)
  T.plot_spike_raster(T.falseAlarmTrialNums,'BehavTrialNum')
  
    title('FA')

  subplot(2,2,4)
  T.plot_spike_raster(T.missTrialNums,'BehavTrialNum')
  
    title('Miss')

 
  
  