% Adaptation analysis for all touch cells;
figure(4);clf;set(gcf,'defaultlinemarkersize',8)
touchCA = [24 12 25 51 37 27 2 10 20 36 5 41 7 9 28 4 3 6 34 46 19 26 1 50 14 18 16 8 11 ];
touchSi = [55 144 53 52 29 107 43 128 57 127 58 56 108 27 65 77 99 101 111 130 132 91 48 92 50 47 84 89 46 42 15 141 41 93 121 126 68 66];

for i = touchCA
    [~ ,maxIdx] = max(SU.PCTH.Ind.allCon.Hist{i,1}(51:end))
    %x = (1:(52-maxIdx))';
    %y = SU.PCTH.Ind.allCon.Hist{i,1}(maxIdx+55:end)- mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50));
    CA.baseline{i} =  mean(SU.PCTH.Ind.allCon.Hist{i,1}(1:50));
    CA.csum{i} = cumsum(SU.PCTH.Ind.allCon.Hist{i,1}(51:101) - CA.baseline{i});
    CA.csumNorm{i} = CA.csum{i}/max(CA.csum{i})
    abs(CA.csumNorm{i}(find(CA.csumNorm{i}>.5,1)-1)-.5)/sum(abs(CA.csumNorm{i}(find(CA.csumNorm{i}>.5,1)+[-1 0])-.5))
    CA.tHalf{i} = find(CA.csumNorm{i}>.5,1) -.05 + ...
    abs(CA.csumNorm{i}(find(CA.csumNorm{i}>.5,1)-1)-.5)/sum(abs(CA.csumNorm{i}(find(CA.csumNorm{i}>.5,1)+[-1 0])-.5));


% ratio of 3-5th contact response to first contact response

CA.adaptRatio{i}= ( ([SU.PCTH.Ind.allCon.lambda{i,1}]-CA.baseline{i}*.05) - (nanmean([SU.PCTH.Ind.allCon.lambda{i,3:5}]) -CA.baseline{i}*.05)) / ...
    ([SU.PCTH.Ind.allCon.lambda{i,1}]-CA.baseline{i}*.05);

end

for i = touchSi
    [~ ,maxIdx] = max(S.PCTH.Ind.allCon.Hist{i,1}(51:end))
    %x = (1:(52-maxIdx))';
    %y = S.PCTH.Ind.allCon.Hist{i,1}(maxIdx+55:end)- mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50));
    Si.baseline{i} =  mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50));

    Si.csum{i} = cumsum(S.PCTH.Ind.allCon.Hist{i,1}(51:101) - mean(S.PCTH.Ind.allCon.Hist{i,1}(1:50)));
    Si.csumNorm{i} = Si.csum{i}/max(Si.csum{i});
    
    Si.csum{i} = cumsum(S.PCTH.Ind.allCon.Hist{i,1}(51:101) - Si.baseline{i});
    Si.csumNorm{i} = Si.csum{i}/max(Si.csum{i})
    abs(Si.csumNorm{i}(find(Si.csumNorm{i}>.5,1)-1)-.5)/sum(abs(Si.csumNorm{i}(find(Si.csumNorm{i}>.5,1)+[-1 0])-.5))
    Si.tHalf{i} = find(Si.csumNorm{i}>.5,1) -.05 + ...
    abs(Si.csumNorm{i}(find(Si.csumNorm{i}>.5,1)-1)-.5)/sum(abs(Si.csumNorm{i}(find(Si.csumNorm{i}>.5,1)+[-1 0])-.5));


% ratio of 3-5th contact response to first contact response

Si.adaptRatio{i}= ( ([S.PCTH.Ind.allCon.lambda{i,1}]-Si.baseline{i}*.05) - (nanmean([S.PCTH.Ind.allCon.lambda{i,3:5}]) -Si.baseline{i}*.05)) / ...
     ([S.PCTH.Ind.allCon.lambda{i,1}]-Si.baseline{i}*.05);

end

%%

%% Spikes added vs. depth

h_fig2 = figure(2);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchSi
        plot(-S.DiIdepth{i},max(Si.csum{i})*.001,'k.','userdata',i,'markersize',8);
    
end
plotIdx = get(get(h_fig2,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x,S.dist([plotUserData{:}]))<.250)
plotFarIdx = plotIdx(cellfun(@(x)x,S.dist([plotUserData{:}]))>.250)

set(plotCloseIdx,'color','r')
text(0.5, .95, 'Near C2','color', 'r')
text(0.5, .9, 'Far C2','color', 'k')
title('Cell Attached First Contact')
ylabel('Normalized added spikes')
xlabel('Depth from pia (mm)')
%% Spikes added vs. depth

h_fig3 = figure(3);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchCA
        plot(-SU.recordingLocation{i}(3),max(CA.csum{i})*.001,'k.','userdata',i,'markersize',8);
    
end
plotIdx = get(get(h_fig3,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))<.250)
plotFarIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))>.250)

set(plotCloseIdx,'color','r')
set(plotFarIdx,'color','w')

text(0.1, 3, 'Near C2','color', 'r')
text(0.1, 2.5, 'Far C2','color', 'w')
title('Cell Attached First Contact')
ylabel('Normalized added spikes')
xlabel('Depth from pia (mm)')



%% Normalized spike increase rate

h_fig4 = figure(4);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchCA
        plot(CA.csumNorm{i},'k','userdata',i);
    
