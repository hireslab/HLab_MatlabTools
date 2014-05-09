function acc = getAccel(array, trials, span)

vel = cell(max(trials),1)
acc = cell(max(trials),1)

theta(trials) = cellfun(@(x)x.whiskerTrial.thetaAtBase{1},array.trials(trials), 'UniformOutput',0);
time(trials)  = cellfun(@(x)x.whiskerTrial.time{1},array.trials(trials),        'UniformOutput',0);
dt(trials)    = cellfun(@(x)diff([0 x]),time(trials),                           'UniformOutput',0);
dtheta(trials)= cellfun(@(x)diff([0 x]),theta(trials),                          'UniformOutput',0);
if nargin <3
    
    for t = trials
        vel{t} = (dtheta{t} ./ dt{t});
        acc{t} = diff([0 vel{t}]) ./ dt{t};
    end
elseif nargin == 3
    for t = trials
        vel{t} = smooth(dtheta{t} ./ dt{t},span,'moving')'
        acc{t} = smooth(diff([0 vel{t}]) ./ dt{t},span,'moving')';
    end
else
    display('Error : Wrong Number of Inputs')
end





