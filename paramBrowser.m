% This is supposed to plot all timepoints of trial index k, with curvature
% on the x-axis and distance to pole on the y-axis. Contact scored
% timepoints are in green, non-contact points in black.


% To implement, modes where we just look at the precontact period, the 1st
% contact to decision period and the post decision period.  Arbitratry time 
% periods.
% Option to exclude contact periods from the position, velocity and acceleration
% analysis.


function paramBrowser(array, contacts, varargin)
if nargin <3
    if nargin==1
        disp('Contacts data missing, building and assigning to workspace as "contacts"')
        contacts=autoContactAnalyzer(array);
        contactsname= 'contacts';
        assignin('base','contacts',contacts);
    else
        contactsname = inputname(2);
    end
    arrayname = inputname(1); % Command-line name of this instance of a TrialArray.
    
    hParamBrowserGui = figure('Color','white'); ht = uitoolbar(hParamBrowserGui);
    setappdata(0,'hParamBrowserGui',gcf);
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    
    a = .20:.05:0.95; b(:,:,1) = repmat(a,16,1)'; b(:,:,2) = repmat(a,16,1); b(:,:,3) = repmat(flipdim(a,2),16,1);
    bbutton = uipushtool(ht,'CData',b,'TooltipString','Back');
    fbutton = uipushtool(ht,'CData',b,'TooltipString','Forward','Separator','on');
    g = struct('sweepNum',find(array.whiskerTrialInds,1),...
        'framesUsed',1:length(array.trials{find(array.whiskerTrialInds,1)}.whiskerTrial.time{1}),...
        'displayType','all','displayTypeMinor','none', 'arbTimes',[],...
        'trialList','','arrayname',arrayname,'contactsname', contactsname,...
        'tid',0,'touchThresh', [.15 .15 .15 .15],'curveMultiplier',1,'goProThresh', -10, 'nogoProThresh', -15,...
        'poleOffset', .768, 'poleEndOffset',.3, 'trialRange', [array.trialNums(1) array.trialNums(end)], 'maxBins', 51, 'spikeRateWindow', .05, 'spikeSynapticOffset',0,'summarize', 'off');  
    
    set(fbutton,'ClickedCallback',['paramBrowser(' g.arrayname ',' g.contactsname ',''next'')'])
    set(bbutton,'ClickedCallback',['paramBrowser(' g.arrayname ',' g.contactsname ',''last'')'])
    
    m1=uimenu(hParamBrowserGui,'Label','Time Period','Separator','on');
    uimenu(m1,'Label','All'                          ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''all'')']);
    uimenu(m1,'Label','Contacts Only'                ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''contactsOnly'')']);
    uimenu(m1,'Label','Exclude Contacts'             ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''excludeContacts'')']);
    uimenu(m1,'Label','Pole Presentation to Decision','Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''poleToDecision'')']);
    uimenu(m1,'Label','First Contact to Decision'    ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''contactToDecision'')']);
    uimenu(m1,'Label','Post Decision'                ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''postDecision'')']);
    uimenu(m1,'Label','Post Pole'                    ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''postPole'')']);
    uimenu(m1,'Label','Abritrary Range'              ,'Callback', ['paramBrowser(' g.arrayname ',' g.contactsname ',''arbitrary'')']);

    m2=uimenu(hParamBrowserGui,'Label','Adjust parameters','Separator','on');
    uimenu(m2,'Label','Plots'   ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''adjPlots'')']);
    uimenu(m2,'Label','Spikes'  ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''adjSpikes'')']); 
    uimenu(m2,'Label','Contacts','Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''adjContacts'')']);
    uimenu(m2,'Label','Trial Range','Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''adjTrials'')']);
    
    uimenu(hParamBrowserGui,'Label','Jump to sweep','Separator','on','Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''jumpToSweep'')']);
    
    m3=uimenu(hParamBrowserGui,'Label','Summarize','Separator','on');
    uimenu(m3,'Label','STA'     ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''STA'')']); 
    uimenu(m3,'Label','Spikes'  ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''spikes'')']);
    uimenu(m3,'Label','Tuning'  ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''tuning'')']);
    uimenu(m3,'Label','Contacts','Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''contacts'')']);
    uimenu(m3,'Label','Fit'     ,'Callback',['paramBrowser(' g.arrayname ',' g.contactsname ',''fit'')']);
    set(hParamBrowserGui,'UserData',g);
    setappdata(hParamBrowserGui, 'params',g);
    setappdata(hParamBrowserGui, 'contacts', contacts);
    setappdata(hParamBrowserGui, 'array', array);
