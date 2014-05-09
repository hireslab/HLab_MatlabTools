for j=1:21
for i=1:10
    
m0fit{i} = fit(U.(cellNames{j}).fits.decision{i}.M0combo.bin,U.(cellNames{j}).fits.decision{i}.M0combo.binSpikeRate,'linearinterp');
tuningNums(i,:,j)=m0fit{i}([-.5e-7 0 .5e-7]);
tuningRatios(i,1,j)=tuningNums(i,1,j)./tuningNums(i,2,j);
tuningRatios(i,2,j)=tuningNums(i,3,j)./tuningNums(i,2,j);
end


tuningMaxInd(1,j) = find(abs(log10(tuningRatios(1:10,1,j))) == max(abs(log10(tuningRatios(1:10,1,j)))),1);   % Most directionally selective protraction timepot
tuningMaxInd(2,j) = find(abs(log10(tuningRatios(1:10,2,j))) == max(abs(log10(tuningRatios(1:10,2,j)))),1);   % Most directionally selective protraction timepot
end

for j=1:19
    tuningMax(1,j) = log10(tuningRatios(tuningMaxInd(1,j),1,j));
    tuningMax(2,j) = log10(tuningRatios(tuningMaxInd(2,j),2,j));
end    


directionSelectivity = squeeze((tuningNums(5,1,:)-tuningNums(5,3,:))./(tuningNums(5,1,:)+tuningNums(5,3,:)))
plot(structfun(@(x)x.info.depth,U)-100,directionSelectivity,'ro')

figure
hold on
a=find(trialTypes(:,3)+trialTypes(:,5)>=5);
x=structfun(@(x)x.info.depth,U);
y=directionSelectivity;
plot(x(a)-100,y(a),'ko');
plot([200 1000], [0 0],'k--');
xlabel('Depth um')
ylabel('(Pro - Ret)/(Pro + Ret)')
print(gcf, '-depsc','DirectionSelectivity-101910');

figure

plot([-5e-8, 0, 5e-8],log10(squeeze(mean(tuningNums(3:7,:,a)))),'o-')
xlim([-6e-8 6e-8])
xlabel('Moment (N*m)')
ylabel('log Firing Rate (spk/s)')
print(gcf, '-depsc','Direction-SpikeRate-101910');
