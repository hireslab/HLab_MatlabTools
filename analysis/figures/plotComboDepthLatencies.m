%% plot latencies
printdir = 'Z:\users\Andrew\Whisker Project\Figures\'

figure(2);cla;hold on
for i =1:length(recordingLocation(:,3))-9
    dshift = (rand-.5)/25;
    plot(abs(recordingLocation(i,3))+dshift,latency(i),'bo')
  
    
     if distance(i) < .15
        plot(abs(recordingLocation(i,3))+dshift,latency(i),'k.','MarkerSize',8)
    end
end

for i =length(recordingLocation(:,3))-9:length(recordingLocation(:,3))
    dshift = (rand-.5)/25;
    plot(abs(recordingLocation(i,3))+dshift,latency(i),'ro')
  
    if distance(i) < .15
        plot(abs(recordingLocation(i,3))+dshift,latency(i),'k.','MarkerSize',8)
    end
    
    
end

%%


text(.02,33,'SiProbe', 'color','b')
text(.02,31,'Cell Attached', 'color','r')
text(.02,29,'Distance < 150um ', 'color','k')

xlabel('Depth from pia (mm)')
ylabel('Modal Latency (ms)')
set(gca,'Xlim', [0 1])
print(gcf, '-depsc', [printdir 'ComboLatenciesVDepth'])% T.mouseName '_' T.sessionName])

