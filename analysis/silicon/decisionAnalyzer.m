
set(0,'DefaultLineMarkerSize',8);
%%
figure(2);clf;hold on
set(gcf,'Position',[-1900 100 1100 850],'PaperOrientation','portrait','PaperPosition',[0 0 11 8.5], 'PaperSize', [11 8.5])

D.sessionName = T.sessionName
D.performanceRange = [T.hitTrialNums(1) T.hitTrialNums(end)]
D.hitTrialNums              = T.hitTrialNums;
D.hitTrialInds              = T.hitTrialInds;
D.missTrialNums             = T.missTrialNums;
D.missTrialInds             = T.missTrialInds;
D.falseAlarmTrialNums       = T.falseAlarmTrialNums;
D.falseAlarmTrialInds       = T.falseAlarmTrialInds;
D.correctRejectionTrialNums = T.correctRejectionTrialNums;
D.correctRejectionTrialInds = T.correctRejectionTrialInds;



%%
subplot(4,3,3);cla;axis off
text(0,.9, ['\fontsize{10}' 'Session : ' T.sessionName]);
text(0,.7, ['\fontsize{10}' 'Performance Range : ' num2str(D.performanceRange(1)) ' - ' num2str(D.performanceRange(2))]);

       



subplot(4,3,6);cla;hold on
plot(T.hitTrialNums,1,'b.')
plot(T.correctRejectionTrialNums,2,'r.')
plot(T.falseAlarmTrialNums,3,'g.')
plot(T.missTrialNums,4,'k.')
set(gca,'YLim',[0 5])
xlabel('Trial')
ylabel('Trial Type')
%%

colorSet = {'g','k','r','b'};
[~,~,sweepRange]=intersect(D.performanceRange(1):D.performanceRange(2),T.trialNums);

trialCorrects = T.trialCorrects;
trialTypes = T.trialTypes;

subplot(4,3,[1 2]);cla;hold on

for sweepnum = sweepRange
    trialType = 1+trialTypes(sweepnum)+2*trialCorrects(sweepnum); % 1FA, 2M, 3CR, 4H
    trialNum = T.trialNums(sweepnum);
    
    if isempty(contacts{sweepnum}.segmentInds{1});
        plot([1:5]*1000+trialNum,0,[colorSet{trialType} 'o'],'MarkerSize',4)
        
    elseif isempty(T.trials{sweepnum}.behavTrial.beamBreakTimes)
        for i = find(T.trials{sweepnum}.whiskerTrial.time{1}(contacts{sweepnum}.segmentInds{1}(:,1))<1.75);
            try
                plot(i*1000+trialNum,contacts{sweepnum}.meanM0adj{1}(i),[colorSet{trialType} 'o'],'MarkerSize',4);
            end
        end
    else
        decisionLickTime = T.trials{sweepnum}.behavTrial.beamBreakTimes(find(T.trials{sweepnum}.behavTrial.beamBreakTimes > .750,1));
        
        for i = find(T.trials{sweepnum}.whiskerTrial.time{1}(contacts{sweepnum}.segmentInds{1}(:,1)) < decisionLickTime)
            
            try
                plot(i*1000+trialNum,contacts{sweepnum}.meanM0adj{1}(i),[colorSet{trialType} '.']);
            end
        end
    end
    
    
    
end
 set(gca,'XTick',[])
 ylabel('Mean Moment / Contact')
subplot(4,3,[4 5]);cla;hold on

for sweepnum = sweepRange
    trialType = 1+trialTypes(sweepnum)+2*trialCorrects(sweepnum); % 1FA, 2M, 3CR, 4H
    trialNum = T.trialNums(sweepnum);
    
    if isempty(contacts{sweepnum}.segmentInds{1});
        plot([1:5]*1000+trialNum,0,[colorSet{trialType} 'o'],'MarkerSize',4)
        
    elseif isempty(T.trials{sweepnum}.behavTrial.beamBreakTimes)
        for i = find(T.trials{sweepnum}.whiskerTrial.time{1}(contacts{sweepnum}.segmentInds{1}(:,1))<1.75);
            try
                plot(i*1000+trialNum,contacts{sweepnum}.peakFaxialAdj{1}(i),[colorSet{trialType} 'o'],'MarkerSize',4);
            end
        end
    else
        decisionLickTime = T.trials{sweepnum}.behavTrial.beamBreakTimes(find(T.trials{sweepnum}.behavTrial.beamBreakTimes > .750,1));
        for i = find(T.trials{sweepnum}.whiskerTrial.time{1}(contacts{sweepnum}.segmentInds{1}(:,1)) < decisionLickTime)
            
            try
                plot(i*1000+trialNum,contacts{sweepnum}.peakFaxialAdj{1}(i),[colorSet{trialType} '.']);
            end
        end
    end
    
    
    
