
for cellNum = 1:53
    
 load(['z:\users\Andrew\Whisker Project\SingleUnit\trialArrays\' SU.trialArrayName{cellNum}]);

 allHist = {};
 
 
 trialInds = {find(T.trialNums >= T.performanceRegion(1) & T.trialNums <= T.performanceRegion(2)),...
    find(T.trialNums < T.performanceRegion(1) | T.trialNums > T.performanceRegion(2)),...
    find(T.hitTrialInds & (T.trialNums >= T.performanceRegion(1) & T.trialNums <= T.performanceRegion(2))),...
    find(T.missTrialInds & (T.trialNums >= T.performanceRegion(1) & T.trialNums <= T.performanceRegion(2))),...
    find(T.hitTrialInds & (T.trialNums < T.performanceRegion(1) | T.trialNums > T.performanceRegion(2))),...
    find(T.missTrialInds & (T.trialNums < T.performanceRegion(1) | T.trialNums > T.performanceRegion(2))),...
    find(T.falseAlarmTrialInds & (T.trialNums >= T.performanceRegion(1) & T.trialNums <= T.performanceRegion(2))),...
    find(T.correctRejectionTrialInds & (T.trialNums >= T.performanceRegion(1) & T.trialNums <= T.performanceRegion(2))),...
    find(T.falseAlarmTrialInds & (T.trialNums < T.performanceRegion(1) | T.trialNums > T.performanceRegion(2))),...
    find(T.correctRejectionTrialInds & (T.trialNums < T.performanceRegion(1) | T.trialNums > T.performanceRegion(2)))};

plotColor = {'k','k','b','k','b','k','g','r','g','r'};
plotLimits = [-.08 .24 0 150];
binSize = .005
figure(2);clf
clf;set(gcf,'Position',[25 25 800 800],'PaperPosition',[0 0 8 8],'PaperSize',[8 8])

        
for i = 1:2
    
    spikeTimes = cellfun(@(x)double(x.spikesTrial.spikeTimes)/x.spikesTrial.sampleRate,T.trials(trialInds{i}),'UniformOutput',0);
    alignTimes = cellfun(@(x)x.pinAscentOnsetTime,T.trials(trialInds{i}),'UniformOutput',0);
    
    subplot(4,4,[1 2 5 6]+2*(i-1));
    
    allHist{i} = plotHist(spikeTimes,alignTimes,binSize,plotLimits,plotColor{i});
end

plotLimits(4) = 1.25*max(max([allHist{:}]))+1;
for i = 1:2
    
    spikeTimes = cellfun(@(x)double(x.spikesTrial.spikeTimes)/x.spikesTrial.sampleRate,T.trials(trialInds{i}),'UniformOutput',0);
    alignTimes = cellfun(@(x)x.pinAscentOnsetTime,T.trials(trialInds{i}),'UniformOutput',0);
    
    subplot(4,4,[1 2 5 6]+2*(i-1));
    
    plotHist(spikeTimes,alignTimes,binSize,plotLimits,plotColor{i});
end

subplot(4,4,[1 2 5 6]);
title('Performing');

subplot(4,4,[3 4 7 8]);
title('Non-Performing');

for i = 3:10
    
    spikeTimes = cellfun(@(x)double(x.spikesTrial.spikeTimes)/x.spikesTrial.sampleRate,T.trials(trialInds{i}),'UniformOutput',0);
    alignTimes = cellfun(@(x)x.pinAscentOnsetTime,T.trials(trialInds{i}),'UniformOutput',0);
    subplot(4,4,i+6);
    plotHist(spikeTimes,alignTimes,binSize,plotLimits,plotColor{i});
end

              print('-depsc', ['Z:\users\Andrew\Whisker Project\SingleUnit\Figures\CueAligned\PoleOutAligned_' SU.cellName{cellNum}])   
end
