
%% plot latencies
savedir = 'Z:\users\Andrew\Presentation\120227Meeting\'

figure(2);cla;hold on
S_ind = find(cell2mat(S.latency)>0);
SU_ind = find(cell2mat(SU.latency)>0);

for i = S_ind
    plot(S.distance{i}+(rand-.5)/10,S.latency{i},'bo')
    
    end

for i = SU_ind'
   

    plot(SU.distance{i}+(rand-.5)/100,SU.latency{i},'ro')

end



[SlatP SlatS] = polyfit(cell2mat(S.distance(S_ind)),cell2mat(S.latency(S_ind)),1)
[SUlatP SUlatS] = polyfit(cell2mat(SU.distance(SU_ind)),cell2mat(SU.latency(SU_ind)),1)

x = 0:.1:.8
plot(x,polyval(SlatP,x),'b')
plot(x,polyval(SUlatP,x),'r')

text(.02,33,'SiProbe', 'color','b')
text(.02,31,'Cell Attached', 'color','r')
title('Contact to Spike Latency')
xlabel('Distance from C2 center (mm)')
ylabel('Modal Latency (ms)')
set(gca,'Ylim',[0 40]);
print(gcf, '-depsc', [savedir 'ComboLatencies'])% T.mouseName '_' T.sessionName])

