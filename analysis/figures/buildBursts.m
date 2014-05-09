figure(1);cla;hold on
for i = 1:148
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10),'o-','MarkerSize',6,'color',[.7 .7 .7]);
ylabel('number of bursts in session')
xlabel('spikes / burst')
end

for i = L5ind
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10),'o-','MarkerSize',6);
ylabel('number of bursts in session')
xlabel('spikes / burst')
end


figure(2);cla;hold on

for i = 1:148
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10),'o-','MarkerSize',6,'color',[.7 .7 .7]);
ylabel('number of bursts in session')
xlabel('spikes / burst')
set(gca,'YLim',[0 400],'XLim',[2 10]);

end

for i = L5ind
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10),'o-','MarkerSize',6);
ylabel('number of bursts in session')
xlabel('spikes / burst')
set(gca,'YLim',[0 400],'XLim',[2 10]);
end

%%

figure(1);cla;hold on
for i = 1:148
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10)/S.ISI.burst{i}(1),'o-','MarkerSize',6,'color',[.7 .7 .7]);
ylabel('number of bursts in session')
xlabel('spikes / burst')
end

for i = L5ind
plot(S.ISI.edges{i}(2:10)+1.5,S.ISI.burst{i}(2:10)/S.ISI.burst{i}(1),'o-','MarkerSize',6);
ylabel('number of bursts in session')
xlabel('spikes / burst')
end



