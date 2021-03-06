% timeVect is a cell array of time vectors that contain every time element
% you need to get theta of.  trialVect is a vector of trials equal to the
% length of the timeVect cell array. T is the Trial Array.
% SAH 4/12
function theta = getThetaFromTime(timeVect, trialVect, T)

    theta = cell(length(timeVect),1)
    for i = 1:length(timeVect)
        [~,tidx,~] =  intersect(round(T.trials{trialVect(i)}.whiskerTrial.time{1}*1000), timeVect{i});
        theta{i} = T.trials{trialVect(i)}.whiskerTrial.thetaAtBase{1}(tidx);
    end
end

    
        