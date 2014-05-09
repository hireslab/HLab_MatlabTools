function [sortSR sortM0 binBounds] = M0VsSpikeRateConOnly(T, contacts, includeTime, synapticDelay)
if nargin == 2;
    
    includeTime = [570 1500]; % ms
    synapticDelay = 15; % ms
end

if nargin == 3;
        synapticDelay = 15; % ms
end


% Velocity vs. SpikeRate
whiskerTIN  = find(T.whiskerTrialInds); % index of whisking trials
ConTIN    = whiskerTIN(cellfun(@(x)x.trialContactType >= 1,contacts(whiskerTIN)));
ConTIN    = ConTIN(ConTIN < find(T.hitTrialInds,1,'last')); % Truncate trials after last hit trial

timeWindow  = [.01 .050];
maxConNum   = 10;
proConSR    ={};
useFlag     ={};
csind       ={};
cind        ={};




xM0 = [];
xSR = cell(length(T.cellNum),1);
sortSR = cell(length(T.cellNum),1);

% Get velocity
display('Getting M0')
smoothSR = spikeSmooth(T, 20);


for tNum = ConTIN
    t = contacts{tNum}.contactInds{1}(contacts{tNum}.contactInds{1} >= includeTime(1) & contacts{tNum}.contactInds{1} <= includeTime(2));
    xM0 = cat(1,xM0,contacts{tNum}.M0comboAdj{1}(t)');
    for cNum = 1:length(T.cellNum);
        xSR{cNum} = cat(1,xSR{cNum},smoothSR{cNum}{tNum}(t+synapticDelay));
    end
end
%%
colors = prism(length(T.cellNum))
% figure;clf;hold on;
display('Sorting Results')
for cNum = 1:length(T.cellNum);


  [sortSR{cNum} sortM0 binBounds]=binslin(xM0, xSR{cNum}, 'equalN', 9);%1e-7*[-2 -1 -.5 -.1 .1 .5 1 2]);
  
%   
%   x = cellfun(@mean,sortM0);
%   y = cellfun(@mean,sortSR{cNum});
%   plot(x,y,'-','Color',colors(cNum,:))
end

  