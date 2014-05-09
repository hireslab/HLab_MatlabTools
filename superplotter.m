plotWindow = [0 100]

colororder={'k','r','m','b','c'};
depthOrder=sortrows([structfun(@(x)x.info.depth,U), (1:21)'],1);

for j=depthOrder(:,2)'%find(structfun(@(x)x.info.depth,U)<500)'
    subplot(5,5,find(depthOrder(:,2)==j))
    cla;
    hold on;
    
    for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==1);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'r.')
        end
    end
    
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==2);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'m.')
        end
       end
       
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==3);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'b.')
        end
       end
       
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==4);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'c.')
        end
       end
    title([U.(cellNames{j}).info.cellNum, ' - ', num2str(U.(cellNames{j}).info.depth)]);
    grid on
    xlim(plotWindow)
    
    
end


%% Means

for j=1:19%find(structfun(@(x)x.info.depth,U)<500)'
    subplot(5,4,j)
    cla;
    hold on;
    
    for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==1);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'r.')
        end
    end
    
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==2);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'m.')
        end
       end
       
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==3);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'b.')
        end
       end
       
       for i=find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==4);
        try
            plot(U.(cellNames{j}).spikeTimes{i}(U.(cellNames{j}).spikeTimes{i} > (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(1))*10 ...
                                          & U.(cellNames{j}).spikeTimes{i} < (U.(cellNames{j}).contacts{i}.segmentInds{1}(1)+plotWindow(2))*10)/10 ...
                                          - U.(cellNames{j}).contacts{i}.segmentInds{1}(1),i,'c.')
        end
       end
    title(num2str(U.(cellNames{j}).info.depth));
    grid on
    xlim(plotWindow)
    
    
end

%% Means
    h_mean=figure;
plotWindow = [-50 100]


for j=depthOrder(:,2)';%find(structfun(@(x)x.info.depth,U)<500)'
    subplot(5,4,find(depthOrder(:,2)==j))
   % cla;
    hold on;

    contactDelay = zeros(92000,1);
    spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);

    cla;
    hold on;
    for i=find((U.(cellNames{j}).info.correctRejectionTrialInds+U.(cellNames{j}).info.hitTrialInds) .* U.(cellNames{j}).info.whiskerTrialInds);
        if (spikesArray{i} & ~isempty(U.(cellNames{j}).contacts{i}.segmentInds{1}));
            contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) ...
                = contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) + 1;
        end
    end
    y=smooth(contactDelay,51);
    plot(((1:92000)-46000)/10,y./mean(y(44000:46000)),'k')
    plot([plotWindow(1) plotWindow(2)],repmat(mean(y(44000:46000))+4*std(y(44000:46000)),2,1)./mean(y(44000:46000)),'b-')
    plot([0 0],[0 1.2*max(y)./mean(y(44000:46000))],'k:')
    title([U.(cellNames{j}).info.cellNum, ' - ', num2str(U.(cellNames{j}).info.depth-100)]);
    ylim([0 1.2*max(y(44000:47000))./mean(y(44000:46000))])
    grid off
    xlim(plotWindow)
    set(gca,'XTickLabel',[])%,'YTickLabel',[])
end
for i=17:20
subplot(5,4,i);

set(gca, 'XTick', [-50 0 50 100], 'XTickLabel',[-50 0 50 100]);
end
subplot(5,4,18);

xlabel('Time from initial contact (ms)');
subplot(5,4,9)
ylabel('Spike Rate / Mean Pre-contact Spike Rate')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 7 7])
print(gcf, '-depsc',['AllLatenciesTraces.eps']);

%%
spikeIndex=cell(1,array.length);


for k=1:array.length
    spikeIndex{k}=zeros(array.trials{k}.spikesTrial.sweepLengthInSamples+shiftPad,1);
    % Calculate the spike rate across trials
    if contacts{k}.trialContactType
        spikeIndex{k}(array.trials{k}.spikesTrial.spikeTimes+shiftPad-contacts{k}.segmentInds{1}(1)*10)=1;
    else
        spikeIndex{k}(array.trials{k}.spikesTrial.spikeTimes+shiftPad-round(meanFirstTouch*10))=1;

    end
end




gpSpikeRate=cell2mat(cellfun(@(x) smooth(x,params.spikeRateWindow*sampleRate)*sampleRate...
    ,spikeIndex(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==1),useTrials)),'UniformOutput',0));

