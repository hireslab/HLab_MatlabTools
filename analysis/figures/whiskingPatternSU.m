d = dir('Z:\users\Andrew\Whisker Project\SingleUnit\DiscrimAnalysisArrays\*.mat');

%SU_L4nums = find(cellfun(@(x)x(3),SU.recordingLocation) > -.588 &  cellfun(@(x)x(3),SU.recordingLocation) < -.418)

for snum = 3%SU_L4nums
    load(['Z:\users\Andrew\Whisker Project\SingleUnit\DiscrimAnalysisArrays\' d(snum).name])
figure(1);clf

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


subplot(4,1,1);cla;hold on
plot(edges,histConThetaGo,'g-');
plot(edges,histConThetaNogo,'r-');
ylabel('contacts / deg')
legend('Go Trials','Nogo Trials')
title(['SU Cell # ' d(snum).name(4:end-4)])

subplot(4,1,2);cla;hold on
plot(edges,histSampleTheta,'k-');
subplot(4,1,2)
plot(edges,histWhiskTheta,'r-');
title('Pre-answer period')
ylabel('occupancy (ms)')
legend('All Times', 'Whisking Amp > 2.5')

subplot(4,1,3);cla;hold on
plot(edges,histWhiskThetaGo,'g-');
plot(edges,histWhiskThetaNogo,'r-');
title('Whisking in pre-answer period')
ylabel('occupancy (ms)')
legend('Go Trials','Nogo Trials')

subplot(4,1,4);cla;hold on
plot(edges,histWhiskPoleThetaGo,'g-');
plot(edges,histWhiskPoleThetaNogo,'r-');
xlabel('Theta at base')
title('Whisking in pole available period')
ylabel('occupancy (ms)')
legend('Go Trials','Nogo Trials')

print(gcf, '-depsc', ['Z:\users\Andrew\Whisker Project\SingleUnit\Figures\WhiskingOccupancy\Whisking_' d(snum).name(4:end-4)])
end