end

ylabel('Peak Faxial / Contact')
 set(gca,'YLim',[-1e-4 1e-5],'XTick',[])
%% Conditional probabilities
% Some CR trials have licks in them!  The licks come before the answer
% period.

% Given a contact occurs, what is the probability of a lick?
% Given a contact does not occur, what is the probability of a lick?

% restrict to high performance rection
[~,~,sweepRange]=intersect(D.performanceRange(1):D.performanceRange(2),T.trialNums);

contactInds = cellfun(@(x)size(x.segmentInds{1},1),contacts(sweepRange)) > 0;  % which trial indexs in the high perf region have contacts?

pLC = sum(cellfun(@(x)size(x.beamBreakTimes,1)>0,T.trials(sweepRange(contactInds))))/sum(contactInds)
pLnC = sum(cellfun(@(x)size(x.beamBreakTimes,1)>0,T.trials(sweepRange(~contactInds))))/sum(~contactInds)

% breakout by pole position
for i =1:5
    poleInds{i} =  cellfun(@(x)x.barPosType,contacts(sweepRange)) == i;
end

for i = 1:5
    % prob of lick given contact, by pole position [n successes, n events, prob, 95% interval]
    
    
    D.pLCP{i}(1) = sum(cellfun(@(x)size(x.beamBreakTimes,1)>0,T.trials(sweepRange(logical(contactInds.*poleInds{i})))));
    D.pLCP{i}(2) = sum(logical(contactInds.*poleInds{i}));
    [D.pLCP{i}(3),D.pLCP{i}(4:5)] = binofit(D.pLCP{i}(1),D.pLCP{i}(2));
    
    % prob of no lick given no contact, by pole position
    D.pLnCP{i} = sum(cellfun(@(x)size(x.beamBreakTimes,1)>0,T.trials(sweepRange(logical(~contactInds.*poleInds{i})))));
    D.pLnCP{i}(2) = sum(logical(~contactInds.*poleInds{i}));
    [D.pLnCP{i}(3),D.pLnCP{i}(4:5)] = binofit(D.pLnCP{i}(1),D.pLnCP{i}(2));
    
    % prob of valid answer lick given contact, by pole position
    D.pALCP{i}(1) = sum(cellfun(@(x)size(x.answerLickTime,1)>0,T.trials(sweepRange(logical(contactInds.*poleInds{i})))));
    D.pALCP{i}(2) = sum(logical(contactInds.*poleInds{i}));
    [D.pALCP{i}(3),D.pALCP{i}(4:5)] = binofit(D.pALCP{i}(1),D.pALCP{i}(2));
    
    % prob of no valid answer lick given no contact, by pole position
    D.pALnCP{i}(1) = sum(cellfun(@(x)size(x.answerLickTime,1)>0,T.trials(sweepRange(logical(~contactInds.*poleInds{i})))));
    D.pALnCP{i}(2) = sum(logical(~contactInds.*poleInds{i}));
    [D.pALnCP{i}(3),D.pALnCP{i}(4:5)] = binofit(D.pALnCP{i}(1),D.pALnCP{i}(2));
    
    
end

% Plot results by pole position

