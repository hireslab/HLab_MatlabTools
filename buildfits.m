
j=17;

m0fit = cell(j,1);
positionfit = cell(j,1);
velocityfit = cell(j,1);
accelerationfit = cell(j,1);

for i = 1:j
    m0fit{i} = fit(family{i}.M0combo.bin,family{i}.M0combo.binSpikeRate,'linearinterp');
    positionfit{i} = fit(family{i}.position.bin,family{i}.position.binSpikeRate,'linearinterp');

    xv=family{i}.velocity.bin(2:end-1);
    yv=family{i}.velocity.binSpikeRate(2:end-1);
    velocityfit{i}(:,1) = polyfit(xv(xv>0),yv(xv>0),1);
    velocityfit{i}(:,2) = polyfit(xv(xv<0),yv(xv<0),1);
    
    xa=family{i}.acceleration.bin(2:end-1);
    ya=family{i}.acceleration.binSpikeRate(2:end-1);
    accelerationfit{i}(:,1) = polyfit(xa(xa>0),ya(xa>0),1);
    accelerationfit{i}(:,2) = polyfit(xa(xa<0),ya(xa<0),1);
end

h_filters=figure;
subplot(2,2,1);cla;
hold on
for i=j:-1:1
    plot(linspace(family{1}.M0combo.bin(1),family{1}.M0combo.bin(end)),m0fit{i}(linspace(family{1}.M0combo.bin(1),family{1}.M0combo.bin(end))),'color',[1-i/j, 0, i/j]);
end
axis([min(family{1}.M0combo.bin(isfinite(family{1}.M0combo.bin))) max(family{1}.M0combo.bin(isfinite(family{1}.M0combo.bin)))...
    0 1.2*max(cellfun(@(x)max(x.M0combo.binSpikeRate),family))]);

xlabel('Moment')
ylabel('Spike Rate (Hz)')
grid on

subplot(2,2,2);cla;
hold on
for i=j:-1:1
    plot(linspace(family{1}.position.bin(1),family{1}.position.bin(end)),positionfit{i}(linspace(family{1}.position.bin(1),family{1}.position.bin(end))),'color',[1-i/j, 0, i/j]);
end
axis([min(family{1}.position.bin(isfinite(family{1}.position.bin))) max(family{1}.position.bin(isfinite(family{1}.position.bin)))...
    0 1.2*max(positionfit{i}(linspace(family{1}.position.bin(1),family{1}.position.bin(end))))]);

xlabel('Position')
ylabel('Spike Rate (Hz)')
grid on

subplot(2,2,3);cla;
hold on
for i=j:-1:1
    plot(linspace(0,max(family{1}.velocity.bin(isfinite(family{1}.velocity.bin)))),polyval(velocityfit{i}(:,1),linspace(0,max(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))))),'-','color',[1-i/j, 0, i/j]);

    plot(linspace(min(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))),0),polyval(velocityfit{i}(:,2),linspace(min(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))),0)),'-','color',[1-i/j, 0, i/j]);

end
grid on
axis([min(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))) max(family{1}.velocity.bin(isfinite(family{1}.velocity.bin)))...
    0 1.2*max(cat(2,polyval(velocityfit{i}(:,1),linspace(0,max(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))))), polyval(velocityfit{i}(:,2),linspace(min(family{1}.velocity.bin(isfinite(family{1}.velocity.bin))),0))))]);

xlabel('Velocity')
ylabel('Spike Rate (Hz)')

subplot(2,2,4);cla;
hold on
for i=j:-1:1
    plot(linspace(0,max(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin)))),polyval(accelerationfit{i}(:,1),linspace(0,max(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin))))),'-','color',[1-i/j, 0, i/j]);

    plot(linspace(min(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin))),0),polyval(accelerationfit{i}(:,2),linspace(min(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin))),0)),'-','color',[1-i/j, 0, i/j]);

end
axis([min(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin))) max(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin)))...
    0 1.2*max(cat(2,polyval(accelerationfit{i}(:,1),linspace(0,max(family{1}.acceleration.bin(isfinite(family{1}.velocity.bin))))), polyval(accelerationfit{i}(:,2),linspace(min(family{1}.acceleration.bin(isfinite(family{1}.velocity.bin))),0)))) ]);

xlabel('Acceleration')
ylabel('Spike Rate (Hz)')

grid on


print(gcf, '-depsc',[T.cellNum '-' params.displayType '-Filters.eps']);