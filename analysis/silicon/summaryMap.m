figure(1000);clf
hold on
value = [];
value2 = [];
for i=1:148
    
    value(i,1) = log2(S.M0ConCurves{i}{2}(1)/nanmean(S.baselineSR{i})); % Pro Touch Modulation
    value(i,2) = log2(S.M0ConCurves{i}{2}(7)/nanmean(S.baselineSR{i})); % Ret Touch Modulation
%     
%     value(i,1) = log2(S.M0ConCurves{i}{2}(1)/S.M0ConCurves{i}{2}(4)); % Pro Touch Modulation
%     value(i,2) = log2(S.M0ConCurves{i}{2}(7)/S.M0ConCurves{i}{2}(4)); % Ret Touch Modulation
%     
    
    value(i,3) = log2(S.Vcurves{i}{2}(1)/S.Vcurves{i}{2}(3));   %
    value(i,4) = log2(S.Vcurves{i}{2}(5)/S.Vcurves{i}{2}(3));   %
    
    value(i,5) =  log2(S.Acurves{i}{2}(1)/S.Acurves{i}{2}(3));   %
    value(i,6) =  log2(S.Acurves{i}{2}(5)/S.Acurves{i}{2}(3));   %
    
%     value(i,7) =  log2(S.Pcurves{i}{2}(1)/S.Pcurves{i}{2}(4));   %
 %    value(i,8) =  log2(S.Pcurves{i}{2}(7)/S.Pcurves{i}{2}(4));   %
%     
    %   value(i,3) = (max(S.M0ConMod{i}{1}(:,1))-min(S.M0ConMod{i}{2}(:,1)))/(S.M0ConMod{i}{3}(1))
    %  value(i,4) = (max(S.M0ConMod{i}{1}(:,1))-min(S.M0ConMod{i}{2}(:,1)))/(S.M0ConMod{i}{3}(1))
    



    
end
value(:,1:2) = value(:,1:2)
value2= value;
value2(abs(value2)<.5) = 0

for i=1:148
%      value2(i,7) = sum(value2(i,1:6).*[32 16 8 4 2 1]+sign(value2(i,1:6).*5.*[32 16 8 4 2 1]));
     value2(i,9) = nansum(double(sign(value2(i,1:6)).*[32 16 8 4 2 1]))%+nansum(value2(i,1:6).*.0.*[32 16 8 4 2 1]);

end

 value(:,9) = value2(:,9);
 value(:,10) = 1:148;
 value = sortrows(value,9)
% 
 vtmp = value(:,10);


value(value(:,1:8) > 5) = 5
value(value(:,1:8) < -5) = -5
value(:,9) = vtmp;

%value(:,7) =  cellfun(@(x)x,S.depth(1:148));
%value(:,8) =  cellfun(@(x)x,S.dist(1:148));
%value(:,7) =  cellfun(@(x)x,S.clustwidth(1:148));
%value(:,7) =  cellfun(@(x)mean(x([1 5])),S.baselineSR(1:148));

%value = sortrows(value,1);

% z = clusterdata(value,1)
% value(:,7) = z



%
%               value(value(:,2)>5,2) = 5
%           value(value(:,2)< - 5,2) = -5
%               value(value(:,3)>5,2) = 5
%           value(value(:,3)< - 5,2) = -5
value(isnan(value)) = 0;

for i =1:148
    for j = 1:8
    patch(i+[0 0 1 1], -j+[0 1 1 0],map(round(value(i,j)*10)+51,:))
    
    
%     plot(1,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,1)*10)+51,:));
%     plot(2,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,2)*10)+51,:));
%     plot(3,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,3)*10)+51,:));
%     plot(4,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,4)*10)+51,:));
%     plot(5,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,5)*10)+51,:));
%     plot(6,i,'sk','MarkerEdgeColor','none','MarkerSize',5,'MarkerFaceColor',map(round(value(i,6)*10)+51,:));
    end    
end


set(gcf,'Position',[100 100 2000 500],'PaperOrientation','portrait','PaperPosition',[0 0 20 5], 'PaperSize', [20 5])

colormap(map)
colorbar('YTickLabel',{'-32','-16','-8', '-4', '-2', '0', '2', '4', '8', '16', '32'})
  
%print('-depsc', 'Q:\Silicon\Figures\summaryMapNew') 
