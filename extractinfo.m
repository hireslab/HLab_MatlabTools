U.AH24.contacts=contacts;

tmp=cell(1);
for i=1:length(T.trials);
    tmp{i}=T.trials{i}.behavTrial;
end
U.AH24.behavTrials=tmp;

tmp=cell(1);

for k=find(T.whiskerTrialInds)
    tmp{k}=T.trials{k}.whiskerTrial.time;
end
U.AH24.time=tmp;

tmp=fieldnames(T);
tmp2=struct(tmp{5},T.(tmp{5}));
for i=6:length(tmp);
    tmp2=setfield(tmp2,tmp{i},T.(tmp{i}));
end
U.AH24.info=tmp2;
U.AH24.C.all=C;

%save('/Lab/Whisker Project/Mouse/Summary/MouseSummary.mat','U')