else
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    g = getappdata(hParamBrowserGui,'params');

    if isempty(g) % Initial call to this method has argument
        g = struct('sweepNum',find(cellfun(@(x) ~isempty(x.whiskerTrial),T.trials),1),'trialList',array.trialNums(cellfun(@(x) ~isempty(x.whiskerTrial),T.trials)),'displayType','all');
    end
    for j = 1:length(varargin);
        argString = varargin{j};
        switch argString
           
            case 'next'
                if g.sweepNum < length(array.trials)
                    g.sweepNum = g.sweepNum + 1;
                end
                
                
            case 'last'
                if g.sweepNum > 1
                    g.sweepNum = g.sweepNum - 1;
                end
                
            case 'jumpToSweep'
                if isempty(g.trialList)
                    nsweeps = array.length;
                    g.trialList = cell(1,nsweeps);
                    for k=1:nsweeps
                        g.trialList{k} = [int2str(k) ': trialNum=' int2str(array.trialNums(k))];
                    end
                end
                [selection,ok]=listdlg('PromptString','Select a sweep:','ListString',...
                    g.trialList,'SelectionMode','single');
                if ~isempty(selection) && ok==1
                    g.sweepNum = selection;
                end
                
            case 'adjPlots'
                prompt = {'Maximum bins for plots'};
                dlg_title = 'Plotting Parameters';
                num_lines = 1;
                def = {num2str(g.maxBins)};
                plotParams = inputdlg(prompt,dlg_title,num_lines,def);
               
                g.maxBins=str2num(plotParams{1});
                set(hParamBrowserGui,'UserData',g);
            
            case 'adjSpikes'
                 prompt = {'Window size of spike integration (s)', 'Estimated synaptic delay between spikes and whiskers (s)'};
                dlg_title = 'Spike Rate Parameters';
                num_lines = 1;
                def = {num2str(g.spikeRateWindow), num2str(g.spikeSynapticOffset)};
                spikeParams = inputdlg(prompt,dlg_title,num_lines,def);                
                g.spikeRateWindow=str2num(spikeParams{1});
                g.spikeSynapticOffset=str2num(spikeParams{2});
                set(hParamBrowserGui,'UserData',g);
                
            case 'adjContacts'
                 prompt = {'Trajectory ID :','Pole delay from onset till in range (s)','Pole delay from offset till out of range (s)',...
                    'Contact distance thresholds (go/pro, go/ret, nogo/pro, nogo/ret)', 'Go pro/ret curvature threshold',...
                    'Nogo pro/ret curvature threshold','Curve Multiplier' };
                dlg_title = 'Contact Parameters';
                num_lines = 1;
                def = {num2str(g.tid), num2str(g.poleOffset), num2str(g.poleEndOffset),...
                    num2str(g.touchThresh), num2str(g.goProThresh),num2str(g.nogoProThresh), num2str(g.curveMultiplier)};
                contactParams = inputdlg(prompt,dlg_title,num_lines,def);
                
                g.tid= str2num(contactParams{1});
                g.poleOffset=str2num(contactParams{2});
                g.poleEndOffset=str2num(contactParams{3});
                g.touchThresh = str2num(contactParams{4}); %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
                g.goProThresh = str2num(contactParams{5}); % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
                g.nogoProThresh = str2num(contactParams{6});
                g.curveMultiplier = str2num(contactParams{7});
                
                disp('Recalculating session contact data')
                contacts=autoContactAnalyzer(array,g);
                set(hParamBrowserGui,'UserData',g);
                setappdata(hParamBrowserGui,'contacts',contacts);
                assignin('base','contacts',contacts);
                figure(hParamBrowserGui);
                
            case 'adjTrials'
                prompt = {'Trial Range'};
                dlg_title = 'Trial Range';
                num_lines = 1;
                def = {num2str(g.trialRange)};
                trialParams = inputdlg(prompt,dlg_title,num_lines,def);
               
                g.trialRange=str2num(trialParams{1});
                set(hParamBrowserGui,'UserData',g);
                
            case 'all'
                g.displayType = 'all'
            
            case 'contactsOnly'             
                g.displayType = 'contactsOnly'
                disp('Updating Time Period, please wait')
                
            case 'excludeContacts'             
                g.displayType = 'excludeContacts'
                disp('Updating Time Period, please wait')
                
            case 'poleToDecision'             
                g.displayType = 'poleToDecision'
                disp('Updating Time Period, please wait')
                
            case 'contactToDecision'             
                g.displayType = 'contactToDecision'
                disp('Updating Time Period, please wait')
                
            case 'postDecision'             
                g.displayType = 'postDecision'
                disp('Updating Time Period, please wait')
                
            case 'postPole'             
                g.displayType = 'postPole'
                disp('Updating Time Period, please wait')
                
            case 'arbitrary'
                g.displayType = 'arbitrary'
                prompt = {'Enter starting time (in ms):','Enter ending time (in sec)'};
                dlg_title = 'Select a timeperiod for analysis';
                num_lines = 1;
                def = {'0','4.500'};
                disp('Updating Time Period, please wait')
                g.arbTimes = inputdlg(prompt,dlg_title,num_lines,def);
            
            case 'STA'
                g.summarize = 'STA'
            
            case 'spikes'
                g.summarize = 'spikes'
                
            case 'tuning'
                g.summarize = 'tuning'
                
            case 'contacts'
                g.summarize = 'contacts'
                
            case 'fit'
                g.summarize = 'fit'    
                
            otherwise
                error('Invalid string argument.')
        end
    end