%%




for j=depthOrder(:,2)';%find(structfun(@(x)x.info.depth,U)<500)'
    subplot(5,5,find(depthOrder(:,2)==j))
    hold on;
    cla;
    contactDelay = zeros(92000,1);
    spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);

    cla;
    hold on;
    useTrials=intersect(find(U.(cellNames{j}).info.whiskerTrialInds), find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==1 | cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==3));
    for i=useTrials;
        if (spikesArray{i} & ~isempty(U.(cellNames{j}).contacts{i}.segmentInds{1}));
            contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) ...
                = contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) + 1;
        end
    end

    plot(((1:92000)-46000)/10,smooth(contactDelay,51)/mean(contactDelay(44000:46000))+3*std(smooth(contactDelay(44000:46000),51)),'-b')
%    plot([plotWindow(1) plotWindow(2)],repmat(mean(contactDelay(44000:46000))+3*std(smooth(contactDelay(44000:46000),51)),2,1),'--b')
        plot([plotWindow(1) plotWindow(2)],[1 1],'--b')

    contactDelay = zeros(92000,1);

    useTrials=intersect(find(U.(cellNames{j}).info.whiskerTrialInds), find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==2 | cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==4));

    for i=useTrials;
        if (spikesArray{i} & ~isempty(U.(cellNames{j}).contacts{i}.segmentInds{1}));
            contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) ...
                = contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) + 1;
        end
    end
      plot(((1:92000)-46000)/10,smooth(contactDelay,51)/mean(contactDelay(44000:46000))+3*std(smooth(contactDelay(44000:46000),51)),'-r')
   % plot([plotWindow(1) plotWindow(2)],repmat(mean(contactDelay(44000:46000))+3*std(smooth(contactDelay(44000:46000),51)),2,1),'--r')
        plot([plotWindow(1) plotWindow(2)],[1 1],'--r')

    title(num2str(U.(cellNames{j}).info.depth));
    grid on
    xlim(plotWindow)
end

%% Latency from first contact to first spike

figure;
for j=1:21;
contactDelay = zeros(92000,1);
spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);  % All spike times in Session

ind=intersect(find(U.(cellNames{j}).info.whiskerTrialInds), find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)>0));  % All trials corresponding to a contact type


tmp=cell(length(ind),1);
y=nan(1,length(tmp));
x=nan(1,length(tmp));

 for i=1:length(ind);
        if ~isempty(U.(cellNames{j}).contacts{ind(i)}.segmentInds{1});   % Execute if there are contacts
            tmp{i}=spikesArray{ind(i)}-U.(cellNames{j}).contacts{ind(i)}.segmentInds{1}(1)*10;        % Timeshift spiketimes by time of first contact 
            x(i)=U.(cellNames{j}).contacts{ind(i)}.peakM0{1}(1);                                 % peak M0 in first contact
            
        end
        tmp2=find(tmp{i}>0);
        if ~isempty(tmp2)
            y(i)=tmp{i}(tmp2(1));
        end
        
       
 end
 
subplot(5,4,find(depthOrder(:,2)==j))

 plot((x(find(y<500))),y(find(y<500))/10,'r.')
hold on
plot(x(find(y>500)),5,'ko')
plot([0,0],[5 50])
 ylim([0 50])
end


%% Latency from first contact to significant change in spike rate
spanWindow=40;
colororder2={[1 0 0], [1 .5 .5], [0 0 1], [.5 .5 1]};
contactLatency=cell(length(U),4);
sdthreshold = [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];

figure;
for j=depthOrder(:,2)'
contactDelay = zeros(92000,4);
spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);  % All spike times in Session

ind=intersect(find(U.(cellNames{j}).info.whiskerTrialInds), find(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)>0));  % All trials corresponding to a contact type


