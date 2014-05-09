figure(1);clf
subplot(2,2,1);cla;hold on
for i = 1:length(SU.nonWhiskSR)
    
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'r.')
            
            
        
        
    
end

for i = 1:length(S.nonWhiskSR)
    try
        if intersect(S.PCTH.sharpTouchCells,i)
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'r.')
            
        else
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'k.')
        end
        
    end
    
end
xlabel('Non Whisking Spike Rate')
ylabel('Whisking Spike Rate')

plot([0 100],[0 100],'k')
subplot(2,2,2);cla;hold on
for i = 1:length(SU.nonWhiskSR)
    try
        if intersect(SU.PCTH.sharpTouchCells,i)
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'r.')
            
        else
            
            plot(SU.nonWhiskSR{i},SU.whiskSR{i},'k.')
        end
    end
    
end
for i = 1:length(S.nonWhiskSR)
    try
        if intersect(S.PCTH.sharpTouchCells,i)
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'r.')
            
        else
            
            plot(S.nonWhiskSR{i},S.whiskSR{i},'k.')
        end
        
    end
    
end
xlabel('Non Whisking Spike Rate')
ylabel('Whisking Spike Rate')
plot([0 5],[0 5],'k')
axis([0 5 0 5])

subplot(2,2,3);cla;hold on
for i = 1:53
    try
                if intersect(SU.PCTH.sharpTouchCells,i)
                        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
for i = 1:length(S.nonWhiskSR)
    try
                if intersect(S.PCTH.sharpTouchCells,i)
                        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
axis([0 100 0 500])
ylabel('Peak Touch Rate')
xlabel('Whisking Spike Rate')
subplot(2,2,4);cla;hold on
for i = 1:53
    try
                if intersect(SU.PCTH.sharpTouchCells,i)
                        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(SU.whiskSR{i},max(SU.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
for i = 1:length(S.nonWhiskSR)
    try
                if intersect(S.PCTH.sharpTouchCells,i)
                        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'r.')

                else
        plot(S.whiskSR{i},max(S.PCTH.allHist{i}(50:end)),'k.')
                end
                end
end
ylabel('Peak Touch Rate')
xlabel('Whisking Spike Rate')
axis([0 10 0 200])