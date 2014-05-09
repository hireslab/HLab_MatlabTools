function [sortSR sortVel binBounds] = velocityVsSpikeRate(T, contacts, includeTime, synapticDelay)
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

xVel = [];
xSR = cell(length(T.cellNum),1);
sortSR = cell(length(T.cellNum),1);

% Get velocity
display('Getting Velocity')
vel = getVelocity(T,noConTIN,5)
smoothSR = spikeSmooth(T, 20);


for tNum = noConTIN
    xVel = cat(1,xVel,vel{tNum}(t)');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(t+synapticDelay));
    end
end
%%
% colors = prism(length(T.cellNum))
% figure(14);clf;hold on;
display('Sorting Results')
for cNum = 1:length(T.cellNum);


  [sortSR{cNum} sortVel binBounds]=binslin(xVel, xSR{cNum}, 'equalN', [-15 -5 -1 1 5 15]*100);
  %[sortSR{cNum} sortVel binBounds]=binslin(xVel, xSR{cNum}, 'equalN', 9);%[-15 -5 -1 1 5 15]*100);
  
  
%   x = cellfun(@mean,sortVel);
%   y = cellfun(@mean,sortSR);
%   plot(x,y,'-','Color',colors(cNum,:))
end

  