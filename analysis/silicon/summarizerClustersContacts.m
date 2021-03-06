% Cell and Contact Summarizer
% 
% CTAdir = '/Volumes/MONOLITH/Silicon/CTA'
% ConTAdir = '/Volumes/MONOLITH/Silicon/ConTA/new'
CTAdir = 'Q:\Silicon\CTA'
ConTAdir = 'Q:\Silicon\ConTA\new'

cd(CTAdir)
CTAd = dir('*CTA*')
cd(ConTAdir)
ConTAd = dir('*ConTA*')

for sess = 12
    cd(ConTAdir)
    load(ConTAd(sess).name)
    
    cd(CTAdir)
    load(CTAd(sess).name)
    
%% Setup

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

%% Plotting

% axisSize = [-1 5 1 length(T.trials)];
% axisSizeSeq = [-1 5 1 length(tt{1})];
% cAlign = 2;
% 
% j=17% cellNumber
% 
% % By trial number
% figure(2)
% 
% for k = 1:4
%     subplot(2,2,k);
%     cla;hold on;
% 
%     for i = intersect(spikeUseFlag{j},tt{k})
%         try    
%             plot(double(spikeTimes{i}{j})/sfS+wTTO-wfS*segmentInds{i}(cAlign,1),trialNums(i),'k.')
%         end   
%     end
%     axis(axisSize)
%     
% grid on
% end
% % By sequential number
% 
% figure(3)
% 
% for k = 1:3
%     subplot(2,2,k);
%     cla;hold on;
%     p_ind = intersect(spikeUseFlag{j},tt{k});
%     for i = 1:length(p_ind)
%         try    
%             plot(double(spikeTimes{p_ind(i)}{j})/sfS+wTTO-wfS*segmentInds{p_ind(i)}(cAlign,1),i,'k.')
%         end   
%     end
%     axis(axisSizeSeq)
% grid on
% 
% end


%% Contact Summaries





%% Find baseline firing
for k=1:5
for i = 1:length(Sind)
    baselineSR(i,k) = nanmean(cellfun(@(x)sum(x.shanksTrial.clustData{i}.spikeTimes < -T.whiskerTrialTimeOffset*19530)/-T.whiskerTrialTimeOffset,...
        T.trials(intersect(spikeUseFlag{i},tt{k}))));
end
end

for i = 1:length(Sind)
    S.baselineSR{Sind(i)} = baselineSR(i,:);
end


%% Find means, modulation, adaptation




colors = gray(8);
figure(5);clf;

timeWindow = [0.015 .04]

for j=17%1:length(Sind)% cellNumber

for cAlign = 1:5; % Number of contact to align to



 binSize        = .002; % sec
 startWindow    = 0; % seconds
 endWindow      = .05; % seconds
 edges          = startWindow:binSize:endWindow;
 

 for k=1:3
     subplot(2,2,k);hold on

     allSpikes{k} = [];

     for i = intersect(spikeUseFlag{j},tt{k})
         try
         allSpikes{k} = cat(1,allSpikes{k},double(spikeTimes{i}{j})/sfS+wTTO-wfS*segmentInds{i}(cAlign,1));
         end
     end
     
    allLength{k} = sum(cellfun(@(x)size(x,1),segmentInds(intersect(spikeUseFlag{j},tt{k})))>=cAlign);
    allHist{k}   = histc(allSpikes{k},edges)/allLength{k}/binSize;
    
    windSR(j,cAlign,k) = sum(allSpikes{k} > timeWindow(1) & allSpikes{k} < timeWindow(2)) / allLength{1} / diff(timeWindow);
    bar(edges+binSize/2,allHist{k})
    plot(edges+binSize/2,allHist{k},'Color',colors(cAlign,:),'LineWidth',2)
    set(gca,'Xlim',[startWindow endWindow])
    xlabel('Time (s)')
    ylabel('Mean Spike Count')
    grid on
  end
 
 
 
end

 S.windowSR{Sind(j)}     = squeeze(windSR(j,:,:));
 S.adaptationSR{Sind(j)} = S.windowSR{Sind(j)}./repmat(S.windowSR{Sind(j)}(1,:),5,1);
 S.modulationSR{Sind(j)} = S.windowSR{Sind(j)}./mean(S.baselineSR{Sind(j)}(1:3));
 S.timeWindowSR{Sind(j)} = timeWindow;
end
end

    
%% Plot contacts conditionalize the contacts
minContactThresh = 0;
numCons = [];
figure(11); cla;hold on
for i = tt{1}
    

    cutoffTime = 1.75
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

for i=1:5
    meanMeanConM0{i} = nanmean(cellfun(@(x)x.meanM0adj{1}(i),tmpCon(find(numCons>=i))));
        meanPeakConM0{i} = nanmean(cellfun(@(x)x.peakM0adj{1}(i),tmpCon(find(numCons>=i))));

        stdMeanConM0{i} = nanstd(cellfun(@(x)x.meanM0adj{1}(i),tmpCon(find(numCons>=i))));

end


plot(cellfun(@(x)x,meanMeanConM0),'ro','MarkerSize',10)
plot(cellfun(@(x)x,meanPeakConM0),'gs','MarkerSize',10)
plot([0 5.5],[0 0],'k--')
set(gca,'XLim',[0 5.5])
xlabel('Contact postition in sequence')
ylabel('Moment (N*m)')
title('Protraction Contact Forces')
grid off




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
for i = tt{1}
    
 tmpCon={};
 numCons={};
    cutoffTime = 1.75
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



