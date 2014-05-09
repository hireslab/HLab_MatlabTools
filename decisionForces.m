figure;hold on;
colorcycle={'r','m','b','c'};
for i=1:4
     plot(nanmean(U.AH24.C.all.peakM0(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i),1:5))...
         ,colorcycle{i},'LineWidth',2);
     plot(nanmean(U.AH24.C.all.meanM0(find(cellfun(@(x)x.trialContactType,U.AH24.contacts)==i),1:5))...
         ,[':' colorcycle{i}],'LineWidth',2);
end

figure;hold on;
names=fieldnames(U.AH24.info);
colorcycle={'b','k','g','r'};
for i=1:4
     plot(nanmean(abs(U.AH24.C.decision.peakM0(U.AH24.info.(names{9+2*i}),1:5)))...
         ,colorcycle{i},'LineWidth',2);
     plot(nanmean(abs(U.AH24.C.decision.meanM0(U.AH24.info.(names{9+2*i}),1:5)))...
         ,[':' colorcycle{i}],'LineWidth',2);
end

% peak(hit, miss, FA, CR)
% mean(hit, miss, FA, CR)
% std(peak(hit, miss, FA, CR)
% std(mean(hit, miss, FA, CR)

for i=1:4;
    decisionForces(1,i)=mean(nanmean(abs(U.AH24.C.decision.peakM0(U.AH24.info.(names{9+2*i}),1:4))));
    decisionForces(2,i)=mean(nanmean(abs(U.AH24.C.decision.meanM0(U.AH24.info.(names{9+2*i}),1:4))));
    decisionForces(3,i)=mean(nanstd(abs(U.AH24.C.decision.peakM0(U.AH24.info.(names{9+2*i}),1:4))));
    decisionForces(4,i)=mean(nanstd(abs(U.AH24.C.decision.meanM0(U.AH24.info.(names{9+2*i}),1:4))));
end

U.AH24.decisionForces=decisionForces;