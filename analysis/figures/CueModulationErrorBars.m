%%
poleOutPostEnhancedCells = [8 9 17 19 26 32]
poleInPostEnhancedCells = [17 19]
postPerfCells = [4 8 9 17 19 21 22 26 28 32 46];
figure(1);clf;clf;set(gcf,'Position',[25 25 800 800],'PaperPosition',[0 0 8 8],'PaperSize',[8 8])

subplot(2,2,1);hold on

plot([S.cueResponse.poleInBR{:}],[S.cueResponse.poleInCRpeak{:}],'r.');

plot([SU.cueResponse.poleInBR{:,1}],[SU.cueResponse.poleInCRpeak{:,1}],'k.');
plot([SU.cueResponse.poleInBR{postPerfCells,1}],[SU.cueResponse.poleInCRpeak{postPerfCells,1}],'ko');
plot(repmat([SU.cueResponse.poleInBR{:,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{:,1}],repmat([SU.cueResponse.poleInCRpeak{:,1}],2,1),'k-')
plot(repmat([SU.cueResponse.poleInBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleInCRpeak{postPerfCells,1}],2,1),'k-')
plot(repmat([S.cueResponse.poleInBR{:}],2,1)+...
    [-1;1]*[S.cueResponse.poleInBRstd{:}],repmat([S.cueResponse.poleInCRpeak{:}],2,1),'r-')

plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])
title('Pole-in')
xlabel('Pre-cue spike rate (spk/s)')
ylabel('Cue peak spike rate (spk/s)')

subplot(2,2,2);hold on
plot([S.cueResponse.poleOutBR{:}],[S.cueResponse.poleOutCRpeak{:}],'r.');

plot([SU.cueResponse.poleOutBR{:,1}],[SU.cueResponse.poleOutCRpeak{:,1}],'k.');


plot([SU.cueResponse.poleOutBR{postPerfCells,1}],[SU.cueResponse.poleOutCRpeak{postPerfCells,1}],'ko');
plot(repmat([SU.cueResponse.poleOutBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleOutCRpeak{postPerfCells,1}],2,1),'k-')
plot(repmat([SU.cueResponse.poleOutBR{:,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{:,1}],repmat([SU.cueResponse.poleOutCRpeak{:,1}],2,1),'k-')
plot(repmat([S.cueResponse.poleOutBR{:}],2,1)+...
    [-1;1]*[S.cueResponse.poleOutBRstd{:}],repmat([S.cueResponse.poleOutCRpeak{:}],2,1),'r-')


plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])
title('Pole-out')
xlabel('Pre-cue spike rate (spk/s)')
ylabel('Cue peak spike rate (spk/s)')

subplot(2,2,3);hold on

plot([S.cueResponse.poleInBR{:}],[S.cueResponse.poleInCRmean{:}],'r.');

