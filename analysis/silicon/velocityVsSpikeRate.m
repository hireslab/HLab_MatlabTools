function [sortSR sortVel binBounds] = velocityVsSpikeRate(T, contacts, includeTime, synapticDelay)
if nargin == 2;
    
    includeTime = [150 2000]; % ms
    synapticDelay = 10; % ms
end

if nargin == 3;
        synapticDelay = 10; % ms
end


% Velocity vs. SpikeRate
whiskerTIN  = find(T.whiskerTrialInds); % index of whisking trials
noConTIN    = whiskerTIN(cellfun(@(x)x.trialContactType == 0,contacts(whiskerTIN)));
noConTIN    = noConTIN(noConTIN < find(T.hitTrialInds,1,'last')); % Truncate trials after last hit trial
ConTIN    = whiskerTIN(cellfun(@(x)x.trialContactType > 0,contacts(whiskerTIN)));
ConTIN    = ConTIN(ConTIN < find(T.hitTrialInds,1,'last')); % Truncate trials after last hit trial

timeWindow  = [.01 .050];
maxConNum   = 10;
proConSR    ={};
useFlag     ={};
csind       ={};
cind        ={};


noConincludeTime = [150 2000]; % ms
tNoCon = noConincludeTime(1):noConincludeTime(2);
conincludeTime = [150 600]; % ms
tCon = conincludeTime(1):conincludeTime(2);

xVel = [];
xSR = cell(length(T.cellNum),1);
sortSR = cell(length(T.cellNum),1);

% Get velocity
display('Getting Velocity')
vel = getVelocity(T,[noConTIN ConTIN],5)
smoothSR = spikeSmooth(T, 20);


for tNum = noConTIN
    xVel = cat(1,xVel,vel{tNum}(tNoCon)');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(tNoCon+synapticDelay));
    end
end

for tNum = ConTIN
    xVel = cat(1,xVel,vel{tNum}(tCon)');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(tCon+synapticDelay));
    end
end
%%
% colors = prism(length(T.cellNum))
% figure(14);clf;hold on;
display('Sorting Results')
for cNum = 1:length(T.cellNum);


   [sortSR{cNum} sortVel binBounds]=binslin(xVel, xSR{cNum}, 'equalN', [-15 -5 -1 1 5 15]*100);
%  [sortSR{cNum} sortVel binBounds]=binslin(xVel, xSR{cNum}, 'equalN', 9);%[-15 -5 -1 1 5 15]*100);
  
  
%   x = cellfun(@mean,sortVel);
%   y = cellfun(@mean,sortSR);
%   plot(x,y,'-','Color',colors(cNum,:))
end

  