for i = 1:53
    phaseMod{i,1} = (max(SU.phaseSRBinned{i}.phaseSRMean)-min(SU.phaseSRBinned{i}.phaseSRMean))/mean(SU.phaseSRBinned{i}.phaseSRMean);
end

savedir = 'Z:\users\Andrew\Whisker Project\SingleUnit\Figures\PhaseSR\'

%%
figure(2);clf;hold on
plot(-cellfun(@(x)x(3),SU.recordingLocation),cell2mat(phaseMod),'o')
plot(-cellfun(@(x)x(3),SU.recordingLocation(find(cell2mat(SU.distance)<.15))),cell2mat(phaseMod(find(cell2mat(SU.distance)<.15))),'.')
set(gca,'XLim',[0 1])
xlabel('Depth from pia (mm)')
ylabel('Phasic free whisking modulation')
legend('All Cells','C2')
print(gcf, '-depsc', [savedir 'PhaseModvsDepth']);

          
%%
(-cellfun(@(x)x(3),SU.recordingLocation)>.4 & -cellfun(@(x)x(3),SU.recordingLocation) < .6)
figure(3);clf;hold on
plot(cell2mat(SU.distance),cell2mat(phaseMod),'o')
plot(cell2mat(SU.distance(-cellfun(@(x)x(3),SU.recordingLocation)>.4 & -cellfun(@(x)x(3),SU.recordingLocation) < .6)),...
    cell2mat(phaseMod(-cellfun(@(x)x(3),SU.recordingLocation)>.4 & -cellfun(@(x)x(3),SU.recordingLocation) < .6)),'.')
set(gca,'XLim',[0 1])
xlabel('Dist from C2 (mm)')
ylabel('Phasic free whisking modulation')
legend('All Cells','Layer 4')
          print(gcf, '-depsc', [savedir 'PhaseModvsDist']);

%%
figure(4);clf;hold on
plot(cellfun(@(x)mean(x.phaseSRMean),SU.phaseSRBinned),cell2mat(phaseMod),'o')
plot(cellfun(@(x)mean(x.phaseSRMean),SU.phaseSRBinned(-cellfun(@(x)x(3),SU.recordingLocation)>.4 & -cellfun(@(x)x(3),SU.recordingLocation) < .6)),...
    cell2mat(phaseMod(-cellfun(@(x)x(3),SU.recordingLocation)>.4 & -cellfun(@(x)x(3),SU.recordingLocation) < .6)),'.')

xlabel('mean whisk spike rate')
ylabel('Phasic whisking modulation')

         print(gcf, '-depsc', [savedir 'PhaseModvsSR']);
%%