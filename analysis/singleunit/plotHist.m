function allHist = plotHist(spikeTimes, alignTimes, binSize, plotLimits, plotColor)
% spiketimes is a n x 1 cell array each cell containing spike times of a trial.
% alignTimes is a n x 1 cell array containing alignment times of a trial.



if nargin == 2
    binSize        = .001; % sec
    plotLimits    = [-0.05 .05 0 400]; % seconds
    plotColor = 'k'
end
edges          = plotLimits(1):binSize:plotLimits(2);


allSpikes = [];

for i = 1:length(spikeTimes)
    allSpikes= cat(1,allSpikes,double(spikeTimes{i})-double(alignTimes{i}));
end

allHist   = histc(allSpikes,edges)/length(spikeTimes)/binSize;

%handle empty spike arrays
if isempty(allHist)
    allHist = zeros(length(edges(:)),1);
end

bar(edges+binSize/2,allHist,plotColor,'edgecolor',plotColor)
set(gca,'XLim', plotLimits(1:2))%,'YLim',plotLimits(3:4));

