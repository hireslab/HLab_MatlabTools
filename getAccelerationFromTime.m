% timeVect is a cell array of time vectors that contain every time element
% you need to get theta of.  trialVect is a vector of trials equal to the
% length of the timeVect cell array. T is the Trial Array.
% SAH 4/12
function acc = getAccelerationFromTime(timeVect, trialVect, T)

    acc = getAccel(T, trialVect, 5);
    for i = 1:length(timeVect)
        [~,tidx,~] =  intersect(round(T.trials{trialVect(i)}.whiskerTrial.time{1}*1000), timeVect{i});
        acc{i} = acc{i}(tidx);
    end
end

    
        