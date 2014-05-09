savedir = 'Z:\users\Andrew\Presentation\120227Meeting\'
h_fig1 = figure(1);clf;hold on
for i = 1:53
try 
    plot(-.05:.0001:.1,meanLFP{i}(1500:3000)/8+SU.recordingLocation{i}(3))
end
end

 title('LFP aligned to first contact')
ylabel('Depth from pia (mm)')
xlabel('Time from first contact (s)')

print(h_fig1, '-depsc', [savedir 'AllContactLFPvsDepth'])

for i = 1:53
    [~,ind(i)] = max(abs(meanLFP{i}(2100:2300)-mean(meanLFP{i}(1:2000))));
    val(i) = meanLFP{i}(2100+ind(i))-mean(meanLFP{i}(1:2000));
    val(abs(val)>1)=NaN;
    ind(abs(val)>1)=NaN
end

h_fig2 = figure(2);clf;hold on
recordingLoc = cell2mat(SU.recordingLocation)
plot(val,recordingLoc(:,3),'o')
 title('LFP peak amplitude aligned to first contact')
ylabel('Depth from pia (mm)')
xlabel('Peak Current')
print(h_fig2, '-depsc', [savedir 'FirstContactPeakLFPvsDepth'])
