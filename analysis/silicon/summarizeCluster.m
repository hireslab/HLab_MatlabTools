function summarizeCluster(shankName, shankNumber, pathDir, clustparam, b) 
% Open a series of files, channel by channel
%saveDir = 'Q:\Silicon\Rates\';

saveDir = '/Volumes/MONOLITH/Silicon/Clusters/';

clust.chNum        = 38;
clust.freqSampling = 19530 ;
samplesPerChunk = clust.chNum*clust.freqSampling*30;

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
    fileTime=uint32((fileTime(4)*60*60+fileTime(5)*60+fileTime(6))*clust.freqSampling); % convert first file timestamp to uint32 stamp
    timeRange = [fileTime fileTime+5*clust.freqSampling] ;
    ind = find(shankName.timestamps >= timeRange(1) & shankName.timestamps < timeRange(2));
    
    spiketimes{1}{fnum} = shankName.timestamps(ind)-fileTime; % spiketimes{1} is multiunit activity
    
    for i=1:max(clustparam);
        spiketimes{i+1}{fnum} = shankName.timestamps(ind(clustparam(ind)==i))-fileTime;
        
    end
end

shank = shankName;
% save multiunit shank data

clust.ind = find(clustparam(:,1)>=(0));
clust.waves = shank.waves(clust.ind,:,:);
clust.timestamps = shank.timestamps(clust.ind,:,:);
clust.params = shank.params(clust.ind,:,:);
clust.paramnames = shank.paramnames;
clust.spiketimes = spiketimes{1};
 
save([saveDir 'MultiUnit/' pathDir(strfind(pathDir,'ANM')+(0:8)) '_' pathDir(strfind(pathDir,'ANM')+(10:15)) '_Shank' num2str(shankNumber) '_Multi.mat'],'clust')



% save cluster data

for i=unique(clustparam(find(clustparam(:,1)),1))';
clust.clustNumber = i
clust.shankNumber = shankNumber
clust.ind = find(clustparam(:,1)==(i));
clust.waves = shank.waves(clust.ind,:,:);
clust.timestamps = shank.timestamps(clust.ind,:,:);
clust.params = shank.params(clust.ind,:,:);
clust.paramnames = shank.paramnames;
clust.spiketimes = spiketimes{i+1};

cd(pathDir)

save([saveDir pathDir(strfind(pathDir,'ANM')+(0:8)) '_' pathDir(strfind(pathDir,'ANM')+(10:15)) '_Shank' num2str(shankNumber) '_Cluster' num2str(i) '.mat'],'clust')

end
%saveas(h_fig, [saveDir pathDir(12:20) '_' pathDir(22:27) '_' 'Shank' num2str(shankNumber) '_RateSummary.pdf']);
%print(h_fig,'-depsc',[saveDir pathDir(12:20) '_' pathDir(22:27) '_' 'Shank' num2str(shankNumber) '_RateSummary'])
 cd extract