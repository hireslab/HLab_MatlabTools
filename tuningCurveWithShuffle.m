function [dataSR dataBin dataBounds] = tuningCurveWithShuffle(dataArray, spikeArray, time, trialNums, binBounds)%, shuffleNum);

for i = 1:length(trialNums)
    timeInd = round(1000*time{trialNums(i)}+1);
    dataSubset{i} = dataArray{trialNums(i)};
    spikeSubset{i} = (spikeArray{trialNums(i)}(timeInd))';
end

data = [dataSubset{:}];
spikes = [spikeSubset{:}];
[dataSR dataBin dataBounds] = binslin(data,spikes,'equalX',binBounds);

% tuningCurve