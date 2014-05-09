function shuffledSpikes = shuffleSpikes(spikeTimes, timeRange, reps)

%spikeTimes is a cell array of trials with spikeTimes in seconds
%spikeTimes is a cell array of trails with allowed spikeTimes
%reps is number of repeats to do

shuffledSpikes = cell(length(spikeTimes));

for i = 1:length(shuffleArray)
    shuffleArray{i} = reshape(timeRange{i}(round(length(timeRange{i})*rand(length(spikeTimes{i})*reps,1))),length(spikeTimes{i}),reps)
end




% spikeTimes = cellfun(@(x)x.spikesTrial.spikeTimes,T.trials,'UniformOutput',0)
% spikeTimes = cellfun(@(x)x(x>0),spikeTimes,'UniformOutput',0)