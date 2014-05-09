figSaveDir = '/Volumes/MONOLITH/Silicon/Figures/'
dirCTA = '/Lab/Silicon/CTA'
dirClust = 'Lab/Silicon/Clusters'

animalNames = {'ANM140536','ANM144441','ANM144442','ANM144443','ANM144444'};
    
cd(dirCTA)

CTAs = dir('CTA*');

for j = 21
    load(CTAs(j).name)

    anm = find(strcmpi(T.mouseName,animalNames));
    sessions = unique(S.session(find(strcmpi(T.mouseName,S.anm))));


    ind = find(cellfun(@(x)strcmpi(T.sessionName(1:16),x(1:16)),S.filename));
            T.recordingLocation = [];

    for i = 1:length(ind)
        sessionNum = find(strcmpi(sessions, S.session{ind(i)}))

        
        % Update CTA array with cell location information
        T.depth(i) = M.depth{anm}((sessionNum-1)*4+S.shank{ind(i)}) - depthCorr(S.padmax{ind(i)});
        T.recordingLocation(i,:) = [M.L{anm}((sessionNum-1)*4+S.shank{ind(i)},:) T.depth(i)/1000];
   
        S.dist{ind(i)} = M.dist{anm}((sessionNum-1)*4+S.shank{ind(i)},:);
        S.depth{ind(i)} = M.depth{anm}((sessionNum-1)*4+S.shank{ind(i)}) - depthCorr(S.padmax{ind(i)});
        S.recordingLocation{ind(i)} = [M.L{anm}((sessionNum-1)*4+S.shank{ind(i)},:) T.depth(i)/1000];

        
    end
    

    T.whiskerTrialTimeOffset = -.49;
    
    
save(CTAs(j).name,'T')
end
        %%
%         for i =1:4
%             cind{i} = find(cellfun(@(x)x(i)>0,S.latency))
%         end
%     colors = jet(112);  
%     
%     value = 1./cellfun(@(x)x(1),S.latency(cind{1}))
    
        value = 10*cellfun(@(x)log2(x(1)+1),S.modulationSR)+50
         coloring = round(100*value/ceil(max(value)))+1
        value = (max(S.M0ConMod{1}{1}(:,1))-min(S.M0ConMod{1}{2}(:,1)))/(S.M0ConMod{1}{3}(1))
        
        %value =  50*cellfun(@(x)(x(1,1)-x(1,2))/(x(1,1)+x(1,2)),S.windowSR)+50
   % coloring = round(value)
    
    %%
        figure(10); cla;hold on
        
        colors = jet(112);
        for i=1:148
            
            value(i) = (max(S.M0ConMod{i}{1}(:,1))-min(S.M0ConMod{i}{2}(:,1)))/(S.M0ConMod{i}{3}(1))
        end
        
            coloring{i} = round(100*value{i}/ceil(max(value{i})))+1


            try
            plot3(S.recordingLocation{i}(1)+(rand-.5)*.05,S.recordingLocation{i}(2)+(rand-.5)*.05,-S.recordingLocation{i}(3)+(rand-.5)*.04,'.',...
                'Color', colors(coloring(i),:), 'MarkerSize',15)
            end
        end
        t = 0:.1:2*pi
        for i=2:8
                    plot3(.13*sin(t),.13*cos(t),repmat(-.1*i,length(t)),'r')
        end

        axis equal
        grid on 
        
%% Plot Latencies
figure(1);clf; hold on
colors = {'b','r','b','r'}
for i=1:3
    
   plot(cellfun(@(x)x,S.depth(cind{i})),cellfun(@(x)x(i),S.latency(cind{i})),[colors{i} '.'])
   x = cellfun(@(x)x,S.depth(cind{i}))
    y = cellfun(@(x)x(i),S.latency(cind{i}))

    sorty = sortrows([x' y'])

    plot(sort(x),smooth(sort(x), sorty(:,2),30,'rloess'),colors{i},'LineWidth',2)
end
figure(2);clf;
subplot(1,3,1)

hold on
colorgray = gray(73)
colormap(gray(73))
for i = [1 2]
    for j=cind{i}
    plot(S.depth{j},1000*S.latency{j}(i),[colors{i} 'o'],'LineWidth',2,'MarkerFaceColor',colorgray(round(100*S.dist{j}),:))
    end
