Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588))
SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))

latencyL4touchS =    [ 9.5000   13.5 15.5 10.5 9.5 10.5 12.5 11.5]
latencyL4touchSU =    [ 10.5000   12.5000    9.5000   14.5000]

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

 figure(2);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
timePeriod = 41:75
Snums_L4touch = intersect(S.PCTH.sharpTouchCells,Snums_L4)
Snums_L4touch = Snums_L4touch(cellfun(@(x)max(x(50:65)),S.PCTH.z(Snums_L4touch))>10)
for i = 1:length(Snums_L4touch)
   
    y = S.PCTH.allHist{Snums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i,'r','edgecolor','none')
    end
    
end

SUnums_L4touch = intersect(SU.PCTH.sharpTouchCells,SUnums_L4)
SUnums_L4touch = SUnums_L4touch(cellfun(@(x)max(x(50:65)),SU.PCTH.z(SUnums_L4touch))>10)

for i = 1:length(SUnums_L4touch)
   
    y = SU.PCTH.allHist{SUnums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_L4touch),'k','edgecolor','none')
    end
    
end
hold on
set(gca, 'Xlim', [-10 25])
plot([0 0],[1 length([SUnums_L4touch Snums_L4touch])+1],'k')
xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / 6 ms')
title('L4 touch C2 con1-5 pro/ret zscore >10')
text(-9,13,'Cell Attached','color','k')
 text(-9,12,'Si Probe','color', 'r')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\GroupL4touchZ101-5ConProRetPCTHforDan.eps')

 figure(3);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
 y = mean([S.PCTH.allHist{Snums_L4touch} SU.PCTH.allHist{SUnums_L4touch}],2)
 y = y(timePeriod)
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0] ,'k','edgecolor','none')
    end
    xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / s')
title('Mean L4 touch C2 con1-5 pro/ret zscore >10')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\MeanL4touchZ101-5ConProRetPCTHforDan.eps')

%%
 figure(2);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);

Snums_L4touch = intersect(S.PCTH.sharpTouchCells,Snums_L4)
Snums_L4touch = Snums_L4touch(latencyL4touchS<12)
for i = 1:length(Snums_L4touch)
   
    y = S.PCTH.allHist{Snums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i,'r','edgecolor','none')
    end
    
end

SUnums_L4touch = intersect(SU.PCTH.sharpTouchCells,SUnums_L4)
SUnums_L4touch = SUnums_L4touch(latencyL4touchSU<12)
for i = 1:length(SUnums_L4touch)
   
    y = SU.PCTH.allHist{SUnums_L4touch(i)}(timePeriod);
    
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_L4touch),'k','edgecolor','none')
    end
    
end
set(gca, 'Xlim', [-10 25])

hold on
plot([0 0],[1 length([SUnums_L4touch Snums_L4touch])+1],'k')
xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / 6 ms')
title('L4 touch C2 con1-5 pro/ret latency <12ms')
text(-9,13,'Cell Attached','color','k')
 text(-9,12,'Si Probe','color', 'r')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\GroupL4touchL121-5ConProRetPCTHforDan.eps')

 figure(3);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
 y = mean([S.PCTH.allHist{Snums_L4touch} SU.PCTH.allHist{SUnums_L4touch}],2)
 y = y(timePeriod)
    for j = 1:length(timePeriod)-1
    patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
        [y(j)+1 y(j)+1 0 0] ,'k','edgecolor','none')
    end
    xlabel('Time from contact (ms)')
title('mean L4 touch C2 con1-5 pro/ret latency <12ms')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\MeanL4touchL121-5ConProRetPCTHforDan.eps')

