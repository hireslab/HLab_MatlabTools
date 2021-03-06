% This is supposed to plot all timepoints of trial index k, with curvature
% on the x-axis and distance to pole on the y-axis. Contact scored
% timepoints are in green, non-contact points in black.


% To implement, modes where we just look at the precontact period, the 1st
% contact to decision period and the post decision period.  Arbitratry time 
% periods.
% Option to exclude contact periods from the position, velocity and acceleration
% analysis.


function paramBrowserSi(array, contacts, params, varargin)
if nargin <4
    if nargin==1
        disp('Contacts data missing, building and assigning to workspace as "contacts"')
        [contacts, params]=autoContactAnalyzerSi(array);
        contactsname = 'contacts';
%        assignin('base','contacts',contacts);
    end
    
    if nargin<=2
        
        
            % Populate parameters with defaults
        params.sweepNum = find(array.whiskerTrialInds,1);
        params.displayType = 'all';
        params.displayTypeMinor = 'none';
        params.arbTimes = [];
        params.trialList = '';
        params.trialRange =  [array.trialNums(1) array.trialNums(end)];
        params.colors = prism(length(array.cellNum));
        params.trialcolors = {'g','r','k','b'};
        params.summarize = 'off';  
        params.touchThresh = [.1 .1 .3 .3]; %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
        params.goProThresh = -10; % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
        params.nogoProThresh = -30; % Mean curvature above this value indicates probable nogo protraction, below it, a nogo retraction trial.
        params.poleOffset = .535; % Time where pole becomes accessible
        params.poleEndOffset = .13; % Time between start of pole exit and inaccessiblity
        params.spikeSynapticOffset = .02; % Estimated synaptic delay for assigning spikes to contact epochs
        params.tid=0; % Trajectory id
        params.framesUsed=1:length(array.trials{find(array.whiskerTrialInds,1)}.whiskerTrial.time{1});
        params.curveMultiplier=1.5;


        
