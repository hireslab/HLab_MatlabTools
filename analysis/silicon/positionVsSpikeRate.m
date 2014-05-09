function [sortSR sortPos binBounds] = positionVsSpikeRate(T, contacts, includeTime, synapticDelay)
if nargin == 2;
    
    includeTime = [50 4000]; % ms
    synapticDelay = 15; % ms
end

if nargin == 3;
        synapticDelay = 15; % ms
end


% Velocity vs. SpikeRate
whiskerTIN  = find(T.whiskerTrialInds); % index of whisking trials
noConTIN    = whiskerTIN(cellfun(@(x)x.trialContactType == 0,contacts(whiskerTIN)));
noConTIN    = noConTIN(noConTIN < find(T.hitTrialInds,1,'last')); % Truncate trials after last hit trial

timeWindow  = [.01 .050];
maxConNum   = 10;
proConSR    ={};
useFlag     ={};
csind       ={};
cind        ={};


includeTime = [50 4000]; % ms
t = includeTime(1):includeTime(2);

xPos = [];
xSR = cell(length(T.cellNum),1);
sortSR = cell(length(T.cellNum),1);

% Get velocity
display('Getting Position')
pos = getPosition(T,noConTIN)
smoothSR = spikeSmooth(T, 20);


for tNum = noConTIN
    xPos = cat(1,xPos,pos{tNum}(t)');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(t+synapticDelay));
    end
end
%%
% colors = prism(length(T.cellNum))
% figure(14);clf;hold on;
display('Sorting Results')
for cNum = 1:length(T.cellNum);


%   [sortSR{cNum} sortVel binBounds]=binslin(xVel, xSR{cNum}, 'equalN', [-15 -5 -1 1 5 15]*100);
  [sortSR{cNum} sortPos binBounds]=binslin(xPos, xSR{cNum},'equalN',7);
  
  
%   x = cellfun(@mean,sortVel);
%   y = cellfun(@mean,sortSR);
%   plot(x,y,'-','Color',colors(cNum,:))
end

  