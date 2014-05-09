SUdir  = 'Z:\users\Andrew\Whisker Project\SingleUnit\'
savedir = 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PhaseSR\'
hitContactPhase ={};
falseAlarmContactPhase = {};
correctRejectionContactPhase ={};
missContactPhase = {};
conPhase={};
for cellNum = 1:53
load([SUdir 'TrialArrays\' SU.trialArrayName{cellNum}])
load([SUdir 'ConTA\' SU.contactsArrayName{cellNum}])
load([SUdir 'CellAnalysisArrays\' SU.trialArrayName{cellNum}(13:end-4)])

preAnswerSegmentStart={};
CAtrials = find(cellfun(@(x)~isempty(x),CA.phase));
conPhase{cellNum} = cell(length(T.trialNums),1);
for tInd = CAtrials;
    
    
    if ~isempty(contacts{tInd}.segmentInds{1});
        if ~isempty(contacts{tInd}.answerLickTime);
            preAnswerSegmentStart{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<contacts{tInd}.answerLickTime,1);
        else
            preAnswerSegmentStart{tInd} = contacts{tInd}.segmentInds{1}(T.trials{tInd}.whiskerTrial.time{1}(contacts{tInd}.segmentInds{1}(:,1))<T.trials{tInd}.pinAscentOnsetTime,1);
            
        end
    else
        preAnswerSegmentStart{tInd} = [];
    end
    
    [~,~,preAnswerContactInd{tInd}] = intersect(T.trials{tInd}.whiskerTrial.time{1}(preAnswerSegmentStart{tInd}), CA.time{tInd})  % Shift start index by searching for matching times incase some frames are missing
    conPhase{cellNum}{tInd} = CA.phase{tInd}(preAnswerContactInd{tInd});
    
end

edges = -pi:pi/4:pi;

hitContactPhase{cellNum} = histc([conPhase{cellNum}{T.hitTrialInds}],edges);
falseAlarmContactPhase{cellNum} = histc([conPhase{cellNum}{T.falseAlarmTrialInds}],edges);
correctRejectionContactPhase{cellNum} = histc([conPhase{cellNum}{T.correctRejectionTrialInds}],edges);
missContactPhase{cellNum} = histc([conPhase{cellNum}{T.missTrialInds}],edges);

figure(3);clf;hold on;

if ~isempty(hitContactPhase{cellNum})
plot(edges(1:end-1)+pi/8,hitContactPhase{cellNum}(1:end-1),'bo-')
end
if ~isempty(falseAlarmContactPhase{cellNum})
plot(edges(1:end-1)+pi/8,falseAlarmContactPhase{cellNum}(1:end-1),'go-')
end
if ~isempty(correctRejectionContactPhase{cellNum})
plot(edges(1:end-1)+pi/8,correctRejectionContactPhase{cellNum}(1:end-1),'ro-')
end
if ~isempty(missContactPhase{cellNum})
plot(edges(1:end-1)+pi/8,missContactPhase{cellNum}(1:end-1),'ko-')
end
title(SU.cellName{cellNum})
xlabel('whisk phase at contact')
ylabel('# of pre-answer contacts')

    print(gcf, '-depsc', [savedir 'ContactPhase_' SU.trialArrayName{cellNum}(13:end-4)]);
end
%%
hold on
cla
plot(edges,reshape([correctRejectionContactPhase{1:53}],9,477/9),'r')
plot(edges,reshape([hitContactPhase{1:53}],9,477/9),'b')
plot(edges,reshape([falseAlarmContactPhase{1:53}],9,477/9),'g')
plot(edges,reshape([missContactPhase{1:53}],9,450/9),'k')
title('Cell-Attached Contacts by Phase, Trial Type')
set(gca,'XLim',[-pi pi])

ylabel('total pre answer licks')
xlabel('whisking phase at contact (radians)')
    print(gcf, '-depsc', [savedir 'ContactPhase_TrialType']);
%%
totalTouch = reshape([hitContactPhase{1:53}],9,477/9)+reshape([correctRejectionContactPhase{1:53}],9,477/9)...
    +reshape([falseAlarmContactPhase{1:53}],9,477/9);

 phaseContactCellNums = find(min(totalTouch(1:8,:))>=8)
 
 %%
 for cellNum = 1:53;
    load([SUdir 'CellAnalysisArrays\' SU.trialArrayName{cellNum}(13:end-4)]) ;
      load([SUdir 'TrialArrays\' SU.trialArrayName{cellNum}]);
hitConNum{cellNum} = sum(hitContactPhase{cellNum})/length(intersect(find(T.hitTrialInds),1:length(CA.phase)));
correctRejectionConNum{cellNum} = sum(correctRejectionContactPhase{cellNum})/length(intersect(find(T.correctRejectionTrialInds),1:length(CA.phase)));
falseAlarmConNum{cellNum} = sum(falseAlarmContactPhase{cellNum})/length(intersect(find(T.falseAlarmTrialInds),1:length(CA.phase)));
missConNum{cellNum} = sum(missContactPhase{cellNum})/length(intersect(find(T.missTrialInds),1:length(CA.phase)));

 end
%%
figure(8);clf
for i=1:53
    contactsByType(i,1)=hitConNum{i};
    contactsByType(i,2)=correctRejectionConNum{i};
    contactsByType(i,3)=falseAlarmConNum{i};
    try
    contactsByType(i,4)=missConNum{i};
    end
end
    
plot(contactsByType(:,1:3),'o-')
title('Contact distribution across sessions by trial type')
xlabel('Recording Session')
ylabel('Average number of pre-answer contacts')
    print(gcf, '-depsc', [savedir 'ContactDistributionSummaryTrialType']);
    
    %%
    figure(5);clf
    plot(min(totalTouch(1:8,:)),'o')
    
xlabel('recording session')
ylabel('minimum # contacts in phase bin')
        print(gcf, '-depsc', [savedir 'MinTotalTouchPhaseBin']);

    
    