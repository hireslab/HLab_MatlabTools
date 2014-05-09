SU_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
SU_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')
SU_SDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\SweepArrays\')

Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA')

for i=1:53%:length(SU.cellName);
    load([SU_TDir SU.trialArrayName{i}]);
    load([SU_SDir SU.sweepArrayName{i}]);
    
    load([SU_ConDir SU.contactsArrayName{i}]);
     


outfig = figure('Color',get(0,'DefaultUicontrolBackgroundColor'), ...
    'Tag','viewISIfig','NumberTitle','off','Name',['ISI viewer: ', T.mouseName ' ' T.cellNum]);

set(outfig,'Position',[25 25 800 800],'PaperOrientation','portrait','PaperPosition',[0 0 4 4],'PaperSize',[4 4]);

% infig = figure('Color',get(0,'DefaultUicontrolBackgroundColor'), ...
%     'Tag','inset','NumberTitle','off','Name',['ISI viewer: ', T.mouseName ' ' T.cellNum]);

%h1 = axes('XScale','log');
h1 = axes('XScale','linear');
hold on
tmp = T.get_all_interspike_intervals([]);
ISI = tmp(:,3);
ISI = ISI(ISI>.002);
ISI = 1000*[ISI;-ISI];
edges = [-300:.5:300];
%dges = [[-.025:.0005:.025]];
N = histc(ISI,edges);
axis([-300 300 0 max(N)]);

if (sum(N))
    phandle = bar(edges,N,'histc');
    set(phandle,'LineStyle','none');
    set(phandle,'FaceColor',[0 0 0]);
%     xlabel('Time between spikes (ms)');
%     ylabel('Number of spikes');
    %set(phandle,'XScale','log');
end
text(0,1.05*max(N),[T.cellNum  ' Depth ' num2str(-1000*SU.recordingLocation{i}(3))],'HorizontalAlignment','center')

axes('pos',[.6 .6 .30 .30]);
ihandle = bar(edges,N,'histc')
    set(ihandle,'LineStyle','none','FaceColor',[0 0 0]);
set(gca,'YLim', [0 max(N)], 'XLim', [-15 15],'XTick',[-15 -10 -5 0 5 10 15],'FontSize',8)
box off

print('-depsc', ['Z:\Users\Andrew\Whisker Project\SingleUnit\Figures\ISI\ISI_' T.mouseName '_' T.cellNum '_depth' num2str(-1000*SU.recordingLocation{i}(3))]) 
close(outfig);
end
