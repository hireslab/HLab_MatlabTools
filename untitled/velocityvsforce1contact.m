cellnames = fieldnames(U)



colorind = jet(5);

for i = 1:20;%1:length(cellnames)
    
load([U.(cellnames{i}).info.homeDir '/spikesTrialArrays/' U.(cellnames{i}).info.arrayName])

subplot(4,5,i);cla;hold on
for c = 1;
    
tind = ~isnan(U.(cellnames{i}).C.decision.time(:,1));
gtind = bitand(tind,bitor(T.hitTrialInds',T.missTrialInds'));
ntind = bitand(tind,bitor(T.falseAlarmTrialInds',T.correctRejectionTrialInds'));
vtime = U.(cellnames{i}).C.decision.time(tind,1)-.005;
ftind = find(tind);

for k = ftind'
    
tlim = [U.(cellnames{i}).C.decision.time(k,c)-.01 U.(cellnames{i}).C.decision.time(k,c)-.001];

inds = find(T.trials{k}.whiskerTrial.time{1} > tlim(1) & T.trials{k}.whiskerTrial.time{1} < tlim(2));

time = T.trials{k}.whiskerTrial.time{1}(inds);

xP = T.trials{k}.whiskerTrial.thetaAtBase{1}(inds);
V(k) = nanmean(xP);
end
plot(U.(cellnames{i}).C.decision.peakM0(ntind,1),V(ntind),'r.');
plot(U.(cellnames{i}).C.decision.peakM0(gtind,1),V(gtind),'b.');

end

title(cellnames{i})
end
ylabel('Pre contact Velocity'); xlabel( 'Max Contact M0')

set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 7.75])
print(gcf, '-depsc','PreContactVelocity vs MaxM0.eps');
