
 
figure
%allNums=(T.trialNums(T.trialNums >= params.trialRange(1) & T.trialNums <= params.trialRange(2)));
allnums=U.AH37.info.trialNums;
[~,useTrials,~]=intersect(T.trialNums,allNums);

% 
% touchTitles={'None', 'Go/Pro', 'Go/Ret', 'Nogo/Pro', 'No/Ret','Mean Spike Rates'};
% for i=1:5
%     subplot(2,3,i);cla;
%     if sum(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1))
% 
%         T.plot_lick_raster(T.trialNums(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1)),useTrials)),'Sequential',[],'lines');
%         hold on;
%         T.plot_spike_raster(T.trialNums(intersect(find(cellfun(@(x)x.trialContactType,contacts,'UniformOutput',1)==(i-1)),useTrials)),'Sequential',[],'lines');
%         end
%     axis([0 xmax 0 ymax]);
%     title(touchTitles{i});
% end

j=17;

m0fit = cell(j,1);
positionfit = cell(j,1);
velocityfit = cell(j,1);
accelerationfit = cell(j,1);
 family=U.AH37.fits.decision;

for i = 1:j
    m0fit{i} = fit(family{i}.M0combo.bin,family{i}.M0combo.binSpikeRate,'linearinterp');
   

    % Linear Fits
    %
    %     xv=family{i}.velocity.bin(2:end-1);
%     yv=family{i}.velocity.binSpikeRate(2:end-1);
%     velocityfit{i}(:,1) = polyfit(xv(xv>0),yv(xv>0),1);
%     velocityfit{i}(:,2) = polyfit(xv(xv<0),yv(xv<0),1);
%     
%     xa=family{i}.acceleration.bin(2:end-1);
%     ya=family{i}.acceleration.binSpikeRate(2:end-1);
%     accelerationfit{i}(:,1) = polyfit(xa(xa>0),ya(xa>0),1);
%     accelerationfit{i}(:,2) = polyfit(xa(xa<0),ya(xa<0),1);
end

subplot(2,2,1);cla;

hold on
for i=j:-1:1
    %plot(linspace(family{1}.M0combo.bin(1),family{1}.M0combo.bin(end)),m0fit{i}(linspace(family{1}.M0combo.bin(1),family{1}.M0combo.bin(end))),'.-','color',[1-i/j, 0, i/j],'LineWidth',2);
    plot(family{1}.M0combo.bin,m0fit{i}(family{1}.M0combo.bin),'.-','color',[1-i/j, 0, i/j],'LineWidth',2);

end
axis([min(family{1}.M0combo.bin(isfinite(family{1}.M0combo.bin))) max(family{1}.M0combo.bin(isfinite(family{1}.M0combo.bin)))...
    0 1.2*max(cellfun(@(x)max(x.M0combo.binSpikeRate),family))]);

xlabel('Moment')
ylabel('Spike Rate (spk/s)')
grid on

family=U.AH37.fits.prePole;
for i = 1:j

 positionfit{i} = fit(family{i}.position.bin,family{i}.position.binSpikeRate,'linearinterp');
    velocityfit{i}     = fit(family{i}.velocity.bin,family{i}.velocity.binSpikeRate,'linearinterp');
    accelerationfit{i} = fit(family{i}.acceleration.bin(isfinite(family{i}.acceleration.bin)),family{i}.acceleration.binSpikeRate(isfinite(family{i}.acceleration.bin)),'linearinterp');
end

subplot(2,2,2);cla;
hold on
for i=j:-1:1
    %plot(linspace(family{1}.position.bin(1),family{1}.position.bin(end)),positionfit{i}(linspace(family{1}.position.bin(1),family{1}.position.bin(end))),'.-','color',[1-i/j, 0, i/j]);
    plot(family{1}.position.bin,positionfit{i}(family{1}.position.bin),'.-','color',[1-i/j, 0, i/j]);

end
axis tight

% axis([min(family{1}.position.bin(isfinite(family{1}.position.bin))) max(family{1}.position.bin(isfinite(family{1}.position.bin)))...
%     0 1.2*max(positionfit{i}(linspace(family{1}.position.bin(1),family{1}.position.bin(end))))]);

xlabel('Position')
ylabel('Spike Rate (spk/s)')
grid on

for i = 1:j

    accelerationfit{i} = fit(family{i}.acceleration.bin(2:end-1),family{i}.acceleration.binSpikeRate(2:end-1),'linearinterp');
end

subplot(2,2,4);cla;
hold on
for i=j:-1:1
  %  plot(linspace(family{1}.acceleration.bin(2),family{1}.acceleration.bin(end-1)),accelerationfit{i}(linspace(family{1}.acceleration.bin(2),family{1}.acceleration.bin(end-1))),'.-','color',[1-i/j, 0, i/j],'LineWidth',2);
    plot(family{1}.acceleration.bin,accelerationfit{i}(family{1}.acceleration.bin),'.-','color',[1-i/j, 0, i/j],'LineWidth',2);

end
axis tight
%ylim([0 16])
%axis([min(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin(2:(end-1))))) max(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin(2:(end-1)))))...
%    0 1.2*max(accelerationfit{i}(linspace(family{1}.acceleration.bin(2),family{1}.acceleration.bin(end-1))))]);

grid on

xlabel('Acceleration')
ylabel('Spike Rate (spk/s)')

subplot(2,2,3);cla;
hold on
for i=j:-1:1
  %   plot(linspace(family{1}.velocity.bin(1),family{1}.velocity.bin(end)),velocityfit{i}(linspace(family{1}.velocity.bin(1),family{1}.velocity.bin(end))),'.-','color',[1-i/j, 0, i/j]);
     plot(family{1}.velocity.bin,velocityfit{i}(family{1}.velocity.bin),'.-','color',[1-i/j, 0, i/j]);

end
axis tight

% axis([min(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin))) max(family{1}.acceleration.bin(isfinite(family{1}.acceleration.bin)))...
%     0 1.2*max(accelerationfit{i}(linspace(family{1}.acceleration.bin(1),family{1}.acceleration.bin(end))))]);

xlabel('Velocity')
ylabel('Spike Rate (spk/s)')

grid on

