figure(7)
clf;
hold on
plot(Vel{18},'k')
plot(repmat(double(T.trials{18}.shanksTrial.clustData{1}.spikeTimes)/19530*1000-490,1,2),2000*[1.2 1.5],'r')
plot(repmat(double(T.trials{18}.shanksTrial.clustData{2}.spikeTimes)/19530*1000-490,1,2),2000*[1.6 1.9],'g')
plot(repmat(double(T.trials{18}.shanksTrial.clustData{5}.spikeTimes)/19530*1000-490,1,2),2000*[2 2.3],'b')
plot(Acc{18}/200,'m')
axis([300 2000 -5000 5000])
xlabel('Time (ms)')
ylabel({'Velocity (deg / s)','Acceleration (deg / (200*s^2))'})

    
set(gcf,'Position',[100 100 1500 500],'PaperOrientation','portrait','PaperPosition',[0 0 15 5], 'PaperSize', [5 15])
print('-depsc', 'Q:\Silicon\Figures\MotionTraceExamples') 

figure(15);clf
subplot(1,2,1)
hold on
colors(93,:) = [1 0 0]
colors(94,:) = [0 1 0]
colors(97,:) = [0 0 1]
for i = [93 94 97]
    try
    plot(S.Vcurves{i}{1},S.Vcurves{i}{2}/S.Vcurves{i}{2}(4),'o-','Color',colors(i,:))
    end
end

    xlabel('Velocity (deg / s)')
    ylabel('Normalized Spike Rate')

subplot(1,2,2)
hold on
for i = [93 94 97]
   
    plot(S.Acurves{i}{1}([1 4 8 10 12 16 20]),S.Acurves{i}{2}([1 4 8 10 12 16 20])/S.Acurves{i}{2}(10),'o-','Color',colors(i,:))
    
end
    xlabel('Acceleration (deg / s^2)')
    ylabel('Normalized Spike Rate')
    
    set(gcf,'Position',[100 100 1500 500],'PaperOrientation','portrait','PaperPosition',[0 0 15 5], 'PaperSize', [5 15])
print('-depsc', 'Q:\Silicon\Figures\MotionTuningExamples') 