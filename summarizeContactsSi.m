function C=summarizeContacts(array, contacts, params)

g=params;

contactNaNs=NaN(length(contacts),max(cellfun(@(x) length(x.segmentInds{1}),contacts(array.whiskerTrialInds))));
ymax=4.5;
C.time=contactNaNs;
C.duration=contactNaNs;
C.spikeCount=contactNaNs;
C.spikeRate=contactNaNs;
C.meanM0=contactNaNs;
C.peakM0=contactNaNs;
C.meanFaxial=contactNaNs;
C.peakFaxial=contactNaNs; 
whiskerTIN = find(array.whiskerTrialInds);


whiskerTIN                          = find(array.whiskerTrialInds);
goTrialNums                         = cat(1,array.missTrialNums(:),array.hitTrialNums(:));
trialNums                           = array.trialNums;

pinDescentOnsetTime(whiskerTIN)     = cellfun(@(x)x.behavTrial.pinDescentOnsetTime,array.trials(whiskerTIN),'UniformOutput',0);
pinAscentOnsetTime(whiskerTIN)      = cellfun(@(x)x.behavTrial.pinAscentOnsetTime,array.trials(whiskerTIN),'UniformOutput',0);

trialContactType                    = cellfun(@(x)x.trialContactType,contacts);
goproInd    = trialContactType==1;
goretInd    = trialContactType==2;
nogoproInd  = trialContactType==3;
nogoretInd  = trialContactType==4;


time(whiskerTIN)                    = cellfun(@(x)x.whiskerTrial.time{1},                   array.trials(whiskerTIN),'UniformOutput',0);
distanceToPoleCenter(whiskerTIN)    = cellfun(@(x)x.whiskerTrial.distanceToPoleCenter{1},   array.trials(whiskerTIN),'UniformOutput',0);
kappa(whiskerTIN)                   = cellfun(@(x)x.whiskerTrial.deltaKappa{1},             array.trials(whiskerTIN),'UniformOutput',0);
thetaAtBase(whiskerTIN)             = cellfun(@(x)x.whiskerTrial.thetaAtBase{1},            array.trials(whiskerTIN),'UniformOutput',0);
thetaAtContact(whiskerTIN)          = cellfun(@(x)x.whiskerTrial.thetaAtContact{1},         array.trials(whiskerTIN),'UniformOutput',0);
M0(whiskerTIN)                      = cellfun(@(x)x.whiskerTrial.M0{1},                     array.trials(whiskerTIN),'UniformOutput',0); 
M0I(whiskerTIN)                     = cellfun(@(x)x.whiskerTrial.M0I{1},                    array.trials(whiskerTIN),'UniformOutput',0); 
Faxial(whiskerTIN)                  = cellfun(@(x)x.whiskerTrial.Faxial{1},                 array.trials(whiskerTIN),'UniformOutput',0); 
trialClass(whiskerTIN)              = cellfun(@(x)x.trialType*2 + x.trialCorrect + 1,       array.trials(whiskerTIN),'UniformOutput',0);


h = waitbar(0, 'Processing Contacts');
%array.trials{2}.answerLickTime;
j=length(array.whiskerTrialInds);
for k = whiskerTIN;
    
    waitbar(k/j,h);
    ; % All times in current trial
    cT=array.trials{k};
    cB=array.trials{k}.behavTrial;

        


    switch g.displayType

        case 'all'
            g.framesUsed = 1:length(time{k});

        case 'contactsOnly'
            g.framesUsed = contacts{k}.contactInds{1};

        case 'excludeContacts'
            g.framesUsed = ones(size(time{k}));
            g.framesUsed(contacts{k}.contactInds{1})=0;
            g.framesUsed= find(g.framesUsed);

        case 'poleToDecision'
            if isempty(cB.answerLickTime)==0
                g.framesUsed = find(time{k} > cT.pinDescentOnsetTime+g.poleOffset &...
                    time{k} < cB.answerLickTime);
            else
                g.framesUsed = find(time{k} > cT.pinDescentOnsetTime+g.poleOffset &...
                    time{k} < g.meanAnswerTime);
            end

        case 'contactToDecision'             
            if isempty(contacts{k}.contactInds{1})==0
                g.framesUsed = find(time{k} > time{k}(contacts{k}.contactInds{1}(1)) &...
                    time{k} < g.meanAnswerTime);
            else
                g.framesUsed=[];
            end

        case 'postDecision'             

            if isempty(cB.answerLickTime)==0;
                g.framesUsed = find(time{k} > cB.answerLickTime);
            else
                g.framesUsed = find(time{k}> g.meanAnswerTime);
            end

        case 'postPole'             
            g.framesUsed = find(time{k} > pinAscentOnsetTime{k});

        case 'arbitrary'
            g.framesUsed = find(time{k} > str2num(g.arbTimes{1}) & time{k} < str2num(g.arbTimes{2}));

        otherwise
            error('Invalid string argument.')
    end
    
    if isempty(contacts{k}.segmentInds{1})==0;
        [segInds,~,conInds]=intersect(g.framesUsed, contacts{k}.segmentInds{1}(:,1));
        C.time(k,1:length(conInds))=segInds(conInds)./1000;
        C.duration(k,1:length(conInds))=contacts{k}.contactLength{1}(conInds);
        C.spikeCount(k,1:length(conInds))=contacts{k}.spikeCount{1}(conInds);
        C.spikeRate(k,1:length(conInds))=contacts{k}.spikeCount{1}(conInds)./contacts{k}.contactLength{1}(conInds);
        C.meanM0(k,1:length(conInds))=contacts{k}.meanM0{1}(conInds);
        C.peakM0(k,1:length(conInds))=contacts{k}.peakM0{1}(conInds);
        C.meanFaxial(k,1:length(conInds))=contacts{k}.meanFaxial{1}(conInds);
        C.peakFaxial(k,1:length(conInds))=contacts{k}.peakFaxial{1}(conInds);
        
    end
    
