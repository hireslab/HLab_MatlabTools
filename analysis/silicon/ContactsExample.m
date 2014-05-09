figure (1); clf

for i = 1:300
    for j = 1:5
        if isempty(contacts{i}.answerLickTime)
            
            if numel(contacts{i}.segmentInds{1})>=2*j && contacts{i}.segmentInds{1}(j,1) < 1750;
                subplot(5,5,5*(contacts{i}.barPosType-1)+j)
                hold on
                axis([0 35 1e-7*([-5 5])]);
                set(gca,'XTick',[],'YTick',[])
    
                plot(contacts{i}.M0comboAdj{1}(contacts{i}.segmentInds{1}(j,1):contacts{i}.segmentInds{1}(j,2)),'Color',[.5 .5 .5]);
            end
        else
            if numel(contacts{i}.segmentInds{1})>=2*j...
                    && T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)) < contacts{i}.answerLickTime;
                subplot(5,5,5*(contacts{i}.barPosType-1)+j)
                axis([0 35 1e-7*([-5 5])]);
                set(gca,'XTick',[],'YTick',[])

                hold on
                plot(contacts{i}.M0comboAdj{1}(contacts{i}.segmentInds{1}(j,1):contacts{i}.segmentInds{1}(j,2)),'Color',[.5 .5 .5]);
            end
        end
    end
end


set(gcf,'Position',[100 100 800 800],'PaperOrientation','portrait','PaperPosition',[0 0 10 10], 'PaperSize', [10 10])
print('-depsc', '\Lab\Silicon\Figures\ContactsExample')
%%
lnum=zeros(5);

figure (2);clf
clust = 17
st = {};
for i = 1:300
    if ~isempty(T.trials{i}.shanksTrial.clustData{clust}.spikeTimes)
        st{i} = double(T.trials{i}.shanksTrial.clustData{clust}.spikeTimes)/19530-.490;
        for j = 1:5
            if isempty(contacts{i}.answerLickTime)
                
                if numel(contacts{i}.segmentInds{1})>=2*j && contacts{i}.segmentInds{1}(j,1) < 1750;
                    
                    subplot(5,5,5*(contacts{i}.barPosType-1)+j)
                    hold on
                    axis([0 .05 0 30]);
                    
                    plot(repmat(st{i}-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)),1,2),...
                        [lnum(contacts{i}.barPosType,j) lnum(contacts{i}.barPosType,j)+1],'k' )
                    lnum(contacts{i}.barPosType,j)=lnum(contacts{i}.barPosType,j)+1
                end
            else
                if numel(contacts{i}.segmentInds{1})>=2*j...
                        && T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)) < contacts{i}.answerLickTime;
                    subplot(5,5,5*(contacts{i}.barPosType-1)+j)
                    
                    hold on
                    plot(repmat(st{i}-T.trials{i}.whiskerTrial.time{1}(contacts{i}.segmentInds{1}(j,1)),1,2),...
                        [lnum(contacts{i}.barPosType,j) lnum(contacts{i}.barPosType,j)+1],'k' )
                      lnum(contacts{i}.barPosType,j)=lnum(contacts{i}.barPosType,j)+1
                                        axis([0 .05 0 30]);

                end
            end
        end
    end
end

set(gcf,'Position',[100 100 800 800],'PaperOrientation','portrait','PaperPosition',[0 0 10 10], 'PaperSize', [10 10])
print('-depsc', '\Lab\Silicon\Figures\ContactsSpikesExample')