tmp=cell(length(ind),1);
y=nan(1,length(tmp));
x=nan(1,length(tmp));

 for i=1:length(ind);
        if ~isempty(U.(cellNames{j}).contacts{ind(i)}.segmentInds{1});   % Execute if there arebcontacts
            tmp{i}=spikesArray{ind(i)}-U.(cellNames{j}).contacts{ind(i)}.segmentInds{1}(1)*10;        % Timeshift spiketimes by time of first contact 
            x(i)=U.(cellNames{j}).contacts{ind(i)}.peakM0{1}(1);                                 % Average M0 in first contact
            
        end
        tmp2=find(tmp{i}>0);
        if ~isempty(tmp2)
            y(i)=tmp{i}(tmp2(1));
        end
        
       
 end
 
 xSorted=sortrows([x; 1:length(x)]');

 xSortInds{1} = xSorted(1:floor(sum(xSorted(:,1)<=0)/2),2);
 xSortInds{2} = xSorted(floor(sum(xSorted(:,1)<=0)/2)+1:sum(xSorted(:,1)<=0),2);
 xSortInds{3} = xSorted(sum(xSorted(:,1)<=0)+(1:floor(sum(xSorted(:,1)>0)/2)),2);
 xSortInds{4} = xSorted(sum(xSorted(:,1)<=0)+(floor(sum(xSorted(:,1)>0)/2)+1:sum(xSorted(:,1)>0)),2);

for k=1:4
    for i=1:length(xSortInds{k});
         contactDelay(tmp{xSortInds{k}(i)}+46000,k) ...
                = contactDelay(tmp{xSortInds{k}(i)}+46000,k) + 1;
    end
end
subplot(5,5,find(depthOrder(:,2)==j))

% plot((1:2000)-1000,smooth(contactDelay(45001:47000,1),spanWindow))
% hold on
% plot((1:2000)-1000,smooth(contactDelay(45001:47000,2),spanWindow),'r')
% plot((1:2000)-1000,smooth(contactDelay(45001:47000,3),spanWindow),'c')
% plot((1:2000)-1000,smooth(contactDelay(45001:47000,4),spanWindow),'k')

for k=1:4
    hold on
    tmp3{k}=smooth(contactDelay(:,k),spanWindow);
end
for k=1:4

    contactLatency{j,k}=find((tmp3{k}(46001:47000)-mean(tmp3{k}(44001:46000))) ...
        / std(cat(1,tmp3{1}(44001:46000),tmp3{2}(44001:46000),tmp3{3}(44001:46000),tmp3{4}(44001:46000)))>sdthreshold(j))/10;
    plot((-999:1000)/10,(tmp3{k}(45001:47000)-mean(tmp3{k}(44001:46000))) ...
        / std(cat(1,tmp3{1}(44001:46000),tmp3{2}(44001:46000),tmp3{3}(44001:46000),tmp3{4}(44001:46000))), 'color', colororder2{k})
    
end

hold on
plot([-100 100], [sdthreshold(j) sdthreshold(j)],'k--')
plot([0 0], [0 10],'k--')
title([U.(cellNames{j}).info.cellNum, ' - ', num2str(U.(cellNames{j}).info.depth)]);

end

latencies=nan(size(contactLatency));
figure
for i=1:size(contactLatency,1);
    for j=1:size(contactLatency,2)
        try
            latencies(i,j)=contactLatency{i,j}(1);
        end
    end
end

latencies(latencies>50)=nan
cla
hold on
plot(1:4, latencies, 'o-')
plot(1:4,nanmean(latencies),'ko')
xlim([0.5 4.5])
ylim([0 50])

set(gca,'XTickLabel',{'Hard Pro', 'Soft Pro', 'Soft Ret', 'Hard Ret'})


figure
cla;
hold on;
plot(structfun(@(x)x.info.depth,U)-100,min(latencies,[],2),'o');
plot(structfun(@(x)x.info.depth,U)-100,structfun(@(x)nanmean(x.spikeRate.prepole),U),'k.')
plot(structfun(@(x)x.info.depth,U)-100,structfun(@(x)nanmean(x.spikeRate.decision),U),'r.')

%%
latencyFind=zeros(20,100);

for j=depthOrder(:,2)';
contactDelay = zeros(92000,1);

 spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);


    for i=find(U.(cellNames{j}).info.whiskerTrialInds);
        if (spikesArray{i} & ~isempty(U.(cellNames{j}).contacts{i}.segmentInds{1}));
            contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) ...
                = contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) + 1;
        end
    end

tmp = smooth(contactDelay,51);
tmp=find(tmp(46000:end) > mean(contactDelay(44000:46000))+4*std(smooth(contactDelay(44000:46000),51)));
if length(tmp) >= 100;
    latencyFind(j,1:100)=tmp(1:100);    
else
    latencyFind(j,1:length(tmp))=tmp;
end

end