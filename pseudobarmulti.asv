filelist=dir('*.measurements')
for i=1:length(filelist);
    system(['touch ' filelist(i).name(1:end-13) '.bar'])
end

motorPosition=cellfun(@(x)x.motorPosition,b.trials);
motorPosition(b.trialNums)=motorPosition;

% go is a matrix of bar positions

dirTrialNums=[];
go=zeros(5000,3,4);
for i=1:4
    go(:,1,i)=0:4999;
end
go(:,2,1)=317; % center bar x pixel
go(:,3,1)=64; % center bar y pixel

go(:,2,2)=315; % center bar x pixel
go(:,3,2)=126; % center bar y pixel

go(:,2,3)=313; % center bar x pixel
go(:,3,3)=184; % center bar y pixel

go(:,2,4)=311; % center bar x pixel
go(:,3,4)=244; % center bar y pixel

nogo=zeros(5000,3);
nogo(:,1)=0:4999;
nogo(:,2)=306; % center bar x pixel
nogo(:,3)=392; % center bar y pixel

% must have behavior file loaded
% saved.SidesSection_previous_sides is a list of trials where go = 114 and
% nogo = 108

MotorSettings=[120,100,80,60]; % The rounded off positions of the motor in go positions 1-4

gngM=zeros(length(saved.SidesSection_previous_sides),1);
for i=1:4
    gngM(find(round(motorPosition/1000)==(MotorSettings(i))))=i;
end

d=dir('*.bar'); % watch out for missing trials

dirTrialNums=[];

for i=1:length(d);
    dirTrialNums(i)=str2num(d(i).name(29:32)); % extract out the trial number from each bar file present in directory
end

%trial=[8:304] % the trial number of each trial
k=55:200;
for i=1:length(k)   % number of trials
     
    if ~isempty(find(dirTrialNums==k(i)))
        for j=1:4
        if gngM(k(i))==j  % gng is a vector of all trials in a session where a go trial is a 1 and a no-go trial is a 0
            gom=go(:,:,j);
            gom(:,3)=gom(:,3);
                fid=fopen(d(find(dirTrialNums==k(i))).name, 'wt')
                fprintf(fid, '%u %u %u \n', gom')
            fclose(fid)


        else
            nogom=nogo;
            nogom(:,3)=nogom(:,3);
                fid=fopen(d(find(dirTrialNums==k(i))).name, 'wt')
                fprintf(fid, '%u %u %u \n', nogom')
            fclose(fid)
        end
        end
    else
        sprintf(strcat('Bar file for trial #', num2str(k(i)), ' is missing, skipping...'))
    end
end
%% Include Files creation

dirTrialNums=[];
trialNums=[55:200];  % enter which trial nums to use here
includef=cell(length(trialNums),1);

for i=1:length(filelist);
    dirTrialNums(i)=str2num(filelist(i).name(29:32)); % extract out the trial number from each measurements file present in directory
end

for i=[1:length(trialNums)];
    includef{i}=filelist(find(dirTrialNums==trialNums(i))).name(1:end-13);
end