end
axis([ 0 700 0 85])
ylabel('Spike Latency from Contact Initiation')
title('Protraction Touches')

subplot(1,3,2)
hold on
for i = [3 4]
    for j=cind{i}
    plot(S.depth{j},1000*S.latency{j}(i),[colors{i} 'o'],'LineWidth',2,'MarkerFaceColor',colorgray(round(100*S.dist{j}),:))
    end
end
axis([ 0 700 0 85])
xlabel('Depth from pia (um)')
title('Retraction Touches')
subplot(1,3,3)
colorbar('YTick',[15 30 45 60])
set(gcf,'Position',[100 100 1500 400],'PaperOrientation','portrait','PaperPosition',[0 0 15 5], 'PaperSize', [5 15])


  
print('-depsc', 'Q:\Silicon\Figures\LatencySi')           
            %%
            
            depth =  cellfun(@(x)x,S.depth(1:length(S.baselineSR)));
            dist = cellfun(@(x)x,S.dist(1:length(S.baselineSR)));
            baselineSR = cellfun(@(x)nanmean(x([1 5])),S.baselineSR);
            windowSR = cellfun(@(x)x(1),S.windowSR)
            modulation = cellfun(@(x)x(1),S.modulationSR)
            adaptation = cellfun(@(x)x(2,1),S.adaptationSR)
            
%% Spike Rates vs. Depth
cind = depth > 100%depth < 600 & depth > 400

