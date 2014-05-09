% U.AH05.contacts{2}.contactInds{1}(1)
% U.AH05.info.hitTrialInds
% U.AH05.behavTrials{1}.answerLickTime
% U.AH05.C.all.time(:,1)
% 
names=fieldnames(U);
hitmean=nan(20,1);
hitstd=nan(20,1);
FAmean=nan(20,1);
FAstd=nan(20,1);

for j=[1:6 8:15 17:20]
    
licktimes=cellfun(@(x)x.answerLickTime,U.AH05.behavTrials,'UniformOutput',0);
latency=nan(length(U.AH05.C.all.time(:,1)),1);
for i=1:length(U.AH05.C.all.time(:,1))
    if ~isempty(licktimes{i}-U.AH05.C.all.time(i,1))
        latency(i)=licktimes{i}-U.AH05.C.all.time(i,1);
    end
end

tmp=latency(U.(names{j}).info.hitTrialInds);
U.(names{j}).latency.hit.mean = nanmean(tmp(tmp>0.1));
U.(names{j}).latency.hit.std = nanstd(tmp(tmp>0.1));

hitmean(j)=nanmean(tmp(tmp>0.1))
hitstd(j)=nanstd(tmp(tmp>0.1))


tmp=latency(U.(names{j}).info.falseAlarmTrialInds);
U.(names{j}).latency.FA.mean = nanmean(tmp(tmp>0.1));
U.(names{j}).latency.FA.std = nanstd(tmp(tmp>0.1));

FAmean(j)=nanmean(tmp(tmp>0.1));
FAstd(j)=nanstd(tmp(tmp>0.1));

end
cla
errorbar(.9:.01:1.09,(hitmean),(hitstd),'bs')
hold on

errorbar(1.2:.01:1.39,(FAmean),(FAstd),'gs')

nanmean(hitmean)
nanmean(hitstd)
nanstd(hitmean)
nanmean(FAmean)
nanmean(FAstd)
nanstd(FAmean)