% Snums_L4  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > .418 & cellfun(@(x)x(3),S.recordingLocation) < .588))
% SUnums_L4  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588))
%
% SUnums_L23 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ))
% SUnums_L56 = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.588))

figure(1);cla;set(gcf,'paperPosition',[0 0 4 24],'papersize',[4 24]);
timePeriod = 41:75
Snums_all = [1:148]'
SUnums_all = [1:36 38:53]';

cellID = -[cellfun(@(x)-x(3),SU.recordingLocation(SUnums_all)); cellfun(@(x)x(3),S.recordingLocation(Snums_all))'];
cellID(:,2) = [SUnums_all; Snums_all];
cellID(:,3) = [ones(length(SUnums_all),1); zeros(length(Snums_all),1)];
cellID = sortrows(cellID);
% [~, SUdepthOrder] = sort(cellfun(@(x)-x(3),SU.recordingLocation(SUnums_all)))
% [~, SdepthOrder] = sort(cellfun(@(x)x(3),S.recordingLocation(Snums_all)))
% 
% Snums_all = Snums_all(SdepthOrder);
% SUnums_all = SUnums_all(SUdepthOrder);

for i = 1:length(cellID(:,1))
    
    if cellID(i,3)
    y = SU.PCTH.allHist{cellID(i),2}(timePeriod);
    else
        y = S.PCTH.allHist{cellID(i),2}(timePeriod);
    end
    text(timePeriod,i,'*')
        if S.recordingLocation{Snums_all(i)}(3) > -.418
        facecolor = 'k'
    elseif S.recordingLocation{Snums_all(i)}(3) < -.418 & S.recordingLocation{Snums_all(i)}(3) > -.588
        facecolor = 'r'
    else
        facecolor = 'g'
        end
    for j = 1:length(timePeriod)-1
        patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
            [y(j)+1 y(j)+1 0 0]/166 + i,facecolor,'edgecolor','none')
    end
    
end

% for i = 1:length(SUnums_all)
%     
%     y = SU.PCTH.allHist{SUnums_all(i)}(timePeriod);
%     
%     if SU.recordingLocation{SUnums_all(i)}(3) > -.418
%         facecolor = 'k'
%     elseif SU.recordingLocation{SUnums_all(i)}(3) < -.418 & SU.recordingLocation{SUnums_all(i)}(3) > -.588
%         facecolor = 'r'
%     else
%         facecolor = 'g'
%         
%     end
%     for j = 1:length(timePeriod)-1
%         patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
%             [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_all),facecolor,'edgecolor','none')
%     end
%     
% end
% hold on
 plot([0 0],[1 length(cellID(:,1))],'k')
xlabel('Time from contact (ms)')
ylabel('Mean spikes / contact / 6 ms')
title('Layer 4 near C2  mean of prelick contacts 1-5 both directions')
text(-8,44,'Cell Attached','color','k')
text(-8,43,'Si Probe','color', 'r')
print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\StackedAllPCTH.eps')
% 
% %%
% figure(2);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
% timePeriod = 41:75
% Snums_L4touch = intersect(S.PCTH.sharpTouchCells,Snums_L4)
% for i = 1:length(Snums_L4touch)
%     
%     y = S.PCTH.allHist{Snums_L4touch(i)}(timePeriod);
%     
%     for j = 1:length(timePeriod)-1
%         patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
%             [y(j)+1 y(j)+1 0 0]/166 + i,'r','edgecolor','none')
%     end
%     
% end
% 
% SUnums_L4touch = intersect(SU.PCTH.sharpTouchCells,SUnums_L4)
% 
% for i = 1:length(SUnums_L4touch)
%     
%     y = SU.PCTH.allHist{SUnums_L4touch(i)}(timePeriod);
%     
%     for j = 1:length(timePeriod)-1
%         patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
%             [y(j)+1 y(j)+1 0 0]/166 + i+length(Snums_L4touch),'k','edgecolor','none')
%     end
%     
% end
% hold on
% plot([0 0],[1 length([SUnums_L4touch Snums_L4touch])+1],'k')
% xlabel('Time from contact (ms)')
% ylabel('Mean spikes / contact / 6 ms')
% title('Layer 4 touch near C2 mean of prelick contacts 1-5 both directions')
% text(-9,13,'Cell Attached','color','k')
% text(-9,12,'Si Probe','color', 'r')
% print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\GroupL4touchPCTHforDan.eps')
% 
% figure(3);cla;set(gcf,'paperPosition',[0 0 4 4],'papersize',[4 4]);
% y = mean([S.PCTH.allHist{Snums_L4touch} SU.PCTH.allHist{SUnums_L4touch}],2)
% y = y(timePeriod)
% for j = 1:length(timePeriod)-1
%     patch([timePeriod(j) timePeriod(j)+1 timePeriod(j)+1 timePeriod(j)]-50.5,...
%         [y(j)+1 y(j)+1 0 0] ,'k','edgecolor','none')
% end
% xlabel('Time from contact (ms)')
% ylabel('Mean spikes / contact / s')
% title('Layer 4 touch cells near C2 grand mean')
% print(gcf, '-depsc', 'Z:\users\Andrew\Whisker Project\Figures\MeanL4touchPCTHforDan.eps')
