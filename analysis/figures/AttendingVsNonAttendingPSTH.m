pinOut = cellfun(@(x)x.pinAscentOnsetTime,T.trials);
pinIn = cellfun(@(x)x.pinDescentOnsetTime,T.trials);
firstContact = cell(length(contacts),1);
wTTO = T.whiskerTrialTimeOffset;

for i = find(T.whiskerTrialInds)
    if ~isempty(contacts{i}.contactInds{1})
        firstContact{i} = double(contacts{i}.contactInds{1}(1))/1000+wTTO;
    end
end

hfig_1 = figure(1);clf;hold on
trialSpikeSamples = cellfun(@(x)x.spikesTrial.spikeTimes,T.trials,'UniformOutput',0)

    subplot(1,3,1)
    set(gca,'XLim',[-.1 .25],'YLim',[T.trialNums(2) T.trialNums(end)]);hold on;grid on
        subplot(1,3,2)
    set(gca,'XLim',[-.1 .25],'YLim',[T.trialNums(2) T.trialNums(end)]);hold on;grid on
        subplot(1,3,3)
    set(gca,'XLim',[-.1 .25],'YLim',[T.trialNums(2) T.trialNums(end)]);hold on;grid on
    
for i = 1:length(T.trials);
    trialSpikeTimes = double(trialSpikeSamples{i}(trialSpikeSamples{i} > 0))/T.trials{i}.spikesTrial.sampleRate;


   
        if ~isempty(trialSpikeTimes)
            if T.trialNums(i) >= T.performanceRegion(1) & T.trialNums(i) <= T.performanceRegion(2)
             
                subplot(1,3,1)
             plot(trialSpikeTimes - pinIn(i),T.trialNums(i),'k.');   
                 if ~isempty(firstContact{i})
             subplot(1,3,2)
             plot(trialSpikeTimes - firstContact{i},T.trialNums(i),'k.');
                 end
                subplot(1,3,3)
             plot(trialSpikeTimes - pinOut(i),T.trialNums(i),'k.');
             
            else
             subplot(1,3,1)
             plot(trialSpikeTimes - pinIn(i),T.trialNums(i),'r.');
             
             subplot(1,3,2)
             if ~isempty(firstContact{i})
             plot(trialSpikeTimes - firstContact{i},T.trialNums(i),'r.');         
             end
                                                subplot(1,3,3)

            plot(trialSpikeTimes - pinOut(i),T.trialNums(i),'r.');
            end
        end
        
       
        
end