x = depth(cind)
figure(200); clf
touchLabel = {'Baseline', '1st contact', 'Second Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}


for k=1:3;
    y=[];


    y(:,1) = cellfun(@(x)nanmean(x(k)),S.baselineSR)
    y(:,2) = cellfun(@(x)x(k,1),S.windowSR(cind))';
    y(:,3) = cellfun(@(x)x(k,2),S.windowSR(cind))';

    sorty = sortrows([x' y])



    for i = 1:3
        subplot(3,3,i+3*(k-1))
        hold on
        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'k.')
        title([touchLabel{i} ' / ' dirLabel{k}])
        xlim([100 700])
        ylim([0 120])
    end
end
subplot(3,3,4)
ylabel('SpikeRate (spk/s)')
subplot(3,3,8)
xlabel('Depth (um)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 15 10], 'PaperSize', [10 15])

print(gcf, '-depsc', [figSaveDir 'SpikeRateVsDepth'])
%% Modulation Level vs. Depth
depth = cellfun(@(x)x,S.depth)
cind = depth > 100%depth < 600 & depth > 400

x = depth(cind)
figure(201); clf
touchLabel = {'First contact', 'Second Contact','Third Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}


for k=1:3; % Contact Type
    y=[];


    y(:,1) = cellfun(@(x)log2(x(1,k)),S.modulationSR);
    y(:,2) = cellfun(@(x)log2(x(2,k)),S.modulationSR);
    y(:,3) = cellfun(@(x)log2(x(3,k)),S.modulationSR);

    sorty = sortrows([x' y])



    for i = 1:2
        subplot(3,2,i+2*(k-1))
        hold on
        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'k.')
        plot([100 700],[0 0],'b--')
        grid on
        title([touchLabel{i} ' / ' dirLabel{k}])
        xlim([100 700])
        ylim([-8 8])
    end
end
subplot(3,2,3)
ylabel('Modulation = log2 (Touch / Baseline SpikeRate)')
subplot(3,2,5)
xlabel('Depth (um)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 15 10], 'PaperSize', [10 15])

print(gcf, '-depsc', [figSaveDir 'ModulationVsDepth'])

%% Direction Selectivity vs. Depth
cind = depth > 100%depth < 600 & depth > 400

x = depth(cind)
figure(201); clf
touchLabel = {'First contact', 'Second Contact','Third Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}


for k=1; % Contact Type
    y=[];


    y(:,1) = cellfun(@(x)(x(1,1)-x(1,2))/(x(1,1)+x(1,2)),S.windowSR);
    y(:,1) = cellfun(@(x)(x(1,1)-x(1,2))/(x(1,1)+x(1,2)),S.windowSR);

    sorty = sortrows([x' y])



    for i = 1
        subplot(1,1,i+2*(k-1))
        hold on
        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'k.')
        plot([100 700],[0 0],'b--')
        grid on
        title([touchLabel{i} ' / Direction Selectivity'])
        xlim([100 700])
        ylim([-1.1 1.1])
    end
end
subplot(1,1,1)
ylabel('Direction Selectivity = Pro-Ret / Pro+Ret')
subplot(1,1,1)
xlabel('Depth (um)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 15 10], 'PaperSize', [10 15])

print(gcf, '-depsc', [figSaveDir 'DirectionVsDepth'])
%% Adaptation vs. Depth
cind = depth > 100%depth < 600 & depth > 400

x = depth(cind)
figure(201); clf
touchLabel = {'First contact', 'Second Contact','Third Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}

dColor=jet(70)

for k=1; % Contact Type
    y=[];


    y(:,1) = cellfun(@(x)x(2,1),S.adaptationSR);

    sorty = sortrows([x' y])



    for i = 1
        subplot(1,1,i+2*(k-1))
        hold on
%        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'ko','MarkerSize',6,'MarkerFaceColor',dColor(uint8(10*log2(nanmean(S.baselineSR{cNum})))+1,:))
        plot([100 700],[1 1],'b--')
        grid on
        title(['Adaptation between 1st and 2nd GoPro Contact'])
        xlim([100 700])
        ylim([0 3])
    end
end
subplot(1,1,1)
ylabel({'Adaptation ratio','2nd touch / 1st touch Spike rate)'})
subplot(1,1,1)
xlabel('Depth (um)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 6 6], 'PaperSize', [6 6])

print(gcf, '-depsc', [figSaveDir 'AdaptationVsDepth'])

%% Spike Rates vs. Distance
cind = depth > 100%depth < 600 & depth > 400

x = dist(cind)
figure(200); clf
touchLabel = {'Baseline', '1st contact', 'Second Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}


for k=1:3;
    y=[];


    y(:,1) = cellfun(@(x)nanmean(x(k)),S.baselineSR)
    y(:,2) = cellfun(@(x)x(k,1),S.windowSR(cind))';
    y(:,3) = cellfun(@(x)x(k,2),S.windowSR(cind))';

    sorty = sortrows([x' y])



    for i = 1:3
        subplot(3,3,i+3*(k-1))
        hold on
        plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'k.')
        title([touchLabel{i} ' / ' dirLabel{k}])
        xlim([0 .75])
        ylim([0 120])
    end
end
subplot(3,3,4)
ylabel('SpikeRate (spk/s)')
subplot(3,3,8)
xlabel('Distance from C2 center (mm)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 15 10], 'PaperSize', [10 15])

print(gcf, '-depsc', [figSaveDir 'SpikeRateVsDistance']);

%% Modulation Level vs. Dist
cind = depth > 100%depth < 600 & depth > 400

x = dist(cind)
figure(201); clf
touchLabel = {'First contact', 'Second Contact','Third Contact'}
dirLabel = {'Go Protraction', 'Go Retraction', 'NoGo Protraction'}


for k=1:3; % Contact Type
    y=[];


    y(:,1) = cellfun(@(x)log2(x(1,k)),S.modulationSR);
    y(:,2) = cellfun(@(x)log2(x(2,k)),S.modulationSR);
    y(:,3) = cellfun(@(x)log2(x(3,k)),S.modulationSR);

    sorty = sortrows([x' y])



    for i = 1:2
        subplot(3,2,i+2*(k-1))
        hold on
       % plot(sort(x),smooth(sort(x)', sorty(:,i+1),40),'r','LineWidth',2)

        plot(x,y(:,i),'k.')
        plot([0 .75],[0 0],'b--')
        grid on
        title([touchLabel{i} ' / ' dirLabel{k}])
        xlim([0 .75])
        ylim([-8 8])
    end
end
subplot(3,2,3)
ylabel('Modulation = log2 (Touch / Baseline SpikeRate)')
subplot(3,2,5)
xlabel('Distance from C2 (mm)')
set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 15 10], 'PaperSize', [10 15])

print(gcf, '-depsc', [figSaveDir 'ModulationVsDist'])