end
setappdata(hParamBrowserGui,'params',g);


% Shorthand notation

time=array.trials{g.sweepNum}.whiskerTrial.time{1}; % All times in current trial
cT=array.trials{g.sweepNum};
cW=array.trials{g.sweepNum}.whiskerTrial;
cB=array.trials{g.sweepNum}.behavTrial;
cS=array.trials{g.sweepNum}.spikesTrial;

% Get mean answer time
tmp=[];
for i=1:array.length
    if isempty(array.trials{i}.answerLickTime)==0
        tmp(i)=array.trials{i}.answerLickTime;
    else
        tmp(i)=NaN;
    end
end
g.meanAnswerTime=nanmean(tmp);

% Select relevant frame periods

switch g.displayType
    
    case 'all'
        g.framesUsed = 1:length(time);
        
    case 'contactsOnly'
        g.framesUsed = contacts{g.sweepNum}.contactInds{1};
    
    case 'excludeContacts'
        g.framesUsed = ones(size(time));
        g.framesUsed(contacts{g.sweepNum}.contactInds{1})=0;
        g.framesUsed= find(g.framesUsed);
        
    case 'poleToDecision'
        if isempty(cB.answerLickTime)==0
            g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                time < cB.answerLickTime);
        else
            g.framesUsed = find(time > cT.pinDescentOnsetTime+g.poleOffset &...
                time < g.meanAnswerTime);
        end
        
    case 'contactToDecision'             
        if isempty(contacts{g.sweepNum}.contactInds{1})==0
            g.framesUsed = find(time > time(contacts{g.sweepNum}.contactInds{1}(1)) &...
                time < g.meanAnswerTime);
        else
            g.framesUsed=[];
        end
        
    case 'postDecision'             
        
        if isempty(cB.answerLickTime)==0;
            g.framesUsed = find(time > cB.answerLickTime);
        else
            g.framesUsed = find(time> g.meanAnswerTime);
        end
        
    case 'postPole'             
        g.framesUsed = find(time > cT.pinAscentOnsetTime);
        
    case 'arbitrary'
        g.framesUsed = find(time > str2num(g.arbTimes{1}) & time < str2num(g.arbTimes{2}));
            
    otherwise
        error('Invalid string argument.')
end

% Contact discrimination parameters

spikeIndex=zeros(46000,1);
if isempty(cW)==1
        subplot(3,3,1)
        text(0,0,'Whisker Data Missing for Trial');
