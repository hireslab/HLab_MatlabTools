% Spike index is a logical that indicates the presence of a spike in that
% ms timebin, pre-timeshifted by the synaptic delay value.
% All other fields are cell arrays with 2 columns, the first is the value
% for a given timepoint, and the second is the time (in ms) of the
% timepoint
set(0,'DefaultLineMarkerSize',4);

for cnum = 1:52;
    
    [CA, T, DA, contacts, params] = loadSUData(cnum, SU)
       
    synapticDelay   = 10;
    
    TC.useFlag      = intersect(find(T.whiskerTrialInds),[1:find(T.hitTrialInds,1,'last')]);
    TC.spikeIdx     = cell(size(DA.spikeTimes));
    TC.preContact   = cell(size(DA.spikeTimes));
    TC.preContactSamplingIdx = cell(size(DA.spikeTimes));
    TC.contactInds  = cell(size(DA.spikeTimes));
    TC.contactID    = cell(size(DA.spikeTimes));    
    TC.M0Adj        = cell(size(DA.spikeTimes));
    TC.FaxAdj       = cell(size(DA.spikeTimes));
    TC.theta        = cell(size(DA.spikeTimes));
    TC.velocity     = cell(size(DA.spikeTimes));
    TC.acceleration = cell(size(DA.spikeTimes));
    TC.phase        = cell(size(DA.spikeTimes));
    TC.amplitude    = cell(size(DA.spikeTimes));
    TC.setpoint     = cell(size(DA.spikeTimes));
    
    vel = getVelocity(T, TC.useFlag, 5);
    acc = getAccel(T, TC.useFlag, 5);
    
    for i = TC.useFlag
        [hh amplitude  filteredSignal setpoint amplitudeS setpointS phase phaseS] =  SAHWhiskerDecomposition(T.trials{i}.whiskerTrial.thetaAtBase{1});
        if isempty(contacts{i}.contactInds{1});
            TC.preContactSamplingIdx{i} = find(DA.samplingPeriodIdx{i});
        else
            tmp = find(DA.samplingPeriodIdx{i});
            TC.preContactSamplingIdx{i} = tmp(DA.samplingPeriodinMs{i} <  1000*T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1}(1)));
        end
        
        TC.spikeIdx{i} = false(5000,1);
        TC.spikeIdx{i}(DA.spikeTimes{i}(DA.spikeTimes{i}>1-synapticDelay)+synapticDelay) = 1;
        

        
        TC.preContact{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.preContact{i}(:,1)  = zeros(size(TC.preContact{i}(:,2)));
        TC.preContact{i}(:,3)  = TC.spikeIdx{i}(TC.preContact{i}(:,2));
        
        if isempty(DA.samplingPeriodinMs{i});
              TC.M0Adj{i} = zeros(0,3);
            TC.FaxAdj{i} = zeros(0,3);
        elseif ~isempty(contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end)))
            
            TC.contactInds{i} = contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end));
            
            for j = 1:size(contacts{i}.segmentInds{1},1) 
                TC.contactID{i}(ismember(TC.contactInds{i}, contacts{i}.segmentInds{1}(j,1):contacts{i}.segmentInds{1}(j,2))) = j;
            end
            