%             'maxBins', 51, 'spikeRateWindow', .05, 'spikeSynapticOffset',0,...
%             'colors',prism(length(array.cellNum)), 'trialcolors', {{'g','r','k','b'}}, 'summarize', 'off');  
%         
 
        % Get mean answer time
        tmp=[];
        for i=1:array.length
            if isempty(array.trials{i}.answerLickTime)==0
                tmp(i)=array.trials{i}.answerLickTime;
            else
                tmp(i)=NaN;
            end
        end
        
    params.meanAnswerTime=nanmean(tmp);
    params.cellNum   = array.cellNum
    params.shankNum  = array.shankNum
    params.trialNums = array.trialNums
    params.arrayname = inputname(1);
        
    end
    
    if  nargin == 1 
         params.contactsname = 'contacts';
    else
        params.contactsname = inputname(2);
        params.arrayname = inputname(1); % Command-line name of this instance of a TrialArray.
    
    end


    % Setup Figure and handles
    hParamBrowserGui = figure('Color','white'); ht = uitoolbar(hParamBrowserGui);
    setappdata(0,'hParamBrowserGui',gcf);
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    h_b=brush(hParamBrowserGui);
    set(h_b,'Color',[1 0 1]);
    
    % Setup pushbuttons
    icon_del   = imread('delete.tif');
    icon_add   = imread('add.png');
    icon_right = imread('arrow-right.png');
    icon_left  = imread('arrow-left.png');
    icon_recalc= imread('refresh.png');
    icon_save  = imread('save.png');
    icon_float = imread('floatingBaseline.tif');
    icon_floatOff = imread('floatingBaselineOff.tif');
    
    bbutton = uipushtool(ht,'CData',icon_left,'TooltipString','Back');
    fbutton = uipushtool(ht,'CData',icon_right,'TooltipString','Forward');
    abutton = uipushtool(ht,'CData',icon_add,'TooltipString','Add Contact','Separator','on');
    dbutton = uipushtool(ht,'CData',icon_del,'TooltipString','Delete Contact');
    rbutton = uipushtool(ht,'CData',icon_recalc,'TooltipString','Recalculate Contact Dependents');
    sbutton = uipushtool(ht,'CData',icon_save,'TooltipString','Delete Contact','Separator','on');

    floatToggle = uitoggletool(ht,'CData',icon_floatOff, 'TooltipString', 'Toggle PreContact Baseline Correction')
    


    % Setup pushbutton callbacks
    set(fbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''next'')'])
    set(bbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''last'')'])
    set(abutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''add'')'])
    set(dbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''del'')'])
    set(dbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''del'')'])
    set(rbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''recalc'')'])
    set(sbutton,'ClickedCallback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''save'')'])
    
    set(floatToggle,'OnCallback',  ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''floatOn'')'])
    set(floatToggle,'OffCallback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''floatOff'')'])


    % Setup menus
    m1=uimenu(hParamBrowserGui,'Label','Time Period','Separator','on');
    uimenu(m1,'Label','All'                          ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''all'')']);
    uimenu(m1,'Label','Contacts Only'                ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''contactsOnly'')']);
    uimenu(m1,'Label','Exclude Contacts'             ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''excludeContacts'')']);
    uimenu(m1,'Label','Pole Presentation to Decision','Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''poleToDecision'')']);
    uimenu(m1,'Label','First Contact to Decision'    ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''contactToDecision'')']);
    uimenu(m1,'Label','Post Decision'                ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''postDecision'')']);
    uimenu(m1,'Label','Post Pole'                    ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''postPole'')']);
    uimenu(m1,'Label','Abritrary Range'              ,'Callback', ['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''arbitrary'')']);

    m2=uimenu(hParamBrowserGui,'Label','Adjust parameters','Separator','on');
    uimenu(m2,'Label','Plots'   ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''adjPlots'')']);
    uimenu(m2,'Label','Spikes'  ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''adjSpikes'')']); 
    uimenu(m2,'Label','Contacts','Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''adjContacts'')']);
    uimenu(m2,'Label','Trial Range','Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''adjTrials'')']);
    
    uimenu(hParamBrowserGui,'Label','Jump to sweep','Separator','on','Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''jumpToSweep'')']);
    
    m3=uimenu(hParamBrowserGui,'Label','Summarize','Separator','on');
    uimenu(m3,'Label','STA'     ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''STA'')']); 
    uimenu(m3,'Label','Clusts'  ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''clusts'')']);
    uimenu(m3,'Label','Tuning'  ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''tuning'')']);
    uimenu(m3,'Label','Contacts','Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''contacts'')']);
    uimenu(m3,'Label','Fit'     ,'Callback',['paramBrowserSi(' params.arrayname ',' params.contactsname ', params,''fit'')']);
    
    
    setappdata(hParamBrowserGui, 'params',params);
    setappdata(hParamBrowserGui, 'contacts', contacts);
    setappdata(hParamBrowserGui, 'array', array);
