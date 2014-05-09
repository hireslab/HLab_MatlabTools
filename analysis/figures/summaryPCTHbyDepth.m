SUnums_L23near  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418 ));
SUnums_L23far  = intersect(find([SU.distance{:}] > .250), find(cellfun(@(x)x(3),SU.recordingLocation) > -.418));
SUnums_L4near  = intersect(find([SU.distance{:}] < .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588));
SUnums_L4far  = intersect(find([SU.distance{:}] > .250), find(cellfun(@(x)x(3),SU.recordingLocation) < -.418 & cellfun(@(x)x(3),SU.recordingLocation) > -.588));
SUnums_L5near  = intersect(find([SU.distance{:}] < .250),  find(cellfun(@(x)x(3),SU.recordingLocation) < -.588));
SUnums_L5far  = intersect(find([SU.distance{:}] > .250),  find(cellfun(@(x)x(3),SU.recordingLocation) < -.588));

[~, SUnums_allByDepth] = sort(-cellfun(@(x)x(3),SU.recordingLocation));
[~, idx] = sort(-cellfun(@(x)x(3),SU.recordingLocation(SUnums_L4near)));
SUnums_L4nearByDepth = SUnums_L4near(idx)
%[SUnums_allByDepthNear = sort(-cellfun(@(x)x(3),SU.recordingLocation([SUnums_L23near SUnums_L4near SUnums_L5near])));
figure(1);clf;set(gcf,'papersize',[8.5 11], 'paperposition',[0 0 8.5 11]);
figure(2);clf;set(gcf,'papersize',[ 8.5 11], 'paperposition',[0 0 8.5 11]);
figure(3);clf;set(gcf,'papersize',[ 8.5 11], 'paperposition',[0 0 8.5 11]);

plotidx = 2
contactNumber = 1
for i = SUnums_L4nearByDepth
    figure(1)
    subplot(4,3,plotidx);hold on
    ci = [SU.PCTH.Ind.allCon.lambda95{i,:}];
    ci(isnan(ci))= mean(ci(~isnan(ci)))
    patch([1:length(ci(1,:)) length(ci(1,:)):-1:1], [ci(1,:) fliplr(ci(2,:))],'k','edgecolor','none')
    plot([0 10], repmat(mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50)*.05),1,2),'k--')
    h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    plot([SU.PCTH.Ind.allCon.lambda{i,:}],'ko-');   
    try
    for j=1:6
        
    spky(j) = mean(SU.PCTH.Ind.allCon.Hist{i,j}(56:101))*.045
       end
    plot(spky,'ro-');
     end
    
plotidx = plotidx+1
    set(gca,'xlim',[1 6],'xtick',[]);
    title(['#' num2str(i) ' ' num2str(-1000*SU.recordingLocation{i}(3))]);
    % figure(2);clf
    % plot(spikesAdded{SU.PCTH.sharpTouchCells(i)},'-ob','markersize',3);
end


for j = 1:6
    figure(2);clf;
    plotidx = 2
    for i = SUnums_L4nearByDepth
    figure(2);
    subplot(4,3,plotidx);hold on
    if ~isempty(SU.PCTH.Ind.allCon.Hist{i,j});
    bar(-50:50,SU.PCTH.Ind.allCon.Hist{i,j});
    set(gca,'xlim',[-50 50],'xtick',[])
    title(['#' num2str(i) ' ' num2str(-1000*SU.recordingLocation{i}(3))]);
    set(gca,'ylim',[0 max(SU.PCTH.Ind.allCon.Hist{i,1})]);
    end
    plotidx = plotidx + 1;
    end
    print(2, '-depsc', ['z:\users\Andrew\Whisker Project\SingleUnit\Figures\L4nearPCTHbyDepthSU-' num2str(j)])
end
figure(4);clf
plotidx = 2
for i = SUnums_L4nearByDepth;
                subplot(4,3,plotidx);hold on

    for j = 1:6

        try
            spkCounts = round(SU.PCTH.Ind.allCon.Hist{i,j}(51:101)*SU.PCTH.Ind.allCon.numT{i,1}/1000);
            
            spkTimes = [];
            timeNum = 0:length(spkCounts)-1;
            for k = 1:length(spkCounts)
                spkTimes = cat(2,spkTimes, repmat(timeNum(k),1,spkCounts(k)));
            end
            spkPrecision{i,j} = std(spkTimes)    ;
        end
    end
    plot([spkPrecision{i,:}],'-ko')
        plotidx = plotidx + 1;

end


% print(3, '-depsc', 'z:\users\Andrew\Whisker Project\SingleUnit\Figures\L4nearPCTH5byDepthSU')
% print(2, '-depsc', 'z:\users\Andrew\Whisker Project\SingleUnit\Figures\L4nearPCTH1byDepthSU')
print(1, '-depsc', 'z:\users\Andrew\Whisker Project\SingleUnit\Figures\L4nearAdaptationbyDepthSU')

%%
