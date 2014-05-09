cellNum = 116;

figure(1002);clf;

SRmax = max([2*S.baselineSR{cellNum} S.M0ConCurves{cellNum}{2}' S.Vcurves{cellNum}{2}' S.Acurves{cellNum}{2}'])

subplot(1,3,1);hold on
plot(S.M0ConCurves{cellNum}{1},S.M0ConCurves{cellNum}{2},'o-')
plot([-1.5e-7 1.5e-7],[S.baselineSR{cellNum} S.baselineSR{cellNum}],'--k')
axis([-1.5e-7 1.5e-7 0 SRmax])
xlabel('Moment (N*m)')
ylabel('Spike rate (spk/s)')

subplot(1,3,2);hold on
plot(S.Vcurves{cellNum}{1},S.Vcurves{cellNum}{2},'o-');
plot([-1000 1000],[S.baselineSR{cellNum} S.baselineSR{cellNum}],'--k')

axis([-1000 1000 0 SRmax])
xlabel('Velocity (deg/s)')


subplot(1,3,3);hold on
plot(S.Acurves{cellNum}{1},S.Acurves{cellNum}{2},'o-')
plot([-100000 100000],[S.baselineSR{cellNum} S.baselineSR{cellNum}],'--k')

axis([-1e5 1e5 0 SRmax])
xlabel('Acceleration (deg/s^2)')

set(gcf,'Position',[100 100 1500 500],'PaperOrientation','portrait','PaperPosition',[0 0 15 5], 'PaperSize', [15 5])
print('-depsc', ['\Lab\Silicon\Figures\tuningCell' num2str(cellNum)])