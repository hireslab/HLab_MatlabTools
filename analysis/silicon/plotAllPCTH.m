figure(1);clf

[~,ind] = sort(cellfun(@(x)-x(3),SU.recordingLocation))
for i = 1:52
    subplot(6,9,i)
    if sum(SU.PCTH.FirstCon.z{ind(i)}(57:72)>5)>0
        
        
bar(SU.PCTH.FirstCon.allHist{ind(i)},'r','edgecolor','r')
    else
 bar(SU.PCTH.FirstCon.allHist{ind(i)},'k')
        
    end
        title(num2str(SU.recordingLocation{ind(i)}(3)))

    set(gca,'xlim',[0 100],'ylim',[0 200])
end

figure(2);clf
for i = 1:52
    subplot(6,9,i)
    if sum(SU.PCTH.FirstCon.z{ind(i)}(57:72)>5)>0
        
        
bar(SU.PCTH.Con210.allHist{ind(i)},'r','edgecolor','r')
    else
 bar(SU.PCTH.Con210.allHist{ind(i)},'k')
        
    end
    title(num2str(SU.recordingLocation{ind(i)}(3)))
    set(gca,'xlim',[0 100],'ylim',[0 200])
end
%%
figure(1);clf

[~,ind] = sort(cellfun(@(x)x(3),S.recordingLocation))
for i = 1:148
    subplot(10,15,i)
    try
    if sum(S.PCTH.FirstCon.z{ind(i)}(57:72)>5)>0
        
        
bar(S.PCTH.FirstCon.allHist{ind(i)},'r','edgecolor','r')
    else
 bar(S.PCTH.FirstCon.allHist{ind(i)},'k')
        
      end
    end
        title(num2str(S.recordingLocation{ind(i)}(3)))

    set(gca,'xlim',[0 100],'ylim',[0 200])
end

figure(2);clf
for i = 1:148
    subplot(10,15,i)
    try
    if sum(S.PCTH.FirstCon.z{ind(i)}(57:72)>5)>0
        
        
bar(S.PCTH.Con210.allHist{ind(i)},'r','edgecolor','r')
    else
 bar(S.PCTH.Con210.allHist{ind(i)},'k')
        
        end
    end
    title(num2str(S.recordingLocation{ind(i)}(3)))
    set(gca,'xlim',[0 100],'ylim',[0 200])
end