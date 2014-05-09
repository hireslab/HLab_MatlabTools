figure(2);cla;hold on
for i = 1:length(wl.trials)
plot(wl.trials{i}.follicleCoordsX{1},wl.trials{i}.follicleCoordsY{1},'.')
end