end   
    
xmax = find(isnan(nanmean(C.time{k},1))==0,1,'last');


% Contact # vs. Time
h_contacts=figure;
set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
set(gcf,'DefaultLineLineWidth',1.5)
set(gcf,'DefaultLineMarkerSize',16)
subplot(3,3,1);cla;
plot([0 1],[0 1],'.');
set(gca,'Visible','off');
try
    text(-.2,.9, ['\fontsize{8}' 'Time Period : \bf' g.displayType '  ' num2str(g.arbTimes)]);
end
text(-.2,.8, ['\fontsize{8}' 'AP Synaptic Offset : \bf' num2str(g.spikeSynapticOffset) ' (s)']);
text(-.2,.7, ['\fontsize{8}\color[rgb]{.5 .5 .5}' 'AP Integration Window : ' num2str(g.spikeRateWindow) ' (s)']);
text(-.2,.6, ['\fontsize{8}' 'Contact Threshold ' num2str(g.touchThresh(1)) ' / ' num2str(g.touchThresh(2)) ' / ' num2str(g.touchThresh(3)) ' / ' num2str(g.touchThresh(4))]);
text(-.2,.5, ['\fontsize{8}' 'Mean Answer Time : ' num2str(g.meanAnswerTime) ' (s)']);
text(-.2,.4, ['\fontsize{8}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
text(-.2,.3, ['\fontsize{8}' 'Mouse : ' array.mouseName]);
text(-.2,.2, ['\fontsize{8}' 'Cell : ' array.cellNum '' array.cellCode '' array.sessionName([1,2,4,5,7,8])]) ;
text(-.2,.1, ['\fontsize{8}' 'Location : ' num2str(array.depth) '\mum' ' ' array.recordingLocation]) ;


subplot(3,3,2);cla;

plot(1:size(nanmean(C.time(goproInd,:)),2),nanmean(C.time(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.time(goretInd,:)),2),nanmean(C.time(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.time(nogoproInd,:)),2),nanmean(C.time(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.time(nogoretInd,:)),2),nanmean(C.time(nogoretInd,:)),'.-','Color',[.6,0,0]);

set(gca,'Ylim',[0 ymax])
xlabel('Contact #');
ylabel('Start Time (s)');
legend('go protract','go retract','nogo protract','nogo retract','Location','NorthWest');
          
% Contact # vs. duration
subplot(3,3,3);cla;
plot(1:size(nanmean(C.duration(goproInd,:)),2),nanmean(C.duration(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.duration(goretInd,:)),2),nanmean(C.duration(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.duration(nogoproInd,:)),2),nanmean(C.duration(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.duration(nogoretInd,:)),2),nanmean(C.duration(nogoretInd,:)),'.-','Color',[.6,0,0]);xlabel('Contact #');

ylabel('Duration (s)');
axis tight  
set(gca,'XLim',[0 xmax]);

% Contact # vs. Spike number
subplot(3,3,6);cla;
plot(1:size(nanmean(C.spikeCount(goproInd,:)),2),nanmean(C.spikeCount(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.spikeCount(goretInd,:)),2),nanmean(C.spikeCount(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.spikeCount(nogoproInd,:)),2),nanmean(C.spikeCount(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.spikeCount(nogoretInd,:)),2),nanmean(C.spikeCount(nogoretInd,:)),'.-','Color',[.6,0,0]);

xlabel('Contact #');
ylabel('Spikes in Contact');    
axis tight
set(gca,'XLim',[0 xmax]);

% Contact # vs. Spike rate
subplot(3,3,9);cla;
plot(1:size(nanmean(C.spikeRate(goproInd,:)),2),nanmean(C.spikeRate(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.spikeRate(goretInd,:)),2),nanmean(C.spikeRate(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.spikeRate(nogoproInd,:)),2),nanmean(C.spikeRate(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.spikeRate(nogoretInd,:)),2),nanmean(C.spikeRate(nogoretInd,:)),'.-','Color',[.6,0,0]);

xlabel('Contact #');
ylabel('Spike Rate (Hz)');  
axis tight
set(gca,'XLim',[0 xmax]);

% Contact # vs. M0
subplot(3,3,4);cla;

plot(1:size(nanmean(C.peakM0(goproInd,:)),2),repmat(0,size(nanmean(C.peakM0(goproInd,:)),2),1),'k:');
hold on
plot(1:size(nanmean(C.meanM0(goproInd,:)),2),nanmean(C.meanM0(goproInd,:)),'b.-');
plot(1:size(nanmean(C.meanM0(goretInd,:)),2),nanmean(C.meanM0(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.meanM0(nogoproInd,:)),2),nanmean(C.meanM0(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.meanM0(nogoretInd,:)),2),nanmean(C.meanM0(nogoretInd,:)),'.-','Color',[.6,0,0]);

xlabel('Contact #');
ylabel('Mean Moment (N*m)');  
axis tight
set(gca,'XLim',[0 xmax]);

% Contact # vs. M0
subplot(3,3,7);cla;

plot(1:size(nanmean(C.peakM0(goproInd,:)),2),repmat(0,size(nanmean(C.peakM0(goproInd,:)),2),1),'k:');
hold on
plot(1:size(nanmean(C.peakM0(goproInd,:)),2),nanmean(C.peakM0(goproInd,:)),'b.-');
plot(1:size(nanmean(C.peakM0(goretInd,:)),2),nanmean(C.peakM0(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.peakM0(nogoproInd,:)),2),nanmean(C.peakM0(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.peakM0(nogoretInd,:)),2),nanmean(C.peakM0(nogoretInd,:)),'.-','Color',[.6,0,0]);
xlabel('Contact #');
ylabel('Peak Moment (N*m)');  
axis tight
set(gca,'XLim',[0 xmax]);


% Contact # vs. Fax
subplot(3,3,5);cla;
plot(1:size(nanmean(C.meanFaxial(goproInd,:)),2),nanmean(C.meanFaxial(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.meanFaxial(goretInd,:)),2),nanmean(C.meanFaxial(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.meanFaxial(nogoproInd,:)),2),nanmean(C.meanFaxial(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.meanFaxial(nogoretInd,:)),2),nanmean(C.meanFaxial(nogoretInd,:)),'.-','Color',[.6,0,0]);
xlabel('Contact #');
ylabel('Peak Moment (N*m)');  
axis tight
set(gca,'XLim',[0 xmax]);

% Contact # vs. Fax
subplot(3,3,8);cla;
plot(1:size(nanmean(C.peakFaxial(goproInd,:)),2),nanmean(C.peakFaxial(goproInd,:)),'b.-');
hold on
plot(1:size(nanmean(C.peakFaxial(goretInd,:)),2),nanmean(C.peakFaxial(goretInd,:)),'.-','Color',[0,0,.6]);
plot(1:size(nanmean(C.peakFaxial(nogoproInd,:)),2),nanmean(C.peakFaxial(nogoproInd,:)),'r.-');
plot(1:size(nanmean(C.peakFaxial(nogoretInd,:)),2),nanmean(C.peakFaxial(nogoretInd,:)),'.-','Color',[.6,0,0]);
xlabel('Contact #');
ylabel('Peak Moment (N*m)');  
axis tight
set(gca,'XLim',[0 xmax]);


assignin('base','C',C);


print(h_contacts, '-depsc',[array.mouseName '-' array.cellNum '-' 'contacts-' g.displayType '-' num2str(g.spikeSynapticOffset) '.eps']);
 close(h); 
end



