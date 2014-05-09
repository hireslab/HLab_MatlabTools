% Snums = Snums_L23far
% SUnums = SUnums_L23far

SUnums = [5 7 9 4 3 6 34]
Snums = [92 47 84 46]



[~, idx] = sort(-cellfun(@(x)x(3),S.recordingLocation(Snums)));
Snums = Snums(idx)

[~, idx] = sort(-cellfun(@(x)x(3),SU.recordingLocation(SUnums)));
SUnums = SUnums(idx)

figure(1);clf;set(gcf,'papersize',[2 2], 'paperposition',[0 0 2 2]);hold on
spksPerCon = cat(1,reshape([S.PCTH.Ind.allCon.lambda{Snums,1:5}],length(Snums),5), reshape([SU.PCTH.Ind.allCon.lambda{SUnums,1:5}],length(SUnums),5));
spksAddedPerCon = spksPerCon - repmat(cat(1, (cellfun(@mean,cellfun(@(x)x(1:50),S.PCTH.Ind.allCon.Hist(Snums),'UniformOutput',0))*.05)',...
    (cellfun(@mean,cellfun(@(x)x(1:50),SU.PCTH.Ind.allCon.Hist(SUnums),'UniformOutput',0))*.05)'),1,5);

for i =SUnums

    plot(0:5,cumsum([0 SU.PCTH.Ind.allCon.lambda{i,1:5}]) - mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05 * [0:5],'.-','color',[.5 .5 .5])
    
end
for i = Snums
    if i == 92
    %plot(0:5,cumsum([0 S.PCTH.Ind.allCon.lambda{i,1:5}]) - mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05 * [0:5],'.-','color','r')
    else
    plot(0:5,cumsum([0 S.PCTH.Ind.allCon.lambda{i,1:5}]) - mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05 * [0:5],'.-','color',[.5 .5 .5])
    end
end
plot(0:5,[0 cumsum(mean(spksAddedPerCon))],'ko-','linewidth',1,'markersize',4)

for i = 92
    plot(0:5,cumsum([0 S.PCTH.Ind.allCon.lambda{i,1:5}]) - mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05 * [0:5],'.-','color','r')
    
end

%title('Layer 4 touch cell adaptation')
xlabel('Contact number')
ylabel('Cumulative spikes added / cell')


%plot([0 5],[0 0], 'k:','linewidth',2)
set(gca,'xlim', [0 5],'ylim', [-.2 4.1],'xtick',[0:5],'ytick',[0:4])
print(1, '-depsc', ['z:\users\Andrew\Whisker Project\Figures\Dan\L4sharpTouchCum'])


%%

plotsize = [1 1];

for j = 1:5
figure(2);clf;set(gcf,'papersize',[2 1], 'paperposition',[0 0 2 1]);
plotidx = 1
%     for i = SUnums
%     figure(2);
%     subplot(plotsize(1),plotsize(2),plotidx);hold on
%     if ~isempty(SU.PCTH.Ind.allCon.Hist{i,j});
%     bar(-50:50,SU.PCTH.Ind.allCon.Hist{i,j});
%     set(gca,'xlim',[-50 50],'xtick',[])
%     title(['CA#' num2str(i) ' ' num2str(-1000*SU.recordingLocation{i}(3))]);
%     
%     set(gca,'ylim',[0 max(SU.PCTH.Ind.allCon.Hist{i,1})]);
%     end
%         plot([0 0],get(gca,'ylim'),'r:')
%     plot(get(gca,'xlim'),repmat(mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50)),1,2),'r:')
% 
%     plotidx = plotidx + 1;
%     end
%     
     for i = 92
    figure(2);
    subplot(plotsize(1),plotsize(2),plotidx);hold on
    if ~isempty(S.PCTH.Ind.allCon.Hist{i,j});
    bar(-50:50,S.PCTH.Ind.allCon.Hist{i,j},'k','edgecolor','k');
    set(gca,'xlim',[-20 40],'xtick',[-20 0 20 40])
  %  title(['Si#' num2str(i) ' ' num2str(-1000*S.recordingLocation{i}(3))]);
    try
    set(gca,'ylim',[0 max(S.PCTH.Ind.allCon.Hist{i,1})]);
    end
  %  plot([0 0],get(gca,'ylim'),'r:')
   % plot(get(gca,'xlim'),repmat(mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50)),1,2),'r:')

    end
    end
    subplot(plotsize(1),plotsize(2),1);
    %text(0, .8, ['Contact #' num2str(j) ])
    %text(0, .6, 'far C2, L23  touch cells')
    %set(gca,'visible','off')
    print(2, '-depsc', ['z:\users\Andrew\Whisker Project\Figures\Dan\AdaptationCellExampleCon' num2str(j)])
end