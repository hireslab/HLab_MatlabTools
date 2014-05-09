%%
% % chronological
% hfig_calign = figure(13);
% for i=tt{1}
%     for j = 1:length(T.cellNum)
%     T.trials{tt{1}}.shanksTrial.clustData{1}.spikeTimes

CTAdir = '/Volumes/MONOLITH/Silicon/CTA'
ConTAdir = '/Volumes/MONOLITH/Silicon/ConTA'

cd(CTAdir)
CTAd = dir('*CTA*')
cd(ConTAdir)
ConTAd = dir('*ConTA*')
figure(202);clf;

for sess = 1: length(ConTAd);
    cd(ConTAdir)
    load(ConTAd(sess).name)
    
    
        
    cd(CTAdir)
    load(CTAd(sess).name)
    
subplot(4,6,sess)
    

whiskerTIN = find(T.whiskerTrialInds);
segmentInds = {};

tt{1} = whiskerTIN(cellfun(@(x)x.trialContactType==1, contacts(whiskerTIN)));
tt{2} = whiskerTIN(cellfun(@(x)x.trialContactType==2, contacts(whiskerTIN)));
tt{3} = whiskerTIN(cellfun(@(x)x.trialContactType==3, contacts(whiskerTIN)));
tt{4} = whiskerTIN(cellfun(@(x)x.trialContactType==4, contacts(whiskerTIN)));
tt{5} = whiskerTIN(cellfun(@(x)x.trialContactType==0, contacts(whiskerTIN))); % No Contact


Sind = find(cellfun(@(x)strncmpi(x, T.sessionName,16),S.filename))

spikeUseFlag=[];

for k = 1:length(T.cellNum);
    spikeUseFlag{k} = find(cellfun(@(x)x.shanksTrial.clustData{k}.useFlag,T.trials));
end

trialNums = T.trialNums;

segmentInds(whiskerTIN) = cellfun(@(x)x.segmentInds{1},contacts(whiskerTIN),'UniformOutput',0)


cellNum = T.cellNum;
wfS = T.trials{find(T.whiskerTrialInds,1,'first')}.whiskerTrial.framePeriodInSec; % Whisker Frame Duration
sfS = T.trials{find(T.whiskerTrialInds,1,'first')}.shanksTrial.sampleRate; % Spike Sampling Rate
wTTO = T.whiskerTrialTimeOffset; 

for i=1:length(contacts)
    spikeTimes{i} = cellfun(@(x)x.spikeTimes,T.trials{i}.shanksTrial.clustData,'UniformOutput',0);
end


%% Plot contacts conditionalize the contacts
minContactThresh = 0;
numCons = [];
hold on

answerLickTimes = cellfun(@(x)x.answerLickTime, contacts(cellfun(@(x)~isempty(x.answerLickTime),contacts))); % All answer lick times
    cutoffTime = mean(answerLickTimes);

for i = tt{1}
    
 tmpCon={};
 numCons=[];
    cutoffTime = mean(answerLickTimes);
% Limit to only significant contacts

if isempty(contacts{i}.answerLickTime)
    cind = find(abs(contacts{i}.meanM0adj{1}) > minContactThresh & ...
        T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(:,1)) < cutoffTime);

    else
        cind = find(abs(contacts{i}.meanM0adj{1}) > minContactThresh & ...
        T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(:,1)) < contacts{i}.answerLickTime);

end

    plot(contacts{i}.meanM0adj{1}(cind),'.')


tmpCon{i}.meanM0adj{1}=contacts{i}.meanM0adj{1}(cind);
tmpCon{i}.peakM0adj{1}=contacts{i}.peakM0adj{1}(cind);
numCons(i) = length(tmpCon{i}.meanM0adj{1});

    
% Limit to pre-answer contacts
    
end

for i=1:10
    meanMeanConM0{i} = nanmean(cellfun(@(x)x.meanM0adj{1}(i),tmpCon(find(numCons>=i))));
        meanPeakConM0{i} = nanmean(cellfun(@(x)x.peakM0adj{1}(i),tmpCon(find(numCons>=i))));

        stdMeanConM0{i} = nanstd(cellfun(@(x)x.meanM0adj{1}(i),tmpCon(find(numCons>=i))));

end


plot(cellfun(@(x)x,meanMeanConM0),'r.','MarkerSize',20)
plot(cellfun(@(x)x,meanPeakConM0),'gs','MarkerSize',20)

xlabel('Contact Postition in Sequence')
ylabel('Moment')
title('ANM144442 110813 PreLick Go Pro Contacts')

end

%%
% % chronological
% hfig_calign = figure(13);
% for i=tt{1}
%     for j = 1:length(T.cellNum)
%     T.trials{tt{1}}.shanksTrial.clustData{1}.spikeTimes



