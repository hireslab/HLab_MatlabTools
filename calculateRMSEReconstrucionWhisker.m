path = 'F:\Diego\Matlab\LeoBatch\Data\';
files = dir(sprintf('%s%s',path,'Experiment*'));


for anm=1:15
    anm
    clear data;
    load (sprintf('%s%s',path,files(anm).name));
    % Find the name of the variable
    varNames         = who;
    aux              = strfind(varNames,'Exper');
    listFound        = getFoundNames(aux);
    % Should be one and only one
    varData         = varNames{listFound};
    data            = eval(varData);
    clear Exper*;
    NTrials = length(data.wl.trials);
    NWhiskers = length(data.wl.trials{1}.theta);
    for k=1:NWhiskers,
        for i=1:NTrials,
            auxtheta = data.wl.trials{i}.theta{k};
            auxtimes = data.wl.trials{i}.time{k};
            if (auxtimes(end)-auxtimes(1))/0.002+1 == length(auxtimes)
                theta = auxtheta;
            else
                theta = (interp1q(auxtimes',auxtheta',[auxtimes(1):0.002:auxtimes(end)]'))';
            end
            if ~isnan(theta)
                [hh amplitude lowPass filteredSignal setpoint amplitudeS amplitudeDS setpointS setpointDS phaseDS] = LeoWhiskerDecomposition(theta);
                RMSE{anm}(k,i) = sqrt(nanmean((abs(hh).*cos(angle(hh))+setpointS'-theta).^2));        
                RMSE_norm{anm}(k,i) = RMSE{anm}(k,i)/sqrt(nanmean(theta.^2));
                NFFT = 2^nextpow2(length(theta));
                y=fft(theta,NFFT)/length(theta);
                f=500/2*linspace(0,1,NFFT/2+1);
                fftData.theta{anm}(k,i,:) = 2*abs(y(1:NFFT/2+1));
                fftData.freqsReal{anm}    = f;
                
                NFFT = 2^nextpow2(length(amplitudeDS));
%                 y=fft(amplitudeDS.*cos(phaseDS)+setpointDS,NFFT)/length(amplitudeDS);
                
                y=fft(amplitudeDS.*0.707+setpointDS,NFFT)/length(amplitudeDS);
                f=16/2*linspace(0,1,NFFT/2+1);
                fftData.recDownsample{anm}(k,i,:) = 2*abs(y(1:NFFT/2+1));
                fftData.freqsDown{anm}    = f;
            end
        end
        summary.RMSE{anm}(k)      = mean(RMSE{anm}(k,:));    
        summary.RMSE_norm{anm}(k) = mean(RMSE_norm{anm}(k,:));    
    end
    summary.allW.RMSE(anm)      = nanmean(RMSE{anm}(:));
    summary.allW.RMSE_norm(anm) = nanmean(RMSE{anm}(:));
    
end