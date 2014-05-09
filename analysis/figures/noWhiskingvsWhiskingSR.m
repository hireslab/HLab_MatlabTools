% Whisking vs. Nonwhisking spike rate, colored sharp touch cells

Si_DADir = ('Z:\Users\Andrew\Whisker Project\Silicon\DiscrimAnalysisArrays\');
SU_DADir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\DiscrimAnalysisArrays\');

SU_nums = [1:52];
Si_nums = 1:148;

SU.nonWhiskSR = cell(length(SU_nums),1);
SU.whiskSR = cell(length(SU_nums),1);
S.nonWhiskSR = cell(length(Si_nums),1);
S.whiskSR = cell(length(Si_nums),1);
for i = 1:length(SU_nums)
load([SU_DADir 'DA_' num2str(SU_nums(i)) '_' SU.trialArrayName{SU_nums(i)}(13:end)]);
        display(['Loading ' 'DA_' num2str(SU_nums(i)) '_' SU.trialArrayName{SU_nums(i)}(13:end)])

    noContactTrials = find(~cellfun(@numel,DA.contactTimesInSamplingPeriod));
    samplingPeriodLength = cellfun(@length,DA.samplingPeriod(noContactTrials));
    whiskSamplingPeriodLength = cellfun(@length,DA.whiskSamplingPeriod(noContactTrials));
    
    nonWhiskSpikes = sum(DA.spikeCountInSamplingPeriod(noContactTrials))-sum(DA.spikeCountInWhiskSamplingPeriod(noContactTrials));
    nonWhiskPeriod = sum(samplingPeriodLength)-sum(whiskSamplingPeriodLength);
    whiskSpikes = sum(DA.spikeCountInWhiskSamplingPeriod(noContactTrials));
    whiskPeriod = sum(whiskSamplingPeriodLength);
    
    SU.nonWhiskSR{SU_nums(i)} = nonWhiskSpikes/nonWhiskPeriod * 1000;
    SU.whiskSR{SU_nums(i)} = whiskSpikes/whiskPeriod * 1000;
    
    
end
 
for i = 1:length(Si_nums)
    load([Si_DADir 'DA_' num2str(Si_nums(i)) '_' S.filename{Si_nums(i)}])
    display(['Loading ' 'DA_' num2str(Si_nums(i)) '_' S.filename{Si_nums(i)}])
    noContactTrials = find(~cellfun(@numel,DA.contactTimesInSamplingPeriod));
    samplingPeriodLength = cellfun(@length,DA.samplingPeriod(noContactTrials));
    whiskSamplingPeriodLength = cellfun(@length,DA.whiskSamplingPeriod(noContactTrials));
    
    nonWhiskSpikes = sum(DA.spikeCountInSamplingPeriod(noContactTrials))-sum(DA.spikeCountInWhiskSamplingPeriod(noContactTrials));
    nonWhiskPeriod = sum(samplingPeriodLength)-sum(whiskSamplingPeriodLength);
    whiskSpikes = sum(DA.spikeCountInWhiskSamplingPeriod(noContactTrials));
    whiskPeriod = sum(whiskSamplingPeriodLength);
    
    S.nonWhiskSR{Si_nums(i)} = nonWhiskSpikes/nonWhiskPeriod * 1000;
    S.whiskSR{Si_nums(i)} = whiskSpikes/whiskPeriod * 1000;
    
    
end

%%
figure(1);clf
subplot(2,2,1);cla;hold on
for i = 1:length(SU.nonWhiskSR)
    try
        if intersect(SU.touchCells,i)
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'r.')
            
        else
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'k.')
        end
        
    end
    
end

for i = 1:length(S.nonWhiskSR)
    try
        if intersect(S.touchcells,i)
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'r.')
            
        else
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'k.')
        end
        
    end
    
end
xlabel('Non Whisking Spike Rate')
ylabel('Whisking Spike Rate')

plot([0 100],[0 100],'k')
plot([0 100],[1 150],'r')
plot([1 100],[0 67],'r')

subplot(2,2,2);cla;hold on
for i = 1:length(SU.nonWhiskSR)
    try
        if intersect(SU.touchCells,i)
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'r.')
            
        else
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'k.')
        end
    end
    
end
for i = 1:length(S.nonWhiskSR)
    try
        if intersect(S.touchcells,i)
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'r.')
            
        else
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'k.')
        end
        
    end
    
end
xlabel('Non Whisking Spike Rate')
ylabel('Whisking Spike Rate')
plot([0 5],[0 5],'k')

axis([0 5 0 5])

subplot(2,2,3);cla;hold on
for i = 1:53
    try
                if intersect(SU.touchCells,i)
                        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
for i = 1:length(S.nonWhiskSR)
    try
                if intersect(S.touchcells,i)
                        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
axis([0 100 0 500])
ylabel('Peak Touch Rate')
xlabel('Whisking Spike Rate')
subplot(2,2,4);cla;hold on
for i = 1:53
    try
                if intersect(SU.touchCells,i)
                        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
for i = 1:length(S.nonWhiskSR)
    try
                if intersect(S.touchcells,i)
                        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
ylabel('Peak Touch Rate')
xlabel('Whisking Spike Rate')
axis([0 10 0 200])