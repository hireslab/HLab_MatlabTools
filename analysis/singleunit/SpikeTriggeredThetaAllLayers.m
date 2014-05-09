figure(2);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 8.5 11],'PaperSize', [8.5 11])
subplot(2,2,[3 4]);cla; hold on

xGo=[]
yGo=[]
xNogo=[]
yNogo=[]
for i = 1:length(SUnums_Lall)
    for j = 1:5
        xGo(i,j) = nanmean([SU.contactAligned.contactGoSpikeTheta{SUnums_Lall(i)}{:,1:j}]);
        xNogo(i,j) = nanmean([SU.contactAligned.contactNogoSpikeTheta{SUnums_Lall(i)}{:,1:j}]);
        yGo(i,j) = nanmean([SU.contactAligned.contactGoSpikeNums{SUnums_Lall(i)}{:,1:j}]);
        yNogo(i,j) = nanmean([SU.contactAligned.contactNogoSpikeNums{SUnums_Lall(i)}{:,1:j}]);
    end
end

for i = SUnums_Lall
    for j = 1:5
        plot(nanmean([SU.contactAligned.contactGoSpikeTheta{i}{:,1:j}]),nanmean([SU.contactAligned.contactGoSpikeNums{i}{:,1:j}]),'bo','markersize',12-2*j)
        plot(nanmean([SU.contactAligned.contactNogoSpikeTheta{i}{:,1:j}]),nanmean([SU.contactAligned.contactNogoSpikeNums{i}{:,1:j}]),'ro','markersize',12-2*j)
    end
end

plot(xGo',yGo','b','LineWidth',1)
plot(xNogo',yNogo','r','LineWidth',1)
plot(mean(xGo),mean(yGo),'bd-','LineWidth',2)
plot(mean(xNogo),mean(yNogo),'rd-','LineWidth',2)

xlabel('Mean Contact Spike Triggered Theta')
ylabel('Mean Spikes / Contact')
title('All C2 cells, integrated trajectory over 5 contacts')

subplot(2,2,1);cla; hold on

for i = SUnums_Lall
    x2Go    = nanmean([SU.contactAligned.contactGoSpikeTheta{i}{:,1}])
    x2GoE   = nanstd([SU.contactAligned.contactGoSpikeTheta{i}{:,1}])
    x2Nogo  = nanmean([SU.contactAligned.contactNogoSpikeTheta{i}{:,1}])
    x2NogoE = nanstd([SU.contactAligned.contactNogoSpikeTheta{i}{:,1}])
    y2Go    = nanmean([SU.contactAligned.contactGoSpikeNums{i}{:,1}])
    y2GoE   = nanstd([SU.contactAligned.contactGoSpikeNums{i}{:,1}])
    y2Nogo  = nanmean([SU.contactAligned.contactNogoSpikeNums{i}{:,1}])
    y2NogoE = nanstd([SU.contactAligned.contactNogoSpikeNums{i}{:,1}])
    
    
    
    plot(x2Go,y2Go,'bo','markersize',5)
    plot(x2Nogo,y2Nogo,'ro','markersize',5)
    plot([-x2GoE x2GoE]+x2Go,[y2Go y2Go],'b-','linewidth',1)
    plot([x2Go x2Go],[-y2GoE y2GoE]+y2Go,'b-','linewidth',1)
  plot([-x2NogoE x2NogoE]+x2Nogo,[y2Nogo y2Nogo],'r-','linewidth',1)
    plot([x2Nogo x2Nogo],[-y2NogoE y2NogoE]+y2Nogo,'r-','linewidth',1)
set(gca,'Ylim',[0 4])
end

xlabel('Mean Contact Spike Triggered Theta')
ylabel('Mean Spikes / Contact')
title('All C2 cells, first contact')

subplot(2,2,2);cla; hold on

for i = SUnums_Lall
    x3Go    = nanmean([SU.contactAligned.contactGoSpikeTheta{i}{:,2:5}])
    x3GoE   = nanstd([SU.contactAligned.contactGoSpikeTheta{i}{:,2:5}])
    x3Nogo  = nanmean([SU.contactAligned.contactNogoSpikeTheta{i}{:,2:5}])
    x3NogoE = nanstd([SU.contactAligned.contactNogoSpikeTheta{i}{:,2:5}])
    y3Go    = nanmean([SU.contactAligned.contactGoSpikeNums{i}{:,2:5}])
    y3GoE   = nanstd([SU.contactAligned.contactGoSpikeNums{i}{:,2:5}])
    y3Nogo  = nanmean([SU.contactAligned.contactNogoSpikeNums{i}{:,2:5}])
    y3NogoE = nanstd([SU.contactAligned.contactNogoSpikeNums{i}{:,2:5}])
    
    
    
    plot(x3Go,y3Go,'bo','markersize',5)
    plot(x3Nogo,y3Nogo,'ro','markersize',5)
    plot([-x3GoE x3GoE]+x3Go,[y3Go y3Go],'b-','linewidth',1)
    plot([x3Go x3Go],[-y3GoE y3GoE]+y3Go,'b-','linewidth',1)
  plot([-x3NogoE x3NogoE]+x3Nogo,[y3Nogo y3Nogo],'r-','linewidth',1)
    plot([x3Nogo x3Nogo],[-y3NogoE y3NogoE]+y3Nogo,'r-','linewidth',1)
set(gca,'Ylim',[0 4])

end

xlabel('Mean Contact Spike Triggered Theta')
ylabel('Mean Spikes / Contact')
title('All C2 cells, 2nd-5th contact')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\All_C2_ContactTrigSpikeVsThetaSummary.eps')
