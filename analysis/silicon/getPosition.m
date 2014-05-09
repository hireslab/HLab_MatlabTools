function pos = getPosition(array, trials, span)

vel = cell(max(trials),1)

theta(trials) = cellfun(@(x)x.whiskerTrial.thetaAtBase{1},array.trials(trials), 'UniformOutput',0);
time(trials)  = cellfun(@(x)x.whiskerTrial.time{1},array.trials(trials),        'UniformOutput',0);

if nargin <3
    
    for t = trials
        pos{t} =theta{t};
    end
elseif nargin == 3
    for t = trials
        pos{t} = smooth(pos{t},span,'moving')';
    end
else
    display('Error : Wrong Number of Inputs')
end





