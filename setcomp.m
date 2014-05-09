dirTrialNums=[]
d=dir('*.seq')
for i=1:length(d)
dirTrialNums(i)=str2num(d(i).name(29:32)); % extract out the trial number from each bar file present in directory
end
vids=dirTrialNums
dirTrialNums=[]
d=dir('*.bar')
for i=1:length(d)
dirTrialNums(i)=str2num(d(i).name(29:32)); % extract out the trial number from each bar file present in directory
end
whiskers=dirTrialNums
p=setdiff(whiskers,vids) 
