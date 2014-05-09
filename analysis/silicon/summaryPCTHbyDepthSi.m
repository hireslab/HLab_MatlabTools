Snums_L23near  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) > -.418 ));
Snums_L23far  = intersect(find([S.dist{:}] > .250), find(cellfun(@(x)x(3),S.recordingLocation) > -.418));
Snums_L4near  = intersect(find([S.dist{:}] < .250), find(cellfun(@(x)x(3),S.recordingLocation) < -.418 & cellfun(@(x)x(3),S.recordingLocation) > -.588));
Snums_L4far  = intersect(find([S.dist{:}] > .250), find(cellfun(@(x)x(3),S.recordingLocation) < -.418 & cellfun(@(x)x(3),S.recordingLocation) > -.588));
Snums_L5near  = intersect(find([S.dist{:}] < .250),  find(cellfun(@(x)x(3),S.recordingLocation) < -.588));
Snums_L5far  = intersect(find([S.dist{:}] > .250),  find(cellfun(@(x)x(3),S.recordingLocation) < -.588));

[~, Snums_allByDepth] = sort(-cellfun(@(x)x(3),S.recordingLocation(1:148)));
[~, idx] = sort(-cellfun(@(x)x(3),S.recordingLocation(Snums_L4near)));
Snums_L4nearByDepth = Snums_L4near(idx)

%[Snums_allByDepthNear = sort(-cellfun(@(x)x(3),S.recordingLocation([Snums_L23near Snums_L4near Snums_L5near])));
figure(1);clf;set(gcf,'papersize',[8.5 11], 'paperposition',[0 0 8.5 11]);
figure(2);clf;set(gcf,'papersize',[ 8.5 11], 'paperposition',[0 0 8.5 11]);
figure(3);clf;set(gcf,'papersize',[ 8.5 11], 'paperposition',[0 0 8.5 11]);

plotidx = 2
contactNumber = 1
for i = Snums_L4nearByDepth
    figure(1)
    subplot(8,4,plotidx);hold on
    ci = [S.PCTH.Ind.allCon.lambda95{i,:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
    plot([0 10], repmat(S.PCTH.Ind.allCon.baseline.lambda{i,1},1,2),'k--')
    h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    plot([S.PCTH.Ind.allCon.lambda{i,:}],'ko-');
    
    axis
    set(gca,'xlim',[1 6],'xtick',[]);
    title(['#' num2str(i) ' ' num2str(-1000*S.recordingLocation{i}(3))]);
    % figure(2);clf
    % plot(spikesAdded{S.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
        plotidx = plotidx + 1

end

print(1, '-dtiff', '-r600', 'z:\users\Andrew\Whisker Project\Silicon\Figures\L4nearAdaptationbyDepth')
for j = 1:6
    figure(2);clf;
    plotidx = 2
    for i = Snums_L4nearByDepth
    figure(2);
    subplot(8,4,plotidx);hold on
    if ~isempty(S.PCTH.Ind.allCon.Hist{i,j});
    bar(-50:50,S.PCTH.Ind.allCon.Hist{i,j});
    set(gca,'xlim',[-50 50],'xtick',[])
    title(['#' num2str(i) ' ' num2str(-1000*S.recordingLocation{i}(3))]);
    set(gca,'ylim',[0 max(S.PCTH.Ind.allCon.Hist{i,1})]);
    end
    plotidx = plotidx + 1;
    end
    print(2, '-depsc', ['z:\users\Andrew\Whisker Project\Silicon\Figures\L4nearPCTHbyDepthSi-' num2str(j)])
end

    