plot([SU.cueResponse.poleInBR{:,1}],[SU.cueResponse.poleInCRmean{:,1}],'k.');
plot([SU.cueResponse.poleInBR{postPerfCells,1}],[SU.cueResponse.poleInCRmean{postPerfCells,1}],'ko');
plot(repmat([SU.cueResponse.poleInBR{:,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{:,1}],repmat([SU.cueResponse.poleInCRmean{:,1}],2,1),'k-')

plot(repmat([SU.cueResponse.poleInBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleInCRmean{postPerfCells,1}],2,1),'k-')
plot(repmat([S.cueResponse.poleInBR{:}],2,1)+...
    [-1;1]*[S.cueResponse.poleInBRstd{:}],repmat([S.cueResponse.poleInCRmean{:}],2,1),'r-')

plot([0 60],[0 60],'k:')
set(gca,'Xlim',[0 60],'Ylim',[0 60])
title('Pole-in')
xlabel('Pre-cue spike rate (spk/s)')
ylabel('Cue mean spike rate (spk/s)')

subplot(2,2,4);hold on
plot([S.cueResponse.poleOutBR{:}],[S.cueResponse.poleOutCRmean{:}],'r.');

plot([SU.cueResponse.poleOutBR{:,1}],[SU.cueResponse.poleOutCRmean{:,1}],'k.');


plot([SU.cueResponse.poleOutBR{postPerfCells,1}],[SU.cueResponse.poleOutCRmean{postPerfCells,1}],'ko');
plot(repmat([SU.cueResponse.poleOutBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleOutCRmean{postPerfCells,1}],2,1),'k-')
plot(repmat([SU.cueResponse.poleOutBR{:,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{:,1}],repmat([SU.cueResponse.poleOutCRmean{:,1}],2,1),'k-')
plot(repmat([S.cueResponse.poleOutBR{:}],2,1)+...
    [-1;1]*[S.cueResponse.poleOutBRstd{:}],repmat([S.cueResponse.poleOutCRmean{:}],2,1),'r-')


plot([0 60],[0 60],'k:')
set(gca,'Xlim',[0 60],'Ylim',[0 60])
title('Pole-out')
xlabel('Pre-cue spike rate (spk/s)')
ylabel('Cue mean spike rate (spk/s)')
print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\CueAlignedGroupData'])


%%
figure(2);clf;clf;set(gcf,'Position',[25 25 800 800],'PaperPosition',[0 0 8 8],'PaperSize',[8 8])

subplot(2,2,1);hold on;cla

plot([SU.cueResponse.poleInCRpeak{postPerfCells,1}],[SU.cueResponse.poleInCRpeak{postPerfCells,2}],'ko');
plot(repmat([SU.cueResponse.poleInCRpeak{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleInCRpeak{postPerfCells,2}],2,1),'k-')
plot(repmat([SU.cueResponse.poleInCRpeak{postPerfCells,1}],2,1),...
    repmat([SU.cueResponse.poleInCRpeak{postPerfCells,2}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,2}],'k-')
plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])

title('Pole-in')
xlabel('Performing peak rate (spk/s)')
ylabel('Non-performing peak rate (spk/s)')


subplot(2,2,2);hold on;cla

plot([SU.cueResponse.poleOutCRpeak{postPerfCells,1}],[SU.cueResponse.poleOutCRpeak{postPerfCells,2}],'ko');
plot(repmat([SU.cueResponse.poleOutCRpeak{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleOutCRpeak{postPerfCells,2}],2,1),'k-')
plot(repmat([SU.cueResponse.poleOutCRpeak{postPerfCells,1}],2,1),...
    repmat([SU.cueResponse.poleOutCRpeak{postPerfCells,2}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,2}],'k-')
plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])

title('Pole-out')
xlabel('Performing peak rate (spk/s)')
ylabel('Non-performing peak rate (spk/s)')

subplot(2,2,3);hold on;cla

plot([SU.cueResponse.poleInBR{postPerfCells,1}],[SU.cueResponse.poleInBR{postPerfCells,2}],'ko');
plot(repmat([SU.cueResponse.poleInBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleInBR{postPerfCells,2}],2,1),'k-')
plot(repmat([SU.cueResponse.poleInBR{postPerfCells,1}],2,1),...
    repmat([SU.cueResponse.poleInBR{postPerfCells,2}],2,1)+...
    [-1;1]*[SU.cueResponse.poleInBRstd{postPerfCells,2}],'k-')
plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])

title('Pole-in')
xlabel('Performing pre-cue rate (spk/s)')
ylabel('Non-performing pre-cue rate (spk/s)')


subplot(2,2,4);hold on;cla

plot([SU.cueResponse.poleOutBR{postPerfCells,1}],[SU.cueResponse.poleOutBR{postPerfCells,2}],'ko');
plot(repmat([SU.cueResponse.poleOutBR{postPerfCells,1}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,1}],repmat([SU.cueResponse.poleOutBR{postPerfCells,2}],2,1),'k-')
plot(repmat([SU.cueResponse.poleOutBR{postPerfCells,1}],2,1),...
    repmat([SU.cueResponse.poleOutBR{postPerfCells,2}],2,1)+...
    [-1;1]*[SU.cueResponse.poleOutBRstd{postPerfCells,2}],'k-')
plot([0 100],[0 100],'k:')
set(gca,'Xlim',[0 100],'Ylim',[0 100])

title('Pole-out')
xlabel('Performing pre-cue rate (spk/s)')
ylabel('Non-performing pre-cue rate (spk/s)')


print('-depsc', ['Z:\users\Andrew\Whisker Project\Figures\CueAlignedGroupDataPerfvsNonPerf'])



