Snums = Snums_L23far
SUnums = SUnums_L23far
Snums_L4near = [ 92 84];
SUnums_L4near = [5 7 9 4 3 6 34];

SUnums = Snums_L4near;[24 12 25]
Snums = SUnums_L4near;[55 144 53 52 59 107 43]



[~, idx] = sort(-cellfun(@(x)x(3),S.recordingLocation(Snums)));
Snums = Snums(idx)

[~, idx] = sort(-cellfun(@(x)x(3),SU.recordingLocation(SUnums)));
SUnums = SUnums(idx)

figure(1);clf;set(gcf,'papersize',[5 5], 'paperposition',[0 0 5 5]);hold on

for i =SUnums

    plot([SU.PCTH.Ind.allCon.lambda{i,:}] - mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05,'o-','color',[.8 .5 .8])
    
end
for i = Snums
    plot([S.PCTH.Ind.allCon.lambda{i,:}]- mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50))*.05,'o-','color',[.8 .8 .5])

end
text(3,1.4,'Cell Attached','color',[.8 .5 .8])
text(3,1.3,'Si Probe','color',[.8 .8 .5])
title('Far C2, L23 touch cell adaptation')
xlabel('Contact number')
ylabel('Spikes added per contact')

spksPerCon = cat(1,reshape([S.PCTH.Ind.allCon.lambda{Snums,1:5}],length(Snums),5), reshape([SU.PCTH.Ind.allCon.lambda{SUnums,1:5}],length(SUnums),5));
spksAddedPerCon = spksPerCon - repmat(cat(1, (cellfun(@mean,cellfun(@(x)x(1:50),S.PCTH.Ind.allCon.Hist(Snums),'UniformOutput',0))*.05)',...
    (cellfun(@mean,cellfun(@(x)x(1:50),SU.PCTH.Ind.allCon.Hist(SUnums),'UniformOutput',0))*.05)'),1,5);

plot(mean(spksAddedPerCon),'ko-','linewidth',2,'markersize',6)
plot([0 5],[0 0], 'k:','linewidth',2)
set(gca,'xlim', [0 5])
print(1, '-depsc', ['z:\users\Andrew\Whisker Project\Figures\PCTH\L4nearPCTHSTouchAdaptation-'])


%%

plotsize = [4 3];

for j = 1:6
figure(2);clf;set(gcf,'papersize',[8.5 11], 'paperposition',[0 0 8.5 11]);
plotidx = 2
    for i = SUnums
    figure(2);
    subplot(plotsize(1),plotsize(2),plotidx);hold on
    if ~isempty(SU.PCTH.Ind.allCon.Hist{i,j});
    bar(-50:50,SU.PCTH.Ind.allCon.Hist{i,j});
    set(gca,'xlim',[-50 50],'xtick',[])
    title(['CA#' num2str(i) ' ' num2str(-1000*SU.recordingLocation{i}(3))]);
    
    set(gca,'ylim',[0 max(SU.PCTH.Ind.allCon.Hist{i,1})]);
    end
        plot([0 0],get(gca,'ylim'),'r:')
    plot(get(gca,'xlim'),repmat(mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50)),1,2),'r:')

    plotidx = plotidx + 1;
    end
    
     for i = Snums
    figure(2);
    subplot(plotsize(1),plotsize(2),plotidx);hold on
    if ~isempty(S.PCTH.Ind.allCon.Hist{i,j});
    bar(-50:50,S.PCTH.Ind.allCon.Hist{i,j});
    set(gca,'xlim',[-50 50],'xtick',[])
    title(['Si#' num2str(i) ' ' num2str(-1000*S.recordingLocation{i}(3))]);
    try
    set(gca,'ylim',[0 max(S.PCTH.Ind.allCon.Hist{i,1})]);
    end
    plot([0 0],get(gca,'ylim'),'r:')
    plot(get(gca,'xlim'),repmat(mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50)),1,2),'r:')

    end
    plotidx = plotidx + 1;
    end
    subplot(plotsize(1),plotsize(2),1);
    text(0, .8, ['Contact #' num2str(j) ])
    text(0, .6, 'far C2, L23  touch cells')
    set(gca,'visible','off')
    print(2, '-depsc', ['z:\users\Andrew\Whisker Project\Figures\PCTH\L23farPCTHTouch-' num2str(j)])
end