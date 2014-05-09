function smoothedSpikes = smoothSpikes(spikeTimes, alignTimes, binSize)
% spiketimes is a n x 1 cell array each cell containing spike times of a trial.
% alignTimes is a n x 1 cell array containing alignment times of a trial.


spkTmp = cellfun(@(x)x',spikeTimes,'UniformOutput',0);
allSpikes = zeros(round(2*max([spkTmp{:}])*1000),1);
padSize = max([spkTmp{:}])*1000;

for i = 1:length(spikeTimes)
    allSpikes(round((spikeTimes{i}-double(alignTimes{i}))*1000+padSize)) = allSpikes(round(spikeTimes{i}*1000))+1/1000;
end

smoothedSpikes = smooth(allSpikes,1000*binSize);
