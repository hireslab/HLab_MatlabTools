function [sortSR sortAcc binBounds] = accelVsSpikeRate(T, contacts, includeTime, synapticDelay)
if nargin == 2;
    
    includeTime = [182 2050]; % ms
    synapticDelay = 10; % ms
end

if nargin == 3;
        synapticDelay = 10; % ms
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


t = includeTime(1):includeTime(2);

xAcc = [];
xSR = cell(length(T.cellNum),1);
sortSR = cell(length(T.cellNum),1);

% Get velocity
display('Getting Velocity')
acc = getAccel(T,noConTIN,5);
smoothSR = spikeSmooth(T, 10);


if ismember('shanksTrial',fieldnames(T.trials{1}))

for tNum = noConTIN
    xAcc = cat(1,xAcc,acc{tNum}(t(t<=length(acc{tNum})))');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(t+synapticDelay));
    end
end
%%
% colors = prism(length(T.cellNum))
% figure(14);clf;hold on;
display('Sorting Results')

for cNum = 1:length(T.cellNum);


%   [sortSR{cNum} sortAcc binBounds]=binslin(xAcc, xSR{cNum}, 'equalN', 1e5 * [-1.5 -.5 -.1 .1 .5 1.5]);% 20);
  [sortSR{cNum} sortAcc binBounds]=binslin(xAcc, xSR{cNum}, 'equalN', 9);%1e5 * [-1.5 -.5 -.1 .1 .5 1.5]);% 20);
  
  
%   x = cellfun(@mean,sortVel);
%   y = cellfun(@mean,sortSR);
%   plot(x,y,'-','Color',colors(cNum,:))
end

elseif   ismember('spikesTrial',fieldnames(T.trials{1}))

    for tNum = noConTIN
    xAcc = cat(1,xAcc,acc{tNum}(t(t<=length(acc{tNum})))');
    for cNum = 1;
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(t+synapticDelay));
    end
    end

for cNum = 1;


%   [sortSR{cNum} sortAcc binBounds]=binslin(xAcc, xSR{cNum}, 'equalN', 1e5 * [-1.5 -.5 -.1 .1 .5 1.5]);% 20);
  [sortSR{cNum} sortAcc binBounds]=binslin(xAcc, xSR{cNum}, 'equalN', 9);%1e5 * [-1.5 -.5 -.1 .1 .5 1.5]);% 20);
  
  
%   x = cellfun(@mean,sortVel);
%   y = cellfun(@mean,sortSR);
%   plot(x,y,'-','Color',colors(cNum,:))
end
end
  