else
    
    % Calculate the spike rate across trials
    try
        spikeIndex(cS.spikeTimes)=1;
    catch
    end
    sampleRate=cS.sampleRate;
    spikeRate=smooth(spikeIndex,g.spikeRateWindow*sampleRate)*sampleRate;
    spikeRateUsed=spikeRate(g.framesUsed*10+round((array.whiskerTrialTimeOffset+g.spikeSynapticOffset)*sampleRate));

    
    
    cropind=[];   cind=[];   y1=[];   x1=[];    y2=[];   x2=[];
    cropind=cW.time{1} > g.poleOffset+cB.pinDescentOnsetTime & cW.time{1} < .3+cB.pinAscentOnsetTime;
    cind=contacts{g.sweepNum}.contactInds{1};
    y1=cW.distanceToPoleCenter{1}(cropind);
    x1=cW.kappa{1}(cropind);
    y2=cW.distanceToPoleCenter{1}(cind);
    x2=cW.kappa{1}(cind);
    tmax=array.trials{1}.spikesTrial.sweepLengthInSamples/array.trials{1}.spikesTrial.sampleRate;
    
    % Plot contact detection parameters
    subplot(4,5,2);cla;
    plot(x1,y1,'.k'); hold on
    plot(x2,y2,'.g');
    title('Contact Parameters')
    axis tight
    xlabel('Curvature (\kappa)')
    ylabel('Dist to pole (mm)')
    set(gcf,'UserData',g);
    
    % Plot Trial info
    subplot(4,5,1);cla;
      title([array.cellNum array.cellCode ', ' int2str(g.sweepNum) '/' int2str(array.length) ...
        ', sweepNum=' int2str(array.trialNums(g.sweepNum)) ...
        '\newline displayType=' g.displayType ' Trial Type' ]);
        plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
