d = dir('Z:\users\Andrew\Whisker Project\SingleUnit\DiscrimAnalysisArrays\*.mat');

SU_L4nums = find(cellfun(@(x)x(3),SU.recordingLocation) > -.588 &  cellfun(@(x)x(3),SU.recordingLocation) < -.418)

for snum = 94
     [CA, T, contacts, DA, clustInd, params] = loadSiData(snum, S)
figure(2);clf;hold on;set(gcf,'paperposition', [0 0 2 2],'papersize', [2 2])

conInd= {};
whiskInd = {};
whiskPoleInd = {};
whiskTheta = {};
whiskPoleTheta = {};
contactTrigTheta = {};
tinds = find(cellfun(@(x)~isempty(x),DA.theta))'
if max(tinds) > length(DA.contactTimesInSamplingPeriod);
    for j = length(DA.contactTimesInSamplingPeriod)+1: max(tinds);
    DA.contactTimesInSamplingPeriod{j}=[];
    end
end

for i = tinds;
     [~,conInd{i},~] = intersect(DA.samplingPeriodinMs{i},DA.contactTimesInSamplingPeriod{i});
     [~,whiskPoleInd{i},~] = intersect(DA.samplingPeriod{i},DA.whiskSamplingPeriod{i}(DA.whiskSamplingPeriod{i}>.7));
     [~,whiskInd{i},~] = intersect(DA.samplingPeriod{i},DA.whiskSamplingPeriod{i});
     contactTrigTheta{i} = DA.theta{i}(conInd{i});
    whiskTheta{i} = DA.theta{i}(whiskInd{i});
    whiskPoleTheta{i} = DA.theta{i}(whiskPoleInd{i});
end
edges = -40:1:60;
histConTheta = histc([contactTrigTheta{:}],edges);
histSampleTheta = histc([DA.theta{:}],edges);
histWhiskTheta = histc([whiskTheta{:}],edges);

histConThetaGo = histc([contactTrigTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histConThetaNogo = histc([contactTrigTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);

histWhiskThetaGo = histc([whiskTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histWhiskThetaNogo = histc([whiskTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);
histWhiskPoleThetaGo = histc([whiskPoleTheta{intersect(tinds,[DA.hitInd DA.missInd])}],edges);
histWhiskPoleThetaNogo = histc([whiskPoleTheta{intersect(tinds,[DA.CRInd DA.FAInd])}],edges);

figure(1);clf;hold on;set(gcf,'paperposition', [0 0 1.97 1],'papersize', [1.97 1])
bar(edges(histConThetaGo>0)+.5,histConThetaGo(histConThetaGo>0),'b','edgecolor','b');
bar(edges(histConThetaNogo>0)+.5,histConThetaNogo(histConThetaNogo>0),'r','edgecolor','r');
            h = findobj(gca,'Type','patch');
    set(h,'linewidth',.5,'facealpha',0.25)
    set(gca,'xlim',[-30 60])
ylabel('contacts / deg')
set(gca,'xtick',[])
%legend('Go Trials','Nogo Trials')
%title(['SU Cell # ' SU.trialArrayName{snum}(16:end-4)])
%set(gca,'visible','off')
%print(gcf, '-dtiff', '-r1200', ['Z:\manuscripts\L4Stim\Fig1Parts\ExampleWhiskingTouchDist_'  SU.trialArrayName{snum}(16:end-4)])

figure(2);clf;hold on;set(gcf,'paperposition', [0 0 2 2],'papersize', [2 2])
plot(edges+.5,smooth(histSampleTheta-histWhiskTheta)/1000,'k-');
plot(edges+.5,smooth(histWhiskThetaGo)/1000,'b-');
plot(edges+.5,smooth(histWhiskThetaNogo)/1000,'r-');
set(gca,'xlim',[-30 60])
set(gca,'ytick',[0:.5:3.5])
ylabel('Whisker occupancy (s)')
xlabel('Whisker \theta (deg)')
[legend_h] = legend('Non-whisking', 'Go whisking','Nogo whisking');
h_legendKids = get(legend_h,'Children');
set(h_legendKids([2 5 8]),'XData',[.3 .39])
legend boxoff;

%print(gcf, '-depsc', ['Z:\manuscripts\L4Stim\Fig1Parts\SmoothExampleWhisking_'  SU.trialArrayName{snum}(16:end-4)])
end

