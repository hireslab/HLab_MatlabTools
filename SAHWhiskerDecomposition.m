 function [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] =  SAHWhiskerDecomposition(theta)
 %% calculate whisker amplitude and setpoint
 
 
 sampleRate=  1000;
 
 % make any nan thetaAtBase = mean of the surrounding points (10 on each
 % side)
 try
 theta(isnan(theta)) = nanmean(theta(repmat(find(isnan(theta)),21,1)+repmat([-10:10]',1,length(find(isnan(theta))))));
 catch
      theta(isnan(theta)) = nanmean(theta);
 end
 
 
 BandPassCutOffsInHz = [6 60];  %%check filter parameters!!!
 W1 = BandPassCutOffsInHz(1) / (sampleRate/2);
 W2 = BandPassCutOffsInHz(2) / (sampleRate/2);
 [b,a]=butter(2,[W1 W2]);
 filteredSignal = filtfilt(b, a, theta);

[b,a]=butter(2, 6/ (sampleRate/2),'low');
new_setpoint = filtfilt(b,a,theta-filteredSignal);
hh=hilbert(filteredSignal);

amplitude=abs(hh);
setpoint=new_setpoint;

amplitudeS=smooth(amplitude,32,'moving');
amplitudeDS=amplitudeS(16:32:end);

setpointS=smooth(setpoint,32,'moving');
setpointDS=setpointS(16:32:end);

phase = angle(hh);
phaseS = smooth(phase,32,'moving');
phaseDS = phaseS(16:32:end);
 
%%


