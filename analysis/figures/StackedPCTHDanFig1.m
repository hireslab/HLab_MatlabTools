Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))


figure(1);cla;set(gcf,'paperPosition',[0 0 4 8],'papersize',[4 8]);
timePeriod = 41:75
for i = 1:length(Snums_L4)
   
    y = S.PCTH.allHist{Snums_L4(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i,'r','edgecolor','none')
    end
    
end

for i = 1:length(SUnums_L4)
   
    y = SU.PCTH.allHist{SUnums_L4(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_L4),'k','edgecolor','none')
    end
    
end
hold on
plot([0 0],[1 length([SUnums_L4 Snums_L4])+1],'k')
xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / 6 ms')
title('Layer 4 near C2  mean of prelick contacts 1-5 both directions')
text(-8,44,'Cell Attached','color','k')
 text(-8,43,'Si Probe','color', 'r')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\GroupL4PCTHforDan.eps')

 figure(2);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
timePeriod = 41:75
Snums_L4touch = intersect(S.PCTH.sharpTouchCells,Snums_L4)
for i = 1:length(Snums_L4touch)
   
    y = S.PCTH.allHist{Snums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i,'r','edgecolor','none')
    end
    
end

SUnums_L4touch = intersect(SU.PCTH.sharpTouchCells,SUnums_L4)

for i = 1:length(SUnums_L4touch)
   
    y = SU.PCTH.allHist{SUnums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_L4touch),'k','edgecolor','none')
    end
    
end
hold on
plot([0 0],[1 length([SUnums_L4touch Snums_L4touch])+1],'k')
xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / 6 ms')
title('Layer 4 touch near C2 mean of prelick contacts 1-5 both directions')
text(-9,13,'Cell Attached','color','k')
 text(-9,12,'Si Probe','color', 'r')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\GroupL4touchPCTHforDan.eps')
%%
 figure(4);clf;set(gcf,'paperPosition',[0 0 2 2],'papersize',[2 2]);
 y = mean([S.PCTH.allHist{Snums_L4touch} SU.PCTH.allHist{SUnums_L4touch}],2)
 y = y(timePeriod)
    for j = 1:length(timePeriod)-1
    patch(([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5)/1000,...
        [y(j)+1 y(j)+1 0 0] ,'k','edgecolor','k')
    end
    set(gca,'xlim',[-.010 .025])
    
    xlabel('Time from first touch (s)')
ylabel('Mean spikes / contact / s')
%title('Layer 4 touch cells near C2 grand mean')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\MeanL4touchPCTHforDan.eps')
