%% Whisking Epoch Triggered spikes
figure(7)
clf;
hold on
trial = 150
vThresh = 50

colors = lines(17)

plot(abs(vel{trial}),'k')

for clust = 1:17
    try
plot(repmat(double(T.trials{trial}.shanksTrial.clustData{clust}.spikeTimes)/19530*1000-490,1,2),2000*([1 1.09]+.1*clust),'Color',colors(clust,:));
    end
    end
axis([300 2000 0 5000])
xlabel('Time (ms)')
ylabel({'Velocity (deg / s)','Acceleration (deg / (200*s^2))'})
grid on


widx = find(abs(vel{trial})>vThresh);
wepoch{trial}=[];
wepoch(:,1)=widx(diff([0 widx])>50)
wepoch(:,2)=widx(find(diff([0 widx])>50)-1)


%%
figure(10);clf;hold on
colors = lines(17)

vThresh = 100;
for trial = 1:280


widx = find(abs(vel{trial})>vThresh);
wepoch{trial}=[];
if ~isempty(widx(diff([0 widx])>vThresh));
wepoch{trial}(:,1)=widx(diff([0 widx])>vThresh);
wepoch{trial}(:,2)=widx(find(diff([0 widx])>vThresh)-1);
end
end


for i=1:length(contacts)
    spikeTimes{i} = cellfun(@(x)x.spikeTimes,T.trials{i}.shanksTrial.clustData,'UniformOutput',0);
end

% colors = gray(8);
% figure(5);clf;

timeWindow = [0.015 .04]

for j=9%length(Sind)% cellNumber

for eAlign = 3; % Number of epoch to align to



 binSize        = .005; % sec
 startWindow    = -.1; % seconds
 endWindow      = .1; % seconds
 edges          = startWindow:binSize:endWindow;
 

 for k=1
%      subplot(2,2,k);hold on

     allSpikes{k} = [];

     for i = 1:280
         try
         allSpikes{k} = cat(1,allSpikes{k},double(spikeTimes{i}{j})/sfS+wTTO-wfS*wepoch{i}(eAlign,1));
         end
     end
     
    allLength{k} = sum(cellfun(@(x)size(x,1),wepoch)>=eAlign);
    allHist{k}   = histc(allSpikes{k},edges)/allLength{k}/binSize;
    
    windSR(j,eAlign,k) = sum(allSpikes{k} > timeWindow(1) & allSpikes{k} < timeWindow(2)) / allLength{1} / diff(timeWindow);
    %bar(edges+binSize/2,allHist{k},'Color','r')
    plot(edges+binSize/2,allHist{k},'Color',colors(j,:),'LineWidth',2)
     set(gca,'Xlim',[startWindow endWindow])
     xlabel('Time (s)')
     ylabel('Mean Spike Count')
     grid on
  end
 
 
 
end


end