%TC.contactIdx{i}  = 
                            
            TC.M0Adj{i}(:,1)  = contacts{i}.M0comboAdj{1}(contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end)));
            TC.M0Adj{i}(:,2)  = round(T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end)))*1000);
            TC.M0Adj{i}(:,3)  = TC.spikeIdx{i}(TC.M0Adj{i}(:,2));
            
            
            TC.FaxAdj{i}(:,1) = contacts{i}.FaxialAdj{1}(contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end)));
            TC.FaxAdj{i}(:,2) = round(T.trials{i}.whiskerTrial.time{1}(contacts{i}.contactInds{1}(contacts{i}.contactInds{1}<DA.samplingPeriodinMs{i}(end)))*1000);
            TC.FaxAdj{i}(:,3) = TC.spikeIdx{i}(TC.FaxAdj{i}(:,2));
            
        else
            TC.M0Adj{i} = zeros(0,3);
            TC.FaxAdj{i} = zeros(0,3);
        end
        
        
        TC.theta{i}(:,1)  = T.trials{i}.whiskerTrial.thetaAtBase{1}(TC.preContactSamplingIdx{i});
        TC.theta{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.theta{i}(:,3)  = TC.spikeIdx{i}(TC.theta{i}(:,2));
        
        TC.velocity{i}(:,1)  = vel{i}(TC.preContactSamplingIdx{i});
        TC.velocity{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.velocity{i}(:,3)  = TC.spikeIdx{i}(TC.velocity{i}(:,2));
        
        TC.acceleration{i}(:,1)  = acc{i}(TC.preContactSamplingIdx{i});
        TC.acceleration{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.acceleration{i}(:,3)  = TC.spikeIdx{i}(TC.acceleration{i}(:,2));
        
        TC.phase{i}(:,1)  = phase(TC.preContactSamplingIdx{i}(amplitude(TC.preContactSamplingIdx{i})>2.5));
        TC.phase{i}(:,2)  = round(T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i}(amplitude(TC.preContactSamplingIdx{i})>2.5))*1000);
        TC.phase{i}(:,3)  = TC.spikeIdx{i}(TC.phase{i}(:,2));
        
        TC.amplitude{i}(:,1)  = amplitude(TC.preContactSamplingIdx{i});
        TC.amplitude{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.amplitude{i}(:,3)  = TC.spikeIdx{i}(TC.amplitude{i}(:,2));
        
        TC.setpoint{i}(:,1)  = setpoint(TC.preContactSamplingIdx{i});
        TC.setpoint{i}(:,2)  = round( T.trials{i}.whiskerTrial.time{1}(TC.preContactSamplingIdx{i})*1000);
        TC.setpoint{i}(:,3)  = TC.spikeIdx{i}(TC.setpoint{i}(:,2));
        
        
    end
    
    %%
    
    tmp = cellfun(@(x)x(:,[3]),TC.preContact(TC.useFlag),'UniformOutput',0);
    preContactCat = (cat(1,tmp{:}));
    
    xlab{1} = 'Moment (N m)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.M0Adj(TC.useFlag),'UniformOutput',0);
    sortCat{1} = (cat(1,tmp{:}));
    binBoundsPreset{1} =  1e-8*[-100 -20 -5 -1.25 0 1.25 5 20 100];
    
    
    xlab{2} = 'Faxial (N)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.FaxAdj(TC.useFlag),'UniformOutput',0);
    sortCat{2} = (cat(1,tmp{:}));
    binBoundsPreset{2} =  1e-6*[-100 -20 -10 -5 -2.5 -1.25 -.625 0];
    
    xlab{3} = 'Theta (deg)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.theta(TC.useFlag),'UniformOutput',0);
    sortCat{3} = (cat(1,tmp{:}));
    binBoundsPreset{3} =  [-30 -10 -5 0 5 10 20 30 60];
    
    xlab{4} = 'Velocity (deg/s)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.velocity(TC.useFlag),'UniformOutput',0);
    sortCat{4} = (cat(1,tmp{:}));
    binBoundsPreset{4} =  1e2*[-40 -10 -5 -2.5 0 2.5 5 10 40];
    
    xlab{5} = 'Acceleration (deg/s^2)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.acceleration(TC.useFlag),'UniformOutput',0);
    sortCat{5} = (cat(1,tmp{:}));
    binBoundsPreset{5} =  1e4*[-40 -10 -5 -2.5 0 2.5 5 10 40];
    
    xlab{6} = 'Phase (rad)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.phase(TC.useFlag),'UniformOutput',0);
    sortCat{6} = (cat(1,tmp{:}));
    binBoundsPreset{6} =  [-pi:1/4*pi:pi]
    
    xlab{7} = 'Amplitude (deg)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.amplitude(TC.useFlag),'UniformOutput',0);
    sortCat{7} = (cat(1,tmp{:}));
    binBoundsPreset{7} =  [0 .25 .5 1 2 4 8 16 40];
    
    xlab{8} = 'Setpoint (deg)';
    tmp = cellfun(@(x)x(:,[1 3]),TC.setpoint(TC.useFlag),'UniformOutput',0);
    sortCat{8} = (cat(1,tmp{:}));
    binBoundsPreset{8} = [-25 -10 -5 0 5 10 15 20 50];
    
    [preContactphat preContactphatCi] = binofit(sum(preContactCat),length(preContactCat));
    
    %[sortedM0Spk sortedByM0 M0binBounds]=binslin(M0AdjCat(:,1), M0AdjCat(:,2), 'equalX', M0binBounds);
    for i = 1:8
        [sorted sortedBy binBounds]=binslin(sortCat{i}(:,1), sortCat{i}(:,2), 'equalN', binBoundsPreset{i});
        sortedSpk{i} = sorted; sortedVar{i} = sortedBy; binBoundsVar{i} = binBounds;
        
        [phat phatCi] = binofit(cellfun(@sum,sortedSpk{i}),cellfun(@length,sortedSpk{i}));
        phatSpk{i} = phat; phatCiSpk{i} = phatCi;
        
        x{i} = mean([binBoundsVar{i}(1:end-1);binBoundsVar{i}(2:end)]);
        y{i} = phatCiSpk{i}'*1000;
        y2{i} = phatSpk{i}*1000;
    end
    % [M0phat M0phatCi] = binofit(cellfun(@sum,sortedM0Spk),cellfun(@length,sortedM0Spk));
    % [sortedFaxSpk sortedByFax binBoundsFax]=binslin(FaxAdjCat(:,1), FaxAdjCat(:,2), 'equalX', FaxbinBounds);
    % [Faxphat FaxphatCi] = binofit(cellfun(@sum,sortedFaxSpk),cellfun(@length,sortedFaxSpk));
    
    %%plotting
    % x{1} = 1e6*mean([M0binBounds(1:end-1);M0binBounds(2:end)]);
    
    
    
    
    
    
    figure(1);clf;set(gcf,'PaperOrientation','portrait','PaperPosition',[0 0 6 8],'PaperSize',[6 8]);
    subplot(4,3,[1:3]);
    T.plot_spike_raster(TC.useFlag);
    set(gca,'xlim',[0 3])
    subplot(4,3,4)
    text(0, 1, [SU.cellName{cnum}])
    text(0, .85, ['Si Cell #' num2str(cnum)])

    text(0, .4, ['Loc ' sprintf('%0.3g',SU.recordingLocation{cnum}(1)) ',' sprintf('%0.3g',SU.recordingLocation{cnum}(2)) ',' sprintf('%0.3g',SU.recordingLocation{cnum}(3)) ])
    set(gca,'visible','off')
    for i = 1:8
        subplot(4,3,i+4);hold on
        
        patch([x{i} x{i}(end:-1:1)], [y{i}(1,:) y{i}(2,end:-1:1)],[.8 .8 1],'linestyle','none')
        plot([min(x{i}) max(x{i})],[1 1]*1000*preContactphat,'k-')
        plot([min(x{i}) max(x{i})],[1 1]*1000*preContactphatCi(2),'-','color',[.5 .5 .5])
        plot([min(x{i}) max(x{i})],[1 1]*1000*preContactphatCi(1),'-','color',[.5 .5 .5])
        
        plot(x{i},y2{i},'bo-')
        ylabel('Spike rate')
        xlabel(xlab{i})
        set(gca,'xlim',[min(x{i}) max(x{i})],'ylim',[0 max(y{i}(:))])
    end
    
    TC.xlab = xlab;
    TC.sortCat = sortCat;
    TC.binBoundsPreset = binBoundsPreset;
    TC.sortedSpk = sortedSpk;
    TC.sortedVar = sortedVar;
    TC.binBoundsVar = binBoundsVar;
    TC.phatSpk = phatSpk;
    TC.phatCiSpk = phatCiSpk;
    TC.x = x;
    TC.y = y;
    TC.y2 = y2;
    
    save(['Z:\users\Andrew\Whisker Project\SingleUnit\TuningCurveArrays\TC-SU' num2str(cnum)], 'TC')
    print(gcf, '-depsc',  ['z:\users\Andrew\Whisker Project\SingleUnit\Figures\TuningCurves\SU' num2str(cnum)])
end
%
%
%
% figure(2);clf;hold on
% x = mean([FaxbinBounds(1:end-1);FaxbinBounds(2:end)]);
% y = FaxphatCi'*1000;
% y2 = Faxphat*1000;
% patch(1e6*[x x(end:-1:1)], [y(1,:) y(2,end:-1:1)],[.8 .8 1],'linestyle','none')
% plot(1e6*x,y2,'bo-')
% plot(0,1000*preContactphat,'ko')
% plot([0 0],1000*preContactphatCi,'k-')
%
% ylabel('Spike rate')
% xlabel('Moment (\muN m)');
% axis tight