%    text(.1,.9, ['\fontsize{10}' 'Analysis Time Period : ' g.displayType '  ' num2str([g.arbTimes{1} g.arbTimes{2}])]);
    text(.1,.8, ['\fontsize{10}' 'Spike Synaptic Offset : ' num2str(g.spikeSynapticOffset) ' (s)']);
    text(.1,.7, ['\fontsize{10}' 'Spike Integration Window : ' num2str(g.spikeRateWindow) ' (s)']);
    text(.1,.6, ['\fontsize{10}' 'Bins : ' num2str(g.maxBins) '    N per Bin : ' num2str(round(length(g.framesUsed)/g.maxBins))]);
    text(.1,.5, ['\fontsize{10}' 'Mean Answer Time : ' num2str(g.meanAnswerTime) ' (s)']);
    text(.1,.4, ['\fontsize{10}' 'Mean Spike Rate : ' num2str(array.meanSpikeRateInHz) ' (Hz)']);
    text(.1,.3, ['\fontsize{10}' 'Mouse : ' array.mouseName]);
    text(.1,.2, ['\fontsize{10}' 'Cell : ' array.cellNum ' ' array.cellCode]) ;
    text(.1,.1, ['\fontsize{10}' 'Location : ' num2str(array.depth) ' (um)' ' ' array.recordingLocation]) ;

    % Distance to pole center
    subplot(4,5,[4 5]);
    cla;
    plot(cW.time{1},cW.distanceToPoleCenter{1},'.-k')
    title(strcat('Distance to pole center #',num2str(array.trialNums(g.sweepNum))))
    ylabel('Distance (mm)');
    hold on;
    
    % Plot M0 with contacts scored
    M0combo=cW.M0I{1};
    M0combo(abs(M0combo)>1e-7)=NaN;
    M0combo(cind)=cW.M0{1}(cind);
    set(gca,'XLim',[0 tmax]);
    
    subplot(4,5,[9 10]);
    cla;
    plot(array.trials{g.sweepNum}.whiskerTrial.time{1},M0combo,'-k.','MarkerSize',5)
    title(strcat('Forces associated with trial #',num2str(array.trialNums(g.sweepNum))))
    hold on;
    plot(array.trials{g.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'r.','MarkerSize',5)
    plot(cS.spikeTimes/cS.sampleRate+array.whiskerTrialTimeOffset,5e-8,'.')
    ylabel('M0 (N*m) red=contact');
    set(gca,'XLim',[0 tmax]);
     
    % Plot Faxial adjusted
     subplot(4,5,[14 15]);
     cla;
     plot(array.trials{g.sweepNum}.whiskerTrial.time{1},contacts{g.sweepNum}.FaxialAdj{1});
     hold on;
     plot(cS.spikeTimes/cS.sampleRate+array.whiskerTrialTimeOffset,5e-6,'.')
     ylabel('Faxial (N)')
     xlabel('Time (s)')
    set(gca,'XLim',[0 tmax]);
    
    % Plot spike rate
    subplot(4,5,[19 20]);
    
    cla;
    assignin('base','spikeRate',spikeRate)
    plot((1:46000)/sampleRate,spikeRate);
    ylabel('Spike Rate (Hz)')
    xlabel('Time (s)')
    set(gca,'XLim',[0 tmax]);
    

    binsUsed=min([g.maxBins length(g.framesUsed)]); % Limit the max bins used to number of datapoints available if less than maxBins
    
    
    if isempty(g.framesUsed)==0
            
        % Plot position vs. spike rate
        subplot(4,5,6);
        cla;
        xP=cW.thetaAtBase{1};
        xPos{1}=xP(g.framesUsed);    [binSpikeRate binPos binBounds]=binslin(xPos{1},spikeRateUsed,'equalN',binsUsed);
        x=cellfun(@mean,binPos)';           % Define middle of bin boundries as X coords
        y=cellfun(@mean,binSpikeRate)';                             % Y cords are mean spike rate of the bin
        yerr=(cellfun(@std,binSpikeRate)./cellfun(@(x) sqrt(length(x)),binSpikeRate))'; % Std erorr of the 

        patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 1],'EdgeColor',[.8 .8 1]);
        hold on;
        plot(x,y)
        axis([binBounds(1) binBounds(end) 0 max([1 y+yerr])]);
        ylabel('SpikeRate (Hz)')
         xlabel('Angular Position')

        % Plot velocity vs. spike rate
        subplot(4,5,11);
        cla;
        xV=diff([0 xP])./diff([0 time]);
        xVel{1}=xV(g.framesUsed);
        [binSpikeRate binVel binBounds]=binslin(xVel{1},spikeRateUsed,'equalN',binsUsed);
        x=cellfun(@mean,binVel)';           % Define middle of bin boundries as X coords
        y=cellfun(@mean,binSpikeRate)';                             % Y cords are mean spike rate of the bin
        yerr=(cellfun(@std,binSpikeRate)./cellfun(@(x) sqrt(length(x)),binSpikeRate))'; % Std erorr of the 

        patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 1],'EdgeColor',[.8 .8 1]);
        hold on;
        plot(x,y)
        axis([binBounds(1) binBounds(end) 0 max([1 y+yerr])]);
        ylabel('SpikeRate (Hz)')
        xlabel('Angular Velocity')

        % Plot accleration vs. spike rate
        subplot(4,5,16);
        cla;
        xA=diff([0 xV])./diff([0 time]);
        xAcc{1}=xA(g.framesUsed);
        [binSpikeRate binAcc binBounds]=binslin(xAcc{1},spikeRateUsed,'equalN',binsUsed);
        x=cellfun(@mean,binAcc)';           % Define middle of bin boundries as X coords
        y=cellfun(@mean,binSpikeRate)';                             % Y cords are mean spike rate of the bin
        yerr=(cellfun(@std,binSpikeRate)./cellfun(@(x) sqrt(length(x)),binSpikeRate))'; % Std erorr of the 

        patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 1],'EdgeColor',[.8 .8 1]);
        hold on;
        plot(x,y)
        axis([binBounds(1) binBounds(end) 0 max([1 y+yerr])]);
        ylabel('SpikeRate (Hz)')
        xlabel('Angular Acceleration')

        % Plot moment vs. spike rate
        subplot(4,5,7);
        cla;
        [binSpikeRate binM0combo binBounds]=binslin(M0combo(g.framesUsed),spikeRateUsed,'equalN',binsUsed);
        x=cellfun(@mean,binM0combo)';           % Define middle of bin boundries as X coords
        y=cellfun(@mean,binSpikeRate)';                             % Y cords are mean spike rate of the bin
        yerr=(cellfun(@std,binSpikeRate)./cellfun(@(x) sqrt(length(x)),binSpikeRate))'; % Std erorr of the 

        patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 1],'EdgeColor',[.8 .8 1]);
        hold on;
        plot(x,y)
        axis([binBounds(1) binBounds(end) 0 max([1 y+yerr])]);
        ylabel('SpikeRate (Hz)')
         xlabel('Moment (N)*m')

         % Plot Faxial vs. spike rate
        subplot(4,5,12);
        cla;
        hold off;

        [binSpikeRate binFaxial binBounds]=binslin(contacts{g.sweepNum}.FaxialAdj{1}(g.framesUsed),spikeRateUsed,'equalN',binsUsed);
        x=cellfun(@mean,binFaxial)';         % Define middle of bin boundries as X coords
        y=cellfun(@mean,binSpikeRate)';                             % Y cords are mean spike rate of the bin
        yerr=(cellfun(@std,binSpikeRate)./cellfun(@(x) sqrt(length(x)),binSpikeRate))'; % Std erorr of the 

        patch([binBounds(1:end-1);binBounds(2:end);binBounds(2:end);binBounds(1:end-1)],[y+yerr;y+yerr;y-yerr;y-yerr],[.8 .8 1],'EdgeColor',[.8 .8 1]);
        hold on;
        plot(x,y)
        try
            axis([binBounds(1) binBounds(end) 0 max([1 y+yerr])]);
        catch
        end
        ylabel('SpikeRate (Hz)')
         xlabel('Faxial (N)')
         
         
         % Plot Contact # vs. spike rate
        subplot(4,5,17);
        cla;
        hold off;
        if isempty(contacts{g.sweepNum}.segmentInds{1});
            ind=[];
        else
            ind=find(contacts{g.sweepNum}.segmentInds{1}(:,1) > g.framesUsed(1)...
                & contacts{g.sweepNum}.segmentInds{1}(:,1) < g.framesUsed(end));
        end
        plot(ind,contacts{g.sweepNum}.spikeCount{1}(ind)./contacts{g.sweepNum}.contactLength{1}(ind),'.-');
        xlabel('Contact Number');
        ylabel('Spike Rate (Hz)');
        
        % Plot Theta vs. spike Rate direct
        
        
        subplot(4,5,3);
        cla;
        hold off;
        [binSpikeRate binFaxial binBounds]=binslin(contacts{g.sweepNum}.FaxialAdj{1}(g.framesUsed),spikeRateUsed,'equalN',binsUsed);
        
        
        % Plot Theta vs. spike Rate with synaptic delay
        
        
        
        % Plot behavior data

        % subplot(4,4,1);
         %cB.plot_trial_events;  
    else
        for i=[5,6,9,10,13]
            subplot(4,4,i); cla; 
            x=get(gca,'XLim');y=get(gca,'YLim');
            text(mean(x),mean(y),'No Data');
        end
    end
 
