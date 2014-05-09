conD = '/Lab/Silicon/ConTA'
ctaD = '/Lab/Silicon/CTA'

cd(conD)
conF = dir('*ConTA*')

cd(ctaD)
ctaF = dir('*CTA*')
%%

figure(1);clf;
figure(2);clf;
figure(3);clf;



for k = 4:21;
    
    cd(conD)
    load(conF(k).name)
        cd(ctaD)
    load(ctaF(k).name)


perfIndRange = intersect(find(T.whiskerTrialInds),[find(T.hitTrialInds,1,'first'):find(T.hitTrialInds,1,'last')]);
lickTrialInds = cellfun(@(x)~isempty(x.beamBreakTimes),T.trials);
aveFirstLick = mean(cellfun(@(x)x.beamBreakTimes(1),T.trials(T.hitTrialInds)))

% Hit
tabH = nan(length(T.whiskerTrialInds),4500);
sabH = nan(length(T.whiskerTrialInds),4500);
m0H = nan(length(T.whiskerTrialInds),4500);
for i = intersect(find(T.hitTrialInds), perfIndRange);
    t = T.trials{i}.whiskerTrial.time{1};
    tm = T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1});
    tab = T.trials{i}.whiskerTrial.thetaAtBase{1};
    sab = abs(diff([0 tab]));
    m0b = abs(T.trials{i}.whiskerTrial.M0{1}(contacts{i}.contactInds{1}));
    plot(t,tab,'Color',[.75 .75 1])
    %plot(T.trials{i}.whiskerTrial.time{1}-T.trials{i}.beamBreakTimes(1),T.trials{i}.whiskerTrial.thetaAtBase{1},'Color',[.75 .75 .75])
    tabH(i,round(t*1000+1)) = tab;
    sabH(i,round(t*1000+1)) = sab;
    m0H(i,round(tm*1000+1)) = m0b;
    
end
% Miss

tabM = nan(length(T.whiskerTrialInds),4500);
sabM = nan(length(T.whiskerTrialInds),4500);
m0M = nan(length(T.whiskerTrialInds),4500);

for i = intersect(find(T.missTrialInds), perfIndRange);
    t = T.trials{i}.whiskerTrial.time{1};
    tm = T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1});
    
    tab = T.trials{i}.whiskerTrial.thetaAtBase{1};
    sab = abs(diff([0 tab]));
    m0b = abs(T.trials{i}.whiskerTrial.M0{1}(contacts{i}.contactInds{1}));
    
    %plot(t,tab,'Color',[.75 .75 .75])
    %plot(T.trials{i}.whiskerTrial.time{1}-T.trials{i}.beamBreakTimes(1),T.trials{i}.whiskerTrial.thetaAtBase{1},'Color',[.75 .75 .75])
    tabM(i,round(t*1000+1)) = tab;
    sabM(i,round(t*1000+1)) = sab;
    m0M(i,round(tm*1000+1)) = m0b;
    
end


%CR
tabCR = nan(length(T.whiskerTrialInds),4500);
sabCR = nan(length(T.whiskerTrialInds),4500);
m0CR = nan(length(T.whiskerTrialInds),4500);

for i = intersect(find(T.correctRejectionTrialInds), perfIndRange);
    t = T.trials{i}.whiskerTrial.time{1};
    tm = T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1});
    
    tab = T.trials{i}.whiskerTrial.thetaAtBase{1};
    sab = abs(diff([0 tab]));
    m0b = abs(T.trials{i}.whiskerTrial.M0{1}(contacts{i}.contactInds{1}));
    
    
    %plot(t,tab,'Color',[1 .75 .75])
    %plot(T.trials{i}.whiskerTrial.time{1}-T.trials{i}.beamBreakTimes(1),T.trials{i}.whiskerTrial.thetaAtBase{1},'Color',[.75 .75 .75])
    tabCR(i,round(t*1000+1)) = tab;
    sabCR(i,round(t*1000+1)) = sab;
    m0CR(i,round(tm*1000+1)) = m0b;
    
end
%FA
tabFA = nan(length(T.whiskerTrialInds),4500);
sabFA = nan(length(T.whiskerTrialInds),4500);
m0FA = nan(length(T.whiskerTrialInds),4500);

for i = intersect(find(T.falseAlarmTrialInds), perfIndRange);
    t = T.trials{i}.whiskerTrial.time{1};
    tm = T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1});
    
    tab = T.trials{i}.whiskerTrial.thetaAtBase{1};
    sab = abs(diff([0 tab]));
    m0b = abs(T.trials{i}.whiskerTrial.M0{1}(contacts{i}.contactInds{1}));
    
    %plot(t,tab,'Color',[.75 1 .75])
    %plot(T.trials{i}.whiskerTrial.time{1}-T.trials{i}.beamBreakTimes(1),T.trials{i}.whiskerTrial.thetaAtBase{1},'Color',[.75 .75 .75])
    tabFA(i,round(t*1000+1)) = tab;
    sabFA(i,round(t*1000+1)) = sab;
    m0FA(i,round(tm*1000+1)) = m0b;
    
end
figure(1);subplot(5,5,k);cla;hold on

plot((1:4500)/1000,nanmean(tabM(:,1:4500)) ,'k','LineWidth',1)
plot((1:4500)/1000,nanmean(tabFA(:,1:4500)),'g','LineWidth',1)
plot((1:4500)/1000,nanmean(tabCR(:,1:4500)),'r','LineWidth',1)
plot((1:4500)/1000,nanmean(tabH(:,1:4500)) ,'b','LineWidth',1)

figure(2);subplot(5,5,k);cla;hold on

plot((1:4500)/1000,smooth(nanmean(sabM(:,1:4500)),5) ,'k','LineWidth',1)
plot((1:4500)/1000,smooth(nanmean(sabFA(:,1:4500)),5),'g','LineWidth',1)
plot((1:4500)/1000,smooth(nanmean(sabCR(:,1:4500)),5),'r','LineWidth',1)
plot((1:4500)/1000,smooth(nanmean(sabH(:,1:4500)),5) ,'b','LineWidth',1)
set(gca,'XLim',[.005 4.5])

figure(3);subplot(5,5,k);cla;hold on
plot((1:4500)/1000,nanmean(m0M(:,1:4500)) ,'k','LineWidth',1)
plot((1:4500)/1000,nanmean(m0CR(:,1:4500)),'r','LineWidth',1)
plot((1:4500)/1000,nanmean(m0FA(:,1:4500)),'g','LineWidth',1)
plot((1:4500)/1000,nanmean(m0H(:,1:4500)) ,'b','LineWidth',1)
set(gca,'XLim',[.005 4.5])
end

