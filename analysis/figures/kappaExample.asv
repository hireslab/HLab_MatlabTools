for tInd = find(T.whiskerTrialInds);
    
    
    if ~isempty(contacts{tInd}.segmentInds{1});
        if ~isempty(contacts{tInd}.answerLickTime);
            preAnswerSegmentStart{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<contacts{tInd}.answerLickTime,1);
            preAnswerSegmentEnd{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<contacts{tInd}.answerLickTime,2);

        else
            preAnswerSegmentStart{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<T.trials{tInd}.pinAscentOnsetTime,1);
            preAnswerSegmentEnd{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<T.trials{tInd}.pinAscentOnsetTime,1);

           end
    else
        preAnswerSegmentStart{tInd} = [];
        preAnswerSegmentEnd{tInd} = [];

    end
    
    [~,~,preAnswerContactInd{tInd}] = intersect(T.trials{tInd}.whiskerTrial.time{1}(preAnswerSegmentStart{tInd}), T.trials{tInd}.whiskerTrial.time{1})  % Shift start index by searching for matching times incase some frames are missing
    
    if ~isempty(preAnswerSegmentStart{tInd})
        for segInd = 1:length(preAnswerSegmentStart{tInd})
            
            deltaKappa = T.trials{tInd}.whiskerTrial.deltaKappa{1}(preAnswerSegmentStart{tInd}(segInd):preAnswerSegmentStart{tInd}(segInd));
            baseDeltaKappa = nanmean(T.trials{tInd}.whiskerTrial.deltaKappa{1}(preAnswerSegmentStart{tInd}(segInd)-(1:3)));
            [~,peakInd] = max(abs(deltaKappa-baseDeltaKappa));
            peakDeltaKappa{tInd}(segInd) = deltaKappa(peakInd);
        end
    end
    
end

%%
conTrials = find(cellfun(@(x)~isempty(x),peakDeltaKappa));
firstContactPeaks = cellfun(@(x)x(1),peakDeltaKappa(conTrials),'UniformOutput',0)
preAnswerContactPeaks = cellfun(@(x)x,peakDeltaKappa(conTrials),'UniformOutput',0)

edges = [-.0275:.0025:.015];
figure(10);clf;
subplot(2,1,1);
binnedFirstContact = histc([firstContactPeaks{:}],edges);
bar(edges,binnedFirstContact,'histc')
text(0,14,'First Contact')


subplot(2,1,2);
binnedPreAnswerContact = histc([preAnswerContactPeaks{:}],edges);
bar(edges,binnedPreAnswerContact,'histc')
text(0,52,'Pre-Lick Contacts')
xlabel('Peak change in curvature (K)')
ylabel('Number of contacts')

print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\ExampleTraces\deltaKappaHistogram_' T.mouseName '_Cell_' num2str(T.cellNum(j))])
