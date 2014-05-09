  h_mean=figure;
plotWindow = [-200 500]


for j=7;%find(structfun(@(x)x.info.depth,U)<500)'
%    subplot(5,4,find(depthOrder(:,2)==j))
   % cla;
    hold on;

    contactDelay = zeros(92000,1);
    spikesArray  = cellfun(@(x)x, U.(cellNames{j}).spikeTimes,'UniformOutput',0);

    cla;
    hold on;
    for i=find((U.(cellNames{j}).info.hitTrialInds) .* U.(cellNames{j}).info.whiskerTrialInds);
        if (spikesArray{i} & ~isempty(U.(cellNames{j}).contacts{i}.segmentInds{1}));
            contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) ...
                = contactDelay(spikesArray{i}-U.(cellNames{j}).contacts{i}.segmentInds{1}(1)*10+46000) + 1;
        end
    end
    y=smooth(contactDelay,801);
    plot(((1:92000)-46000)/10,y./mean(y(44000:46000)),'k')
    plot([plotWindow(1) plotWindow(2)],repmat(mean(y(44000:46000))+4*std(y(44000:46000)),2,1)./mean(y(44000:46000)),'b-')
    plot([0 0],[0 1.2*max(y)./mean(y(44000:46000))],'k:')
    title([U.(cellNames{j}).info.cellNum, ' - ', num2str(U.(cellNames{j}).info.depth-100)]);
    ylim([0 1.2*max(y(44000:47000))./mean(y(44000:46000))])
    grid off
    xlim(plotWindow)
    set(gca,'XTickLabel',[])%,'YTickLabel',[])
end


xlabel('Time from initial contact (ms)');
ylabel('Spike Rate / Mean Pre-contact Spike Rate')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 7 7])
%print(gcf, '-depsc',['AllLatenciesTraces.eps']);



%%
spikeTimesCon=cell(length(T.trials));
spikeIndexCon=zeros(701,length(T.trials));
for i=1:length(T.trials)
    spikeTimesCon{i}=round((T.trials{i}.spikesTrial.spikeTimes-round(contactAlignVect(i)*10000)+2000)/10);
    spikeTimesCon{i}=spikeTimesCon{i}(spikeTimesCon{i} > 0 & spikeTimesCon{i} < 701);
    if numel(spikeTimesCon{i})
        spikeIndexCon(spikeTimesCon{i},i)=1;
    end
end
cla;
plot((-200:500)/1000,1000*smooth(sum(spikeIndexCon(:,cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==0),2),10)...
    /sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==0),'k')
hold on
plot((-200:500)/1000,1000*smooth(sum(spikeIndexCon(:,cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==3),2),10)...
    /sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==3),'r');

plot((-200:500)/1000,1000*smooth(sum(spikeIndexCon(:,cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==1),2),10)...
    /sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==1),'b');