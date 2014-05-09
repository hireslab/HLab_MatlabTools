figure(2);cla;hold on
for i = 1:148
    plot(i,S.Vcurves{i}{2}(5)/S.Vcurves{i}{2}(3),'r.')
        plot(i,S.Vcurves{i}{2}(1)/S.Vcurves{i}{2}(3),'b.')

end
%%
figure(3);cla
snum = 90
plot(S.Vcurves{snum}{1},S.Vcurves{snum}{2})
plot(Stest.Vcurves{snum}{1},Stest.Vcurves{snum}{2},'r')

%%
figure(2);cla;hold on
inds = 1:148%find(abs(cellfun(@(x)(x{2}(1)-x{2}(5))/(x{2}(1)+x{2}(5)),S.Vcurves))>.2)


for i = inds
    plot(S.Vcurves{i}{2}(3),S.Vcurves{i}{2}(5),'r.')
   plot(S.Vcurves{i}{2}(3),S.Vcurves{i}{2}(1),'b.')
   plot([S.Vcurves{i}{2}(3) S.Vcurves{i}{2}(3)],[S.Vcurves{i}{2}(1) S.Vcurves{i}{2}(5)],'k')
end
plot([0 70],[0 70],'k:')


%%
figure(2);cla;hold on
inds = S.touchcells(find(abs(cellfun(@(x)(x{2}(1)-x{2}(7))/(x{2}(1)+x{2}(7)),S.M0ConCurves(S.touchcells)))>.25))


for i = inds
    plot(S.M0ConCurves{i}{2}(4),S.M0ConCurves{i}{2}(7),'r.')
   plot(S.M0ConCurves{i}{2}(4),S.M0ConCurves{i}{2}(1),'b.')
   plot([S.M0ConCurves{i}{2}(4) S.M0ConCurves{i}{2}(4)],[S.M0ConCurves{i}{2}(1) S.M0ConCurves{i}{2}(7)],'k')
end
plot([0 70],[0 70],'k:')



%%
figure(3);cla;hold on
inds = 1:148%find(abs(cellfun(@(x)(x{2}(1)-x{2}(5))/(x{2}(1)+x{2}(5)),S.Vcurves))>.2)


for i = inds
    plot(Stest.Vcurves{i}{2}(3),Stest.Vcurves{i}{2}(5),'r.')
   plot(Stest.Vcurves{i}{2}(3),Stest.Vcurves{i}{2}(1),'b.')
   plot([Stest.Vcurves{i}{2}(3) Stest.Vcurves{i}{2}(3)],[Stest.Vcurves{i}{2}(1) Stest.Vcurves{i}{2}(5)],'k')
end
plot([0 70],[0 70],'k:')



