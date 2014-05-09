 d = dir('*WT*')
 
 for k = 1%:length(d)
     load(d(k).name);
y_D = cellfun(@(x)x{4},w.trackerData{1},'UniformOutput',0);
x_D = cellfun(@(x)x{5},w.trackerData{1},'UniformOutput',0);

fw25 = 1:25;
fw50 = 1:50;
xy_D = {};
fitD25={};
fitD50={};
thetaAtBase25 =[];
thetaAtBase50=[];
for i  = 1:length(x_D)
    try
        xy_D{i}(:,1) = x_D{i};
        xy_D{i}(:,2) = y_D{i};
        xy_D{i} = sortrows(xy_D{i},-2);
        fitD25{i} = polyfit(xy_D{i}(fw25,1),xy_D{i}(fw25,2),1);
        fitD50{i} = polyfit(xy_D{i}(fw50,1),xy_D{i}(fw50,2),1);
        thetaAtBase25(i) = atan(fitD25{i}(1));
        thetaAtBase50(i) = atan(fitD50{i}(1));
    end
end

thetaAtBase25 = double(thetaAtBase25)';
thetaAtBase50 = double(thetaAtBase50)';
save([w.trackerFileName '_thetaAtBase25'], 'thetaAtBase25', '-ascii')
save([w.trackerFileName '_thetaAtBase50'], 'thetaAtBase50', '-ascii')
 end
 