else
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    params = getappdata(hParamBrowserGui,'params');

    if isempty(params) % Initial call to this method has argument
        params = struct('sweepNum',find(cellfun(@(x) ~isempty(x.whiskerTrial),array.trials),1),'trialList',params.trialNums(cellfun(@(x) ~isempty(x.whiskerTrial),T.trials)),'displayType','all');
    end
    for j = 1:length(varargin);
        argString = varargin{j};
        switch argString
           
            case 'next'
                if params.sweepNum < length(array.trials)
                    params.sweepNum = params.sweepNum + 1;
                end
                
                
            case 'last'
                if params.sweepNum > 1
                    params.sweepNum = params.sweepNum - 1;
                end
                
            case 'add'
                
                toAdd = [];
                try
                  toAdd = find(get(findobj('Tag','t_d'),'BrushData'));
                  display ('Distance Brushing')
                
                end
                try
                    toAdd = params.cropind(logical(get(findobj('Tag','t_cvd'),'BrushData')));
                    display ('CurveVsDistance Brushing')

                end
               
                if ~isempty(toAdd);

                    addContact(toAdd);
                end
                                    contacts = getappdata(getappdata(0,'hParamBrowserGui'),'contacts');

                
            case 'del'
                
                toDel = [];
                try
                  toDel = find(get(findobj('Tag','t_d'),'BrushData'));
                  display ('Distance Brushing')

                end
                try
                    toDel = params.cropind(logical(get(findobj('Tag','t_cvd'),'BrushData')));
                    display ('CurveVsDistance Brushing')

                end
           
                if ~isempty(toDel);
                    delContact(toDel);    
                end
                
                 contacts = getappdata(getappdata(0,'hParamBrowserGui'),'contacts');
                
                
            case 'recalc'
                [contacts params] = autoContactAnalyzerSi(array, params, contacts, 'recalc');
                set(0,'CurrentFigure',hParamBrowserGui);
                
                
            case 'floatOn'
                
                if ~isfield(params,'floatingBaseline');
                   [contacts params] = autoContactAnalyzerSi(array, params, contacts, 'recalc');
                end

                params.floatingBaseline = 1;
                
            case 'floatOff'
                params.floatingBaseline = 0;
                
                
            case 'save'
                assignin('base','contacts',contacts);
                assignin('base','params',params);

                save(['/Lab/Silicon/ConTA/ConTA_' array.sessionName], 'contacts', 'params')
                display('Saved Contacts and Parameters')
                
            case 'jumpToSweep'
                if isempty(params.trialList)
                    nsweeps = array.length;
                    params.trialList = cell(1,nsweeps);
                    for k=1:nsweeps
                        params.trialList{k} = [int2str(k) ': trialNum=' int2str(params.trialNums(k))];
                    end
                end
                [selection,ok]=listdlg('PromptString','Select a sweep:','ListString',...
                    params.trialList,'SelectionMode','single');
                if ~isempty(selection) && ok==1
                    params.sweepNum = selection;
                end
                
            case 'adjPlots'
                prompt = {'Maximum bins for plots'};
                dlg_title = 'Plotting Parameters';
                num_lines = 1;
                def = {num2str(params.maxBins)};
                plotParams = inputdlg(prompt,dlg_title,num_lines,def);
               
                params.maxBins=str2num(plotParams{1});
            
            case 'adjSpikes'
                 prompt = {'Window size of spike integration (s)', 'Estimated synaptic delay between spikes and whiskers (s)'};
                dlg_title = 'Spike Rate Parameters';
                num_lines = 1;
                def = {num2str(params.spikeRateWindow), num2str(params.spikeSynapticOffset)};
                spikeParams = inputdlg(prompt,dlg_title,num_lines,def);                
                params.spikeRateWindow=str2num(spikeParams{1});
                params.spikeSynapticOffset=str2num(spikeParams{2});
                
            case 'adjContacts'
                 prompt = {'Trajectory ID :','Pole delay from onset till in range (s)','Pole delay from offset till out of range (s)',...
                    'Contact distance thresholds (go/pro, go/ret, nogo/pro, nogo/ret)', 'Go pro/ret curvature threshold',...
                    'Nogo pro/ret curvature threshold','Curve Multiplier' };
                dlg_title = 'Contact Parameters';
                num_lines = 1;
                def = {num2str(params.tid), num2str(params.poleOffset), num2str(params.poleEndOffset),...
                    num2str(params.touchThresh), num2str(params.goProThresh),num2str(params.nogoProThresh), num2str(params.curveMultiplier)};
                dlgout = inputdlg(prompt,dlg_title,num_lines,def);

                if ~isempty(dlgout)
                    params.tid= str2num(dlgout{1});
                    params.poleOffset=str2num(dlgout{2});
                    params.poleEndOffset=str2num(dlgout{3});
                    params.touchThresh = str2num(dlgout{4}); %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
                    params.goProThresh = str2num(dlgout{5}); % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
                    params.nogoProThresh = str2num(dlgout{6});
                    params.curveMultiplier = str2num(dlgout{7});

                    disp('Recalculating session contact data')
                    [contacts, params]=autoContactAnalyzerSi(array, params);
                    setappdata(hParamBrowserGui,'contacts',contacts);
                    setappdata(hParamBrowserGui,'params',params);

                    assignin('base','contacts',contacts);
                    figure(hParamBrowserGui);
                else
                    disp('Contact Parameter Adjustment Cancelled')
                end
                
                
            case 'adjTrials'
                prompt = {'Trial Range'};
                dlg_title = 'Trial Range';
                num_lines = 1;
                def = {num2str(params.trialRange)};
                trialParams = inputdlg(prompt,dlg_title,num_lines,def);
               
                params.trialRange=str2num(trialParams{1});
                
            case 'all'
                params.displayType = 'all'
            
            case 'contactsOnly'             
                params.displayType = 'contactsOnly'
                disp('Updating Time Period, please wait')
                
            case 'excludeContacts'             
                params.displayType = 'excludeContacts'
                disp('Updating Time Period, please wait')
                
            case 'poleToDecision'             
                params.displayType = 'poleToDecision'
                disp('Updating Time Period, please wait')
                
            case 'contactToDecision'             
                params.displayType = 'contactToDecision'
                disp('Updating Time Period, please wait')
                
            case 'postDecision'             
                params.displayType = 'postDecision'
                disp('Updating Time Period, please wait')
                
            case 'postPole'             
                params.displayType = 'postPole'
                disp('Updating Time Period, please wait')
                
            case 'arbitrary'
                params.displayType = 'arbitrary'
                prompt = {'Enter starting time (in ms):','Enter ending time (in sec)'};
                dlg_title = 'Select a timeperiod for analysis';
                num_lines = 1;
                def = {'0','4.500'};
                disp('Updating Time Period, please wait')
                params.arbTimes = inputdlg(prompt,dlg_title,num_lines,def);
            
            case 'STA'
                params.summarize = 'STA'
            
            case 'clusts'
                params.summarize = 'clusts'
                
            case 'tuning'
                params.summarize = 'tuning'
                
            case 'contacts'
                params.summarize = 'contacts'
                
            case 'fit'
                params.summarize = 'fit'    
                
            otherwise
                error('Invalid string argument.')
        end
    end
