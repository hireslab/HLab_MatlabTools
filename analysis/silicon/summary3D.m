figSaveDir = '/Volumes/MONOLITH/Silicon/Figures/'


valueType = {'ProtractionMoment','RetractionMoment', 'ProtractionVelocity', 'RetractionVelocity', 'ProtractionAcceleration',...
    'RetractionAcceleration', 'AnteriorPosition', 'PosteriorPosition'}

for i = 1:148
    recordingLocation(i,1) = S.recordingLocation{i}(1)+(rand-.5)/20;
        recordingLocation(i,2) = S.recordingLocation{i}(2)+(rand-.5)/20;
    recordingLocation(i,3) = S.recordingLocation{i}(3);
end
   
for j=1:8
    figure(j);clf;
    set(gcf,'Position',[25 25 1500 500],'PaperOrientation','portrait','PaperPosition',[0 0 15 5], 'PaperSize', [15 5])
    
    subplot(1,3,1)
    hold on
    grid on
    t = 0:.1:2*pi
    plot(.13*sin(t),.13*cos(t),'r')
    for i=1:148
        plot(recordingLocation(value(i,10),1),recordingLocation(value(i,10),2),'.',...
            'Color', map(round(value(i,j)*10)+51,:), 'MarkerSize',10)
    end
    axis equal
    xlabel('Distance from C2 center (mm)')
    
    ylabel('Distance from C2 center (mm)')
    title (['X vs. Y : ' valueType(j)])
    
    subplot(1,3,2)
    hold on
    grid on
    for i=1:148
        
        
        plot(recordingLocation(value(i,10),1),-recordingLocation(value(i,10),3),'.',...
            'Color', map(round(value(i,j)*10)+51,:), 'MarkerSize',15)
        
    end
    plot([-.13 -.13],[-.8 -.2],'r')
    plot([.13 .13],[-.8 -.2],'r')
    ylabel('Depth from pia (mm)')
        title (['Y vs. Z : ' valueType(j)])
axis tight
    xlabel('Distance from C2 center (mm)')
    title (['X vs. Z : ' valueType(j)])
    
        set(gca,'YLim',[-.8 0])

    subplot(1,3,3)
    hold on
    axis equal
    grid on
    for i=1:148
        plot(recordingLocation(value(i,10),2),-recordingLocation(value(i,10),3),'.',...
            'Color', map(round(value(i,j)*10)+51,:), 'MarkerSize',15)
        
        
        
        %plot3(S.recordingLocation{value(i,10)}(1),S.recordingLocation{value(i,10)}(2),-S.recordingLocation{value(i,10)}(3),'.',...
        %    'Color', map(round(value(i,j)*10)+51,:), 'MarkerSize',15)
    end
    plot([-.13 -.13],[-.8 -.2],'r')
    plot([.13 .13],[-.8 -.2],'r')
    title (['Y vs. Z : ' valueType(j)])
    set(gca,'YLim',[-.8 0])
    ylabel('Depth from pia (mm)')
    
    xlabel('Distance from C2 center (mm)')
    
%print(gcf, '-depsc', [figSaveDir 'Location-' valueType{j}])

end
%%
figSaveDir = '/Volumes/MONOLITH/Silicon/Figures/'

cmap=hsv(80)
cmap(1,:)=[1 1 1];

for i = 1:148
    recordingLocation(i,1) = S.recordingLocation{i}(1)+(rand-.5)/20;
        recordingLocation(i,2) = S.recordingLocation{i}(2)+(rand-.5)/20;
    recordingLocation(i,3) = S.recordingLocation{i}(3);
end
   
for k=1:4
figure(10);clf;hold on
    t = 0:.1:2*pi
    plot(.13*sin(t),.13*cos(t),'r')
    subplot(1,3,1);cla;hold on;grid on; axis equal
    
for i=1:148

        plot(recordingLocation(value(i,10),1),recordingLocation(value(i,10),2),'.',...
            'Color', cmap(round(S.latency{i}(1)*1000)+1,:), 'MarkerSize',10)
     
    
end

    subplot(1,3,2);cla;hold on;grid on;
    
for i=1:148

        plot(recordingLocation(value(i,10),1),-recordingLocation(value(i,10),3),'.',...
            'Color', cmap(round(S.latency{i}(1)*1000)+1,:), 'MarkerSize',10)
     
    
end

    subplot(1,3,3);cla;hold on;grid on; 
for i=1:148

        plot(recordingLocation(value(i,10),2),-recordingLocation(value(i,10),3),'.',...
            'Color', cmap(round(S.latency{i}(1)*1000)+1,:), 'MarkerSize',10)
     
    
end



colorbar
end
print(gcf, '-depsc', [figSaveDir 'Latency'])
