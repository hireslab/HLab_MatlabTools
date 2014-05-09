%% Adaptation vs. Depth
cind = depth > 100%depth < 600 & depth > 400

x = depth(cind)
figure(201); clf
touchLabel = {'First contact', 'Second Contact','Third Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}

dColor=jet(70)

for k=1; % Contact Type
    y=[];


    y(:,1) = cellfun(@(x)x(2,1),S.adaptationSR);

    sorty = sortrows([x' y])



    for i = 1
        subplot(1,1,i+2*(k-1))
        hold on
                plot([100 700],[1 1],'r-')

%        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)
for cNum = 1:length(S.baselineSR);
    
        plot(S.depth{cNum},S.adaptationSR{cNum}(2,1),'ko','MarkerSize',6,'MarkerFaceColor',dColor(uint8(10*log2(nanmean(S.baselineSR{cNum})))+1,:))
end
        grid on
        title(['Adaptation between 1st and 2nd GoPro Contact'])
        xlim([100 700])
        ylim([0 3])
    end
end
subplot(1,1,1)
ylabel({'Adaptation ratio','2nd touch / 1st touch Spike rate)'})
subplot(1,1,1)
xlabel('Depth (um)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 7 6], 'PaperSize', [7 6])
colormap(dColor(1:64,:));
colorbar('YTick',[1 11 21 31 41 51 61],'YTickLabel',{'1','2','4','8','16','32','64'})

print(gcf, '-depsc', ['Q:\Silicon\Figures\AdaptationVsDepth'])