end
plotIdx = get(get(h_fig4,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))<.250)
plotFarIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))>.250)

set(plotCloseIdx,'color','r')
text(0.5, .95, 'Near C2','color', 'r')
text(0.5, .9, 'Far C2','color', 'k')
title('Cell Attached Data')
ylabel('Normalized added spikes')
xlabel('Time from touch (ms)')

%% Normalized spike increases aligned to onset latency

h_fig5 = figure(5);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchCA
        plot(CA.csumNorm{i}(find(CA.csumNorm{i}>.05,1):end),'k','userdata',i);
    
end
plotIdx = get(get(h_fig5,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))<.250)
plotFarIdx = plotIdx(cellfun(@(x)x,SU.distance([plotUserData{:}]))>.250)

set(plotCloseIdx,'color','r')
text(0.5, .95, 'Near C2','color', 'r')
text(0.5, .9, 'Far C2','color', 'k')
title('Cell Attached Data')
ylabel('Normalized added spikes')
xlabel('Time from touch (ms)')


%%
h_fig11 = figure(11),clf,hold on
for i = touchCA
   plot(CA.tHalf{i},CA.adaptRatio{i},'.','markersize',8,'userdata',i)

end


plotIdx = get(get(h_fig11,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.418 )
%plotFarIdx = plotIdx(~(cellfun(@(x)x,SU.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.418 ))

set(plotCloseIdx,'color','r')
%%
h_fig11 = figure(11),clf,hold on
for i = touchSi
    try
   plot(Si.tHalf{i},Si.adaptRatio{i},'.','markersize',8,'userdata',i)
    end
end


plotIdx = get(get(h_fig11,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotCloseIdx = plotIdx(cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))< -.418 )
%plotFarIdx = plotIdx(~(cellfun(@(x)x,SU.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.418 ))

set(plotCloseIdx,'color','r')
%%
h_fig10 = figure(10);clf;hold on
for i = touchCA
   plot(SU.distance{i},CA.tHalf{i},'.','markersize',8,'userdata',i)

end
plotIdx = get(get(h_fig10,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotL23Idx = plotIdx( cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))> -.418 )
plotL4Idx = plotIdx(cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.418 )
plotL5Idx = plotIdx(cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.588)

%plotFarIdx = plotIdx(~(cellfun(@(x)x,SU.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),SU.recordingLocation([plotUserData{:}]))< -.418 ))
    
set(plotL23Idx,'color','k')
set(plotL4Idx,'color','r')
set(plotL5Idx,'color','g')

%%
h_fig20 = figure(20);clf;hold on
for i = touchSi
   plot(S.dist{i},Si.tHalf{i},'.','markersize',8,'userdata',i)

end
plotIdx = get(get(h_fig20,'CurrentAxes'),'children');
plotUserData = get(plotIdx,'userData');

plotL23Idx = plotIdx( cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))> -.418 )
plotL4Idx = plotIdx(cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))< -.418 )
plotL5Idx = plotIdx(cellfun(@(x)x(3),S.recordingLocation([plotUserData{:}]))< -.588)

%plotFarIdx = plotIdx(~(cellfun(@(x)x,S..recordingLocation([plotUserData{:}]))> -.588 & cellfun(@(x)x(3),S..recordingLocation([plotUserData{:}]))< -.418 ))
    
set(plotL23Idx,'color','k')
set(plotL4Idx,'color','r')
set(plotL5Idx,'color','g')

%%
% figure(4);clf;set(gcf,'defaultlinemarkersize',8);hold on
% for i = touchCA
%     if SU.recordingLocation{i}(3) > -.418
%         plot(CA.csumNorm{i},'k');
%     elseif SU.recordingLocation{i}(3) < -.418 & SU.recordingLocation{i}(3) > -.588
%         plot(CA.csumNorm{i},'r');
%     else
%         plot(CA.csumNorm{i},'g');
%     end
% end
% ylabel('Normalized added spikes')
% xlabel('Time from touch (ms)')

figure(6);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchCA
    if SU.recordingLocation{i}(3) > -.418
        plot(CA.csum{i}*.001,'k');
    elseif SU.recordingLocation{i}(3) < -.418 & SU.recordingLocation{i}(3) > -.588
        plot(CA.csum{i}*.001,'r');
    else
        plot(CA.csum{i}*.001,'g');
    end
end
ylabel('Total added spikes')
xlabel('Time from touch (ms)')

figure(5);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchSi
    if S.recordingLocation{i}(3) > -.418
        plot(Si.csumNorm{i},'k');
    elseif S.recordingLocation{i}(3) < -.418 & S.recordingLocation{i}(3) > -.588
        plot(Si.csumNorm{i},'r');
    else
        plot(Si.csumNorm{i},'g');
    end
end
ylabel('Normalized added spikes')
xlabel('Time from touch (ms)')

figure(7);clf;set(gcf,'defaultlinemarkersize',8);hold on
for i = touchSi
    if S.recordingLocation{i}(3) > -.418
        plot(Si.csum{i}*.001,'k');
    elseif S.recordingLocation{i}(3) < -.418 & S.recordingLocation{i}(3) > -.588
        plot(Si.csum{i}*.001,'r');
    else
        plot(Si.csum{i}*.001,'g');
    end
end
ylabel('Total added spikes')
xlabel('Time from touch (ms)')
% %%
% f = fit(x,y,'exp1')
% plot(f,x,y)