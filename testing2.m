% Determine the relative impact of one variable on spike rate vs. another,
% with a t = 15ms delay following the input.
IOarray = [];
spikewindow = 10; %ms
delay = [10 20]; %ms
tlim = [0 .8];
smoothWindow = 5; %frames

for k=2:155

% Access the timestamps

inds = find(T.trials{k}.whiskerTrial.time{1} > tlim(1) & T.trials{k}.whiskerTrial.time{1} < tlim(2));
time = T.trials{k}.whiskerTrial.time{1}(inds);

% inds are only used when getting data directly out of the T structure,
% when calculating from extracted data (ie xV), then inds have all ready
% been taken into account.

xY = T.trials{k}.whiskerTrial.follicleCoordsY{1}(inds);
xP = T.trials{k}.whiskerTrial.thetaAtBase{1}(inds);
xV = smooth(diff([0 xP]) ./ diff([0 time]),smoothWindow);
xA = smooth(diff([0 xV']) ./ diff([0 time]),smoothWindow);
xM = U.AH27.contacts{k}.M0combo{1}(inds);

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

IOarray = cat(1,IOarray,[...
    xY(smoothWindow:end-smoothWindow)',...
    xP(smoothWindow:end-smoothWindow)',...
    xV(smoothWindow:end-smoothWindow) ,...
    xA(smoothWindow:end-smoothWindow) ,...
    xM(smoothWindow:end-smoothWindow)',...
    mean(tmp,2)]);

end
%     plot(y1(:,1),smooth(y1(:,4),100))
%     subplot(2,3,5)
%     plot(y2(:,2),smooth(y2(:,4),100))
%     subplot(2,3,6)
%     plot(y3(:,3),smooth(y3(:,4),100))
figure(10)
    
    [sorted sortedBy binBounds] = binslin(IOarray(:,1), IOarray(:,6), 'equalN',101);
    subplot(2,3,1)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    [sorted sortedBy binBounds] = binslin(IOarray(:,2), IOarray(:,6), 'equalN',101);
    subplot(2,3,2)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    [sorted sortedBy binBounds] = binslin(IOarray(:,3), IOarray(:,6), 'equalN',101);
    subplot(2,3,3)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    [sorted sortedBy binBounds] = binslin(IOarray(:,4), IOarray(:,6), 'equalN',101);
    subplot(2,3,4)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    [sorted sortedBy binBounds] = binslin(IOarray(:,5), IOarray(:,6), 'equalN',101);
    subplot(2,3,5)
    plot(mean([binBounds(1:end-1);binBounds(2:end)]), cellfun(@mean,sorted))
    
    %%
    

    % Holding one input constant, look at tuning of spike rate in response
    % to a second variable.
nInputs    = 5;
nChunks    = 3;
%cmap       = zeros(3);
cmap       = hsv(nChunks);


chunk=cell(nChunks,nInputs);

    for j=1:nInputs
    
inputSort  = j


titleGraph = {'Follicle', 'Theta', 'Velocity', 'Acceleration', 'Moment'}
figure(j)
set(gcf,'Name',['Constant ' titleGraph{inputSort}])

%for i = round(nChunks*.25):round(nChunks*.75)

    for i      = 2:nChunks-1
    smoothWind = 300;
    sind       = round(smoothWind/2);
    
    [sorted sortedBy binBounds binInds{j}] = binslinInds(IOarray(:,inputSort), IOarray(:,6), 'equalN',nChunks);
    
    %binInds2{j}{1:3}
    subplot(2,3,1);
    hold on
    plot(IOarray(binInds{j}{i},inputSort),'.','color',cmap(i,:));
    title('Constant Input Bands')
    xlabel('Points')
    ylabel('Input Level')
    
    chunk{i,j}.y = IOarray(binInds{j}{i},1);
    chunk{i,j}.p = IOarray(binInds{j}{i},2);
    chunk{i,j}.v = IOarray(binInds{j}{i},3);
    chunk{i,j}.a = IOarray(binInds{j}{i},4);
    chunk{i,j}.m = IOarray(binInds{j}{i},5);
    chunk{i,j}.s = 1000*IOarray(binInds{j}{i},6);
    
    
    chunk{i,j}.ys = sortrows([chunk{i,j}.y,chunk{i,j}.s],1);
    ss          = smooth(chunk{i,j}.ys(:,2),smoothWind);
    
    subplot(2,3,2)
    hold on
    plot(chunk{i,j}.ys(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Follicle')
    ylabel('Spike Rate (spk/s)')

    chunk{i,j}.ps = sortrows([chunk{i,j}.p,chunk{i,j}.s],1);
    ss          = smooth(chunk{i,j}.ps(:,2),smoothWind);
    
    subplot(2,3,3)
    hold on
    plot(chunk{i,j}.ps(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Theta')
    ylabel('Spike Rate (spk/s)')
    

    chunk{i,j}.vs = sortrows([chunk{i,j}.v,chunk{i,j}.s],1);
    ss          = smooth(chunk{i,j}.vs(:,2),smoothWind);
    
    subplot(2,3,4)
    hold on
    plot(chunk{i,j}.vs(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Velocity')
    ylabel('Spike Rate (spk/s)')
    

    chunk{i,j}.as = sortrows([chunk{i,j}.a,chunk{i,j}.s],1);
    ss          = smooth(chunk{i,j}.as(:,2),smoothWind);
    
    subplot(2,3,5)
    hold on
    plot(chunk{i,j}.as(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Acceleration')
    ylabel('Spike Rate (spk/s)')
    
    
    chunk{i,j}.ms = sortrows([chunk{i,j}.m,chunk{i,j}.s],1);
    ss          = smooth(chunk{i,j}.ms(:,2),smoothWind);
    
    subplot(2,3,6)
    hold on
    plot(chunk{i,j}.ms(sind:end-sind,1),ss(sind:end-sind),'color',cmap(i,:))
    title('Moment')
    ylabel('Spike Rate (spk/s)')
    end
    end
    
    
%%  Single Variable
xi = round(nChunks/2)

% Logical indexes of median band for each variable

IOLarray = logical(zeros(size(IOarray)));
for j=1:5
    IOLarray(binInds{j}{xi},j) = 1;
end

% Select median constant bands in IOarray and sort by the variable
chunkX.xy = sortrows(IOarray(logical(IOLarray(:,2).*IOLarray(:,3).*IOLarray(:,4).*IOLarray(:,5)),:),1);
chunkX.xp = sortrows(IOarray(logical(IOLarray(:,1).*IOLarray(:,3).*IOLarray(:,4).*IOLarray(:,5)),:),2);
chunkX.xv = sortrows(IOarray(logical(IOLarray(:,1).*IOLarray(:,2).*IOLarray(:,4).*IOLarray(:,5)),:),3);
chunkX.xa = sortrows(IOarray(logical(IOLarray(:,1).*IOLarray(:,2).*IOLarray(:,3).*IOLarray(:,5)),:),4);
chunkX.xm = sortrows(IOarray(logical(IOLarray(:,1).*IOLarray(:,2).*IOLarray(:,3).*IOLarray(:,4)),:),5);


figure(7);

subplot(2,3,1);
plot(chunkX.xy(:,1),smooth(chunkX.xy(:,6),300))

subplot(2,3,2);
plot(chunkX.xp(:,2),smooth(chunkX.xp(:,6),300))

subplot(2,3,3);
plot(chunkX.xv(:,3),smooth(chunkX.xv(:,6),300))

subplot(2,3,4);
plot(chunkX.xa(:,4),smooth(chunkX.xa(:,6),300))

subplot(2,3,5);
plot(chunkX.xm(:,5),smooth(chunkX.xm(:,6),300))
    


% pick out the middle 50% most constant chunks
% tmp = [];
% for i = round(nChunks*.25):round(nChunks*.75)
% 
% cellfun(@mean(x).as,chunk)

%%
tmp=[]
for i=delay(1):delay(2)
    tmp(:,i+1-delay(1)) = 
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