end

switch g.summarize
    case 'STA'
        g.summarize = 'off'; % switches the summarize flag off
        summarizeSTA(array,contacts,g);  % calls the STA summary function
        
    case 'spikes'
        g.summarize = 'off'; % switches the summarize flag off
        summarizeSpikes(array,contacts,g);  % calls the STA summary function
         
    case 'tuning'
        g.summarize = 'off';
        summarizeTuning(array,contacts,g);
    
    case 'contacts'
        g.summarize = 'off';
        summarizeContacts(array,contacts,g);
        
    case 'fit'
        g.summarize = 'off';
        summarizeFit;
                
    otherwise
       
    %error('Invalid string argument.') 
      
end

assignin('base','params',g);
setappdata(hParamBrowserGui,'params',g);
set(hParamBrowserGui,'UserData',g);  % writes current parameters state back to the figure

%% Optional Extra Plotting section

% figure
%     % Plot M0 with contacts scored
%     M0combo=cW.M0I{1};
%     M0combo(abs(M0combo)>1e-7)=NaN;
%     M0combo(cind)=cW.M0{1}(cind);
%     set(gca,'XLim',[0 tmax]);
%     
%     cla;
%     plot(array.trials{g.sweepNum}.whiskerTrial.time{1},M0combo,'-k.')
%     title(strcat('Forces associated with trial #',num2str(array.trialNums(g.sweepNum))))
%     hold on;
%     plot(array.trials{g.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'.r')
%     %plot(cS.spikeTimes/cS.sampleRate+array.whiskerTrialTimeOffset,5e-8,'.')
%     ylabel('M0 (N*m) red=contact');
%     set(gca,'XLim',[0 tmax]);
%     set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 3])
% 
%      