subplot(4,3,9);cla;hold on
axis([.7 5.3 -.1 1.1])
for i = 1:5
    plot(i-.2, D.pLCP{i}(3),'ko','MarkerSize',6)
    plot([i-.2 i-.2], [D.pLCP{i}(4) D.pLCP{i}(5)],'color',[.7 .7 .7])

    plot(i-.1, D.pLnCP{i}(3),'kx','MarkerSize',6)
    plot([i-.1 i-.1], [D.pLnCP{i}(4) D.pLnCP{i}(5)],'color',[.7 .7 .7])

    plot(i+.1, D.pALCP{i}(3),'ro','MarkerSize',6)
    plot([i+.1 i+.1], [D.pALCP{i}(4) D.pALCP{i}(5)],'color',[1 .6 .6])

    plot(i+.2, D.pALnCP{i}(3),'rx','MarkerSize',6)
    plot([i+.2 i+.2], [D.pALnCP{i}(4) D.pALnCP{i}(5)],'color',[1 .6 .6])

end
xlabel('Pole Position')
ylabel('P(Lick|Contact)')

%%
% Plot the times of initial lick (not accepted answer lick)
% colored by trial type
subplot(4,3,[7 8]);cla;hold on

[~,~,sweepRange]=intersect(D.performanceRange(1):D.performanceRange(2),T.trialNums);
D.decisionLickPresent = zeros(max(sweepRange),1);
D.decisionLickTime = zeros(max(sweepRange),1);

for sweepnum = sweepRange
    trialType = 1+trialTypes(sweepnum)+2*trialCorrects(sweepnum); % 1FA, 2M, 3CR, 4H
    trialNum = T.trialNums(sweepnum);
    
    if ~isempty(T.trials{sweepnum}.behavTrial.beamBreakTimes(find(T.trials{sweepnum}.behavTrial.beamBreakTimes > .6,1)));
        D.decisionLickPresent(sweepnum)=1;
        D.decisionLickTime(sweepnum) = T.trials{sweepnum}.behavTrial.beamBreakTimes(find(T.trials{sweepnum}.behavTrial.beamBreakTimes > .6,1));
    end
    plot(trialNum,D.decisionLickTime(sweepnum),[colorSet{trialType} '.'])
end
ylabel('Initial Lick (s)')
set(gca,'YLim',[0 3])
grid on
%% Reaction Times
% Plot the 1st contact aligned times of initial lick (not accepted answer lick)
% colored by trial type

subplot(4,3,[10 11]);cla;hold on

D.reactionTime = nan(max(T.trialNums),1);

for sweepnum = sweepRange(find(contactInds));
    trialType = 1+trialTypes(sweepnum)+2*trialCorrects(sweepnum); % 1FA, 2M, 3CR, 4H
    trialNum = T.trialNums(sweepnum);
    
        if ~isempty(T.trials{sweepnum}.behavTrial.beamBreakTimes(find(T.trials{sweepnum}.behavTrial.beamBreakTimes > .6,1)));
        
            D.reactionTime(sweepnum) = D.decisionLickTime(sweepnum)-T.trials{sweepnum}.whiskerTrial.time{1}(contacts{sweepnum}.segmentInds{1}(1));
            plot(trialNum, D.reactionTime(sweepnum),[colorSet{trialType} '.'])
        end
end
set(gca,'YLim',[-1 2])
ylabel('1st Lick - 1st Contact (s)')
xlabel('Trial')
grid on
%%
subplot(4,3,12);cla;hold on

edges = [-.5:.05:1.5];

[hitN, hitBin]  = histc(D.reactionTime(find(T.hitTrialInds))                ,edges);
[faN, faBin]    = histc(D.reactionTime(find(T.falseAlarmTrialInds))         ,edges);
[crN, crBin]    = histc(D.reactionTime(find(T.correctRejectionTrialInds))   ,edges);
[mN, mBin]      = histc(D.reactionTime(find(T.missTrialInds))               ,edges);


bar(edges,hitN,'FaceColor','b')
bar(edges,faN,'FaceColor','g')
bar(edges,crN,'FaceColor','r')
bar(edges,mN,'FaceColor','k')
set(gca,'XLim',[edges(1) edges(end)])
xlabel('Reaction Time')
ylabel('Num')
%set(h_fa,'FaceColor','r')

%% Saving

print('-depsc', ['Q:\Silicon\Decision\Figures\Decision_' T.sessionName ])
save(['Q:\Silicon\Decision\D_' T.sessionName],'D')