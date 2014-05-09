


SUnums_L23 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))
SUnums_L56 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.588))

SUnums_Lall = find([SU.distance{:}] < .250);
SUnums= SUnums_L4(1)

contactNumbers = 1:5
[~, depthOrder] = sort(cellfun(@(x)-x(3),SU.recordingLocation(SUnums)))
SUnums = 1:53; SUnums(depthOrder)
for k = 1:length(SUnums)
%     subplot(4,7,k);hold on
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\ConTA\' SU.contactsArrayName{SUnums(k)}]);
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\TrialArrays\' SU.trialArrayName{SUnums(k)}]);
    
    
    
    whiskerTIN = find(cellfun(@(x)isfield(x,'trialContactType'),contacts));
    wTTO = T.whiskerTrialTimeOffset;
    % Trial Index of All Contact trials
    tindGo = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 1 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    tindNogo = whiskerTIN(cellfun(@(x)x.trialContactType,contacts(whiskerTIN)) == 3 & cellfun(@(x)~isempty(x.contactInds{1}),contacts(whiskerTIN)));
    
    alignTimesGo = {};
    alignTimesNogo = {};
    contactGoSpikeNums = repmat({NaN},length(tindGo),length(contactNumbers))
    
    for i = 1:length(tindGo)
        for j = contactNumbers
            if size(contacts{tindGo(i)}.segmentInds{1},1)>=j
                if T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1)) <= min([T.trials{tindGo(i)}.answerLickTime 2]);
                    alignTimesGo{i,j} = T.trials{tindGo(i)}.whiskerTrial.time{1}(contacts{tindGo(i)}.segmentInds{1}(j,1));
                    spikeTimes = double(round(T.trials{tindGo(i)}.spikesTrial.spikeTimes/10))/1000;
                    contactGoSpikeTimes{i,j} = spikeTimes(spikeTimes > .005+alignTimesGo{i,j} & spikeTimes <.045+alignTimesGo{i,j});
                    contactGoSpikeNums{i,j} = length(contactGoSpikeTimes{i,j});

                    
                    thetaGo(i,j) = getThetaFromTime({round(contactGoSpikeTimes{i,j}*1000)},tindGo(i),T);
                    
                end
                
            end
        end
    end
    
    contactNogoSpikeNums = repmat({NaN},length(tindNogo),length(contactNumbers))

    
    for i = 1:length(tindNogo)
        for j = contactNumbers
            if size(contacts{tindNogo(i)}.segmentInds{1},1)>=j
                if T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1)) <= min([T.trials{tindNogo(i)}.answerLickTime 2]);
                    
                    alignTimesNogo{i,j} = T.trials{tindNogo(i)}.whiskerTrial.time{1}(contacts{tindNogo(i)}.segmentInds{1}(j,1));
                    spikeTimes = double(round(T.trials{tindNogo(i)}.spikesTrial.spikeTimes/10))/1000;
                    contactNogoSpikeTimes{i,j} = spikeTimes(spikeTimes > .005+alignTimesNogo{i,j} & spikeTimes <.045+alignTimesNogo{i,j});
                    contactNogoSpikeNums{i,j} = length(contactNogoSpikeTimes{i,j});

                    thetaNogo(i,j) = getThetaFromTime({round(contactNogoSpikeTimes{i,j}*1000)},tindNogo(i),T);
                end
            end
        end
        
    end
    
    SU.contactAligned.contactNogoSpikeTimes{SUnums(k)} = contactNogoSpikeTimes;
    SU.contactAligned.contactNogoSpikeNums{SUnums(k)} = contactNogoSpikeNums;
    SU.contactAligned.contactNogoSpikeTheta{SUnums(k)} = thetaNogo;
        SU.contactAligned.contactGoSpikeTimes{SUnums(k)} = contactGoSpikeTimes;
    SU.contactAligned.contactGoSpikeNums{SUnums(k)} = contactGoSpikeNums;
    SU.contactAligned.contactGoSpikeTheta{SUnums(k)} = thetaGo;
end
figure(1);clf;hold on
for i =1:length(thetaGo)
    try
    plot(1,thetaGo{i},'b.')
    end
end
for i =1:length(thetaNogo)
    try
    plot(2,thetaNogo{i},'r.')
    end
end

