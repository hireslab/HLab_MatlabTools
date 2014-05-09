 d = dir('*WT*')
 
 for k = 1:length(d)
     load(d(k).name);
x_D = cellfun(@(x)x{4},w.trackerData{1},'UniformOutput',0);
y_D = cellfun(@(x)x{5},w.trackerData{1},'UniformOutput',0);

x = nan(length(x_D),max(cellfun(@length,x_D)));
y = nan(length(y_D),max(cellfun(@length,y_D)));


for i  = 1:size(x,1)
    try
        x(i,1:length(x_D{i})) = x_D{i};
        y(i,1:length(y_D{i})) = -y_D{i};
        [y(i,:) yind] = sort(y(i,:));
        x(i,:) = x(i,yind);
        
    end
end
y=-y;

save([w.trackerFileName '_rawX'], 'x', '-ascii')
save([w.trackerFileName '_rawY'], 'y', '-ascii')
 end
 