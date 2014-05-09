freqSampling = 19530;
set(0, 'DefaultFigurePosition', [100 100 1200 1000]);

dspikes={};
for k1=1:length(T.cellNum)
    for k2=1:length(T.cellNum)
        dspikes{k1,k2} = [];
    end
end
for j=1:length(T.trialNums)
    for i=1:length(T.cellNum);
        tc{i}= double(T.trials{j}.shanksTrial.clustData{i}.spikeTimes)/freqSampling-.490;
    end
    for k1=1:length(T.cellNum)
        for k2=1:length(T.cellNum)
            
            
            
            
            a=repmat(tc{k1},1,length(tc{k2}));
            b=repmat(tc{k2}',length(tc{k1}),1);
            c=a-b;
            c = c(c<.04 & c>-0.040);
            dspikes{k1,k2} = cat(1,dspikes{k1,k2}, c(:));
            
        end
    end
display(j)    
end

%%
edges = [-.04:.0003:.04];

for j = 1:length(T.cellNum)
    figure(j)
    for i=1:length(T.cellNum)
        subplot(4,5,i)
        
        n=histc(dspikes{j,i},edges)
        bar(edges,n)
    set(gca,'XLim',[-.04,.04])
        title(['cell ' num2str(j) '-' num2str(i)])

    end
end