end
setappdata(hParamBrowserGui,'params', params);


% Shorthand notation

time=array.trials{params.sweepNum}.whiskerTrial.time{1}; % All times in current trial
cT=array.trials{params.sweepNum};
cW=array.trials{params.sweepNum}.whiskerTrial;
cB=array.trials{params.sweepNum}.behavTrial;
cS=array.trials{params.sweepNum}.shanksTrial;



% Select relevant frame periods

switch params.displayType
    
    case 'all'
        params.framesUsed = 1:length(time);
        
    case 'contactsOnly'
        params.framesUsed = contacts{params.sweepNum}.contactInds{1};
    
    case 'excludeContacts'
        params.framesUsed = ones(size(time));
        params.framesUsed(contacts{params.sweepNum}.contactInds{1})=0;
        params.framesUsed= find(params.framesUsed);
        
    case 'poleToDecision'
        if isempty(cB.answerLickTime)==0
            params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                time < cB.answerLickTime);
        else
            params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                time < params.meanAnswerTime);
        end
        
    case 'contactToDecision'             
        if isempty(contacts{params.sweepNum}.contactInds{1})==0
            params.framesUsed = find(time > time(contacts{params.sweepNum}.contactInds{1}(1)) &...
                time < params.meanAnswerTime);
        else
            params.framesUsed=[];
        end
        
    case 'postDecision'             
        
        if isempty(cB.answerLickTime)==0;
            params.framesUsed = find(time > cB.answerLickTime);
        else
            params.framesUsed = find(time> params.meanAnswerTime);
        end
        
    case 'postPole'             
        params.framesUsed = find(time > cT.pinAscentOnsetTime);
        
    case 'arbitrary'
        params.framesUsed = find(time > str2num(params.arbTimes{1}) & time < str2num(params.arbTimes{2}));
            
    otherwise
        error('Invalid string argument.')
