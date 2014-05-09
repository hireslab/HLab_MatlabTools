function summarizeRates(shankName, shankNumber, pathDir, clustparam, b) 
% Open a series of files, channel by channel
%saveDir = 'Q:\Silicon\Rates\';

saveDir = '/Volumes/MONOLITH/Silicon/Rates';

chNum        = 38;
freqSampling = 19530 ;
samplesPerChunk = chNum*freqSampling*30;

colorSet=hsv(8);
spikeColor=[.1 .1 .1; 1 0 0; 1 0.6 0.1; 0 .8 0; 0 .8 .8; 0.8 0.9 0.5; 0.3 0.6 0.9; .1 1 .5; .6 .9 .1; .3 .1 .9; .4 .5 .1];

display(['Unclustered spikes = ' num2str(sum(clustparam(:,1)==0))])
for i=1:max(clustparam(:,1))
    display(['Spikes in cluster ' num2str(i) ' = ' num2str(sum(clustparam(:,1)==i))])
end

    
    %%
%pathDir    = 'Q:\Silicon\ANM144442\110813\';
d          = dir([pathDir '*DG*']);
fileList   = cell(length(d),1);
for i = 1:length(d);
    fileList{i}=d(i).name;
end
startFileIndex = 2; % Which file in the directory list do we start with?
endFileIndex   = length(d); % Which file in the directory list do we end with?

for fnum = startFileIndex:endFileIndex;%1:length(d);
    
    fileTime=datevec(d(fnum).date);
    fileTime=uint32((fileTime(4)*60*60+fileTime(5)*60+fileTime(6))*freqSampling); % convert first file timestamp to uint32 stamp
    timeRange = [fileTime fileTime+5*freqSampling] ;
    ind = find(shankName.timestamps >= timeRange(1) & shankName.timestamps < timeRange(2));
    
    spiketimes{1}{fnum} = shankName.timestamps(ind)-fileTime; % spiketimes{1} is multiunit activity
    
    for i=1:max(clustparam);
        spiketimes{i+1}{fnum} = shankName.timestamps(ind(clustparam(ind)==i))-fileTime;
        
    end
end
    
for i=1:max(clustparam(:,1))+1
 t_range = [find(cellfun(@length,spiketimes{i}),1,'first'), find(cellfun(@length,spiketimes{i}),1,'last')]; % trial range to assess
 hit_trials =  b.hitTrialNums(b.hitTrialNums >= t_range(1) & b.hitTrialNums <= t_range(2));
 miss_trials =  b.missTrialNums(b.missTrialNums >= t_range(1) & b.missTrialNums <= t_range(2));
 FA_trials =  b.falseAlarmTrialNums(b.falseAlarmTrialNums >= t_range(1) & b.falseAlarmTrialNums <= t_range(2));
 CR_trials =  b.correctRejectionTrialNums(b.correctRejectionTrialNums >= t_range(1) & b.correctRejectionTrialNums <= t_range(2));

 
 
 
 
 binSize = 50; % msec
 endWindow = 5; % seconds
 binSamples = freqSampling/1000*binSize;
 edges = 0:binSamples:endWindow*freqSampling;
 
 %%
 tmp=[];
 for j = miss_trials
     tmp = cat(1,tmp,spiketimes{i}{j});
 end
 
 S.miss=histc(tmp,edges)/length(miss_trials)*1000/binSize;
 
 
 tmp=[];
 for j = hit_trials
     tmp = cat(1,tmp,spiketimes{i}{j});
 end
 
 S.hit=histc(tmp,edges)/length(hit_trials)*1000/binSize;
 
 
 tmp=[];
 for j = CR_trials
     tmp = cat(1,tmp,spiketimes{i}{j});
 end
 
 S.CR=histc(tmp,edges)/length(CR_trials)*1000/binSize;
 
 
 tmp=[];
 for j = FA_trials
     tmp = cat(1,tmp,spiketimes{i}{j});
 end
 
 S.FA=histc(tmp,edges)/length(FA_trials)*1000/binSize;
 
 S.binSize = binSize; % msec
 S.edges = edges; % seconds
 S.freqSampling = freqSampling;

cd(pathDir)

save([saveDir pathDir(26:35) '_' pathDir(37:42) '_Shank' num2str(shankNumber) '_Cell' num2str(i-1) '.mat'],'S')

end
%saveas(h_fig, [saveDir pathDir(12:20) '_' pathDir(22:27) '_' 'Shank' num2str(shankNumber) '_RateSummary.pdf']);
%print(h_fig,'-depsc',[saveDir pathDir(12:20) '_' pathDir(22:27) '_' 'Shank' num2str(shankNumber) '_RateSummary'])
 cd extract