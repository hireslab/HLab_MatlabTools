% timeVect is a cell array of time vectors that contain every time element
% you need to get theta of.  trialVect is a vector of trials equal to the
% length of the timeVect cell array. T is the Trial Array.
% SAH 4/12
function velocity = getVelocityFromTime(timeVect, trialVect, T);

    vel = getVelocity(T, trialVect, 5);
    for i = 1:length(timeVect)
        [~,tidx,~] =  intersect(round(T.trials{trialVect(i)}.whiskerTrial.time{1}*1000), timeVect{i});
        vel{i} = vel{i}(tidx);
    end
end

    
        