end

% Contact discrimination parameters

% spikeIndex=zeros(100000,1);
if isempty(cW)==1
        subplot(4,3,1)
        text(0,0,'Whisker Data Missing for Trial');
else
    
    % Calculate the spike rate across trials
    
        sampleRate=cS.sampleRate;

%     for i=1:length(cS.clustData)
%     try
%         spikeIndex{i}(cS.clustData{i}.spikeTimes)=1;
%     end
%     
%     spikeRate{i}=smooth(spikeIndex{i},params.spikeRateWindow*sampleRate)*sampleRate;
%     
%     spikeRateUsed{i}=spikeRate{i}(params.framesUsed*10+round((array.whiskerTrialTimeOffset+params.spikeSynapticOffset)*sampleRate));
%     end
    
    
    params.cropind=[];   cind=[];   y1=[];   x1=[];    y2=[];   x2=[];
    params.cropind=find(cW.time{1} > params.poleOffset+cB.pinDescentOnsetTime & cW.time{1} < params.poleEndOffset+cB.pinAscentOnsetTime);
    cind=contacts{params.sweepNum}.contactInds{1};
    y1=cW.distanceToPoleCenter{1}(params.cropind);
    x1=cW.kappa{1}(params.cropind);
    y2=cW.distanceToPoleCenter{1}(cind);
    x2=cW.kappa{1}(cind);
    tmax=array.trials{1}.shanksTrial.sweepLengthInSamples/array.trials{1}.shanksTrial.sampleRate;
    
    % Plot contact detection parameters
    subplot(4,3,[3 6]);hold off;
    plot(x1,y1,'.k','Tag','t_cvd'); hold on
    plot(x2,y2,'.g');
    title('Contact Parameters')
    axis tight
    xlabel('Curvature (\kappa)')
    ylabel('Dist to pole (mm)')
    
    % Plot Trial info
    subplot(4,3,12);hold off;
      
        plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
    
    text(.1,1,[int2str(params.sweepNum) '/' int2str(array.length) ...
        ', Trial=' int2str(params.trialNums(params.sweepNum))]);

    text(.1,.9, ['\fontsize{10}' array.trials{params.sweepNum}.trialOutcome]);

%    text(.1,.9, ['\fontsize{10}' 'Analysis Time Period : ' params.displayType '  ' num2str([params.arbTimes{1} params.arbTimes{2}])]);
    text(.1,.8, ['\fontsize{10}' 'Spike Synaptic Offset : ' num2str(params.spikeSynapticOffset) ' (s)']);
