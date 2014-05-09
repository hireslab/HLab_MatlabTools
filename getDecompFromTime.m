% timeVect is a cell array of time vectors that contain every time element
% you need to get theta of.  trialVect is a vector of trials equal to the
% length of the timeVect cell array. T is the Trial Array.
% SAH 4/12
function [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] = getDecompFromTime(timeVect, trialVect, T)
         hh              = cell(length(timeVect),1);
         amplitude       = cell(length(timeVect),1);
         filteredSignal  = cell(length(timeVect),1);
         setpoint        = cell(length(timeVect),1);
         amplitudeS      = cell(length(timeVect),1);
         setpointS       = cell(length(timeVect),1);
         phase           = cell(length(timeVect),1);
         phaseS          = cell(length(timeVect),1);
         
    for i = 1:length(trialVect)
        [~,tidx,~] =  intersect(round(T.trials{trialVect(i)}.whiskerTrial.time{1}*1000), timeVect{i});
        [hhX amplitudeX  filteredSignalX setpointX amplitudeSX setpointSX phaseX phaseSX] =  SAHWhiskerDecomposition(T.trials{trialVect(i)}.whiskerTrial.thetaAtBase{1});
         hh{i}              = hhX(tidx) ;
         amplitude{i}       = amplitudeX(tidx) ;
         filteredSignal{i}  = filteredSignalX(tidx);  
         setpoint{i}        = setpointX(tidx)  ;
         amplitudeS{i}      = amplitudeSX(tidx);  
         setpointS{i}       = setpointSX(tidx);  
         phase{i}           = phaseX(tidx)  ;
         phaseS{i}          = phaseSX(tidx); 
        
        
        
    end
end

    
        