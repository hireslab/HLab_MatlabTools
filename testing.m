% Determine the relative impact of one variable on spike rate vs. another,
% with a t = 15ms delay following the input.
IOarray = [];
spikewindow = 10; %ms
delay = [10 20]; %ms
tlim = [0 0.8];
smoothWindow = 5; %frames

for k=2:155

% Access the timestamps

inds = find(T.trials{k}.whiskerTrial.time{1} > tlim(1) & T.trials{k}.whiskerTrial.time{1} < tlim(2));
time = T.trials{k}.whiskerTrial.time{1}(inds);

% inds are only used when getting data directly out of the T structure,
% when calculating from extracted data (ie xV), then inds have all ready
% been taken into account.

xP = T.trials{k}.whiskerTrial.thetaAtBase{1}(inds);
xV = smooth(diff([0 xP]) ./ diff([0 time]),smoothWindow);
xA = smooth(diff([0 xV']) ./ diff([0 time]),smoothWindow);


spikeIndex=zeros(T.trials{k}.spikesTrial.sweepLengthInSamples/10,1);
% Calculate the spike rate across trials
    try
        spikeIndex(round(T.trials{k}.spikesTrial.spikeTimes/10))=1;
    catch
    end

% SpikeRateArray between the delay periods
tmp=[];
for i=delay(1):delay(2);
    tmp(:,i+1-delay(1))=spikeIndex(round(time(smoothWindow:end-smoothWindow)*1000+i));
end

% Array where there is input data on top rows and delay shifted spike presence in bottom row.  
% Cat the arrays across trials

IOarray = cat(1,IOarray,[xP(smoothWindow:end-smoothWindow)',...
    xV(smoothWindow:end-smoothWindow),...
    xA(smoothWindow:end-smoothWindow),...
    mean(tmp,2)]);

end

y1 = sortrows(IOarray, 1);
y2 = sortrows(IOarray, 2);
y3 = sortrows(IOarray, 3);
    % Access the input data

    figure
    subplot(2,3,1)
    plot(y1(:,1))
    subplot(2,3,2)
    plot(y1(:,1),smooth(abs(y1(:,2)),25))
    subplot(2,3,3)
    plot(y1(:,1),smooth(abs(y1(:,3)),25))
    subplot(2,3,4)
%     plot(y1(:,1),smooth(y1(:,4),100))
%     subplot(2,3,5)
%     plot(y2(:,2),smooth(y2(:,4),100))
%     subplot(2,3,6)
%     plot(y3(:,3),smooth(y3(:,4),100))

    
    [sorted sortedBy binBounds] = binslin(IOarray(:,1), IOarray(:,4), 'equalN',101)
    subplot(2,3,4)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
        [sorted sortedBy binBounds] = binslin(IOarray(:,2), IOarray(:,4), 'equalN',101)
    subplot(2,3,5)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
        [sorted sortedBy binBounds] = binslin(IOarray(:,3), IOarray(:,4), 'equalN',101)
    subplot(2,3,6)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    %%
    

    % Holding one input constant, look at tuning of spike rate in response
    % to a second variable.
for j=1:3
    
inputSort  = j
nChunks    = 15
cmap       = jet(nChunks);

titleGraph = {'Position', 'Velocity', 'Acceleration'}
figure
set(gcf,'Name',['Constant ' titleGraph{inputSort}])

    for i      = 2:nChunks-1
    smoothWind = 300;
    sind       = round(smoothWind/2);
    
    [sorted sortedBy binBounds binInds] = binslinInds(IOarray(:,inputSort), IOarray(:,4), 'equalN',nChunks);
    
    subplot(2,2,1);
    hold on
    plot(IOarray(binInds{i},inputSort),'color',cmap(i,:));
    title('Constant Input Bands')
    xlabel('Points')
    ylabel('Input Level')
    chunk{i}.p = IOarray(binInds{i},1);
    chunk{i}.v = IOarray(binInds{i},2);
    chunk{i}.a = IOarray(binInds{i},3);
    chunk{i}.s = 1000*IOarray(binInds{i},4);
    

    chunk{i}.ps = sortrows([chunk{i}.p,chunk{i}.s],1);
    ss          = smooth(chunk{i}.ps(:,2),smoothWind);
    
    subplot(2,2,2)
    hold on
    plot(chunk{i}.ps(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Position')
    ylabel('Spike Rate (spk/s)')
    

    chunk{i}.vs = sortrows([chunk{i}.v,chunk{i}.s],1);
    ss          = smooth(chunk{i}.vs(:,2),smoothWind);
    
    subplot(2,2,3)
    hold on
    plot(chunk{i}.vs(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Velocity')
    ylabel('Spike Rate (spk/s)')
    

    chunk{i}.as = sortrows([chunk{i}.a,chunk{i}.s],1);
    ss          = smooth(chunk{i}.as(:,2),smoothWind);
    
    subplot(2,2,4)
    hold on
    plot(chunk{i}.as(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Acceleration')
    ylabel('Spike Rate (spk/s)')
    end
    end
    
    
%%  Building tuning filters

% pick out the middle 50% most constant chunks

i = round(nChunks*.25):round(nChunks*.75)

%%

% Holding all but one variable constant

    
% Sort input data
% %%
%         xP=cW.thetaAtBase{1};
%         xPos{1}=xP(g.framesUsed);
%         Tuning.position.linear=cat(2,Tuning.position.linear,xPos{1}); 
%         
%         xV=diff([0 xP])./diff([0 time]);
%         xVel{1}=xV(g.framesUsed);
%         Tuning.velocity.linear=cat(2,Tuning.velocity.linear,xVel{1}); 
%         
%         xA=diff([0 xV])./diff([0 time]);
%         xAcc{1}=xA(g.framesUsed);
%         Tuning.acceleration.linear=cat(2,Tuning.acceleration.linear,xAcc{1});   
%         
%         Tuning.M0combo.linear=cat(2,Tuning.M0combo.linear,contacts{k}.M0combo{1}(g.framesUsed));
%         Tuning.Faxial.linear=cat(2,Tuning.Faxial.linear,contacts{k}.FaxialAdj{1}(g.framesUsed));