%    text(.1,.7, ['\fontsize{10}' 'Spike Integration Window : ' num2str(params.spikeRateWindow) ' (s)']);
%    text(.1,.6, ['\fontsize{10}' 'Bins : ' num2str(params.maxBins) '    N per Bin : ' num2str(round(length(params.framesUsed)/params.maxBins))]);
    text(.1,.5, ['\fontsize{10}' 'Mean Answer Time : ' num2str(params.meanAnswerTime) ' (s)']);
  %  text(.1,.4, ['\fontsize{10}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
    text(.1,.3, ['\fontsize{10}' 'Mouse : ' array.mouseName]);
 %   text(.1,.2, ['\fontsize{10}' 'Cell : ' params.cellNum ' ' array.cellCode]) ;
%    text(.1,.1, ['\fontsize{10}' 'Location : ' num2str(array.depth) ' (um)' ' ' array.recordingLocation]) ;

    % Distance to pole center
    subplot(4,3,[1 2  4 5]);
    hold off;
    plot(cW.time{1},cW.distanceToPoleCenter{1},'.-k','Tag','t_d')
    hold on
        set(gca,'XLim',[.5 2],'YLim',[-.25 1]);

        plot(cW.time{1}(cind),cW.distanceToPoleCenter{1}(cind),'.r')

    title(strcat('Distance to pole center #',num2str(params.trialNums(params.sweepNum))),'FontSize',10)
    ylabel('Distance (mm)');
    hold on;
    
    % Curvature
     subplot(4,3,[7 8]);
    hold off;
        set(gca,'XLim',[-.5 tmax]);

    plot(cW.time{1},cW.deltaKappa{1},'.-k')
    hold on
    
    plot(cW.time{1}(cind),cW.deltaKappa{1}(cind),'.r')
    title(strcat('Change in curvature #',num2str(params.trialNums(params.sweepNum))))
    ylabel('Distance (mm)');
    hold on;
    
    % Plot M0 with contacts scored
    
    M0combo=cW.M0I{1};
    M0combo(abs(M0combo)>1e-7)=NaN;
    M0combo(cind)=cW.M0{1}(cind);
    
    subplot(4,3,[10 11]);
    cla;hold on
    set(gca,'XLim',[-.5 tmax],'Color','k');
    title(strcat('Forces associated with trial #',num2str(params.trialNums(params.sweepNum))))


    if ~isfield(params,'floatingBaseline')
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0combo{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'r.','MarkerSize',8)
        
    elseif ~params.floatingBaseline
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0combo{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'r.','MarkerSize',8)
        
    elseif params.floatingBaseline
    
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0comboAdj{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),contacts{params.sweepNum}.M0comboAdj{1}(cind),'r.','MarkerSize',8)
        
    
    else 
    end
    
        
    for i = 1:length(cS.clustData)
        try
        plot(double(cS.clustData{i}.spikeTimes)/cS.sampleRate+array.whiskerTrialTimeOffset,.5e-7+5e-8*i,'.','color',params.colors(i,:))
        
        end
                   text(tmax*.95,.5e-7+5e-8*i,[num2str(params.shankNum(i)) num2str(params.cellNum(i))],...
                       'FontSize',6,'color',params.colors(i,:))

    end
    try
        plot(array.trials{params.sweepNum}.behavTrial.beamBreakTimes,.5e-7,'m*')
    end
    text(tmax*.95,.5e-7,'Lick','FontSize',6,'color','m')

    ylabel('M0 (N*m) red=contact');
 
end

switch params.summarize
    case 'STA'
        params.summarize = 'off'; % switches the summarize flag off
        summarizeSTA(array,contacts, params);  % calls the STA summary function
        
    case 'spikes'
        params.summarize = 'off'; % switches the summarize flag off
        summarizeClusts(array,contacts, params);  % calls the STA summary function
         
    case 'tuning'
        params.summarize = 'off';
        summarizeTuningSi(array,contacts, params);
    
    case 'contacts'
        params.summarize = 'off';
        summarizeContactsSi(array,contacts, params);
        
    case 'fit'
        params.summarize = 'off';
        summarizeFit;
                
    otherwise
       
    %error('Invalid string argument.') 
      
end

assignin('base','params', params);
setappdata(hParamBrowserGui,'params', params);

%% Optional Extra Plotting section

% figure
%     % Plot M0 with contacts scored
%     M0combo=cW.M0I{1};
%     M0combo(abs(M0combo)>1e-7)=NaN;
%     M0combo(cind)=cW.M0{1}(cind);
%     set(gca,'XLim',[0 tmax]);
%     
%     cla;
%     plot(array.trials{params.sweepNum}.whiskerTrial.time{1},M0combo,'-k.')
%     title(strcat('Forces associated with trial #',num2str(params.trialNums(params.sweepNum))))
%     hold on;
%     plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'.r')
%     %plot(cS.spikeTimes/cS.sampleRate+array.whiskerTrialTimeOffset,5e-8,'.')
%     ylabel('M0 (N*m) red=contact');
%     set(gca,'XLim',[0 tmax]);
%     set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 3])
% 
%      

