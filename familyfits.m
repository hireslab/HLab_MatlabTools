% whisker trial time offset already taken into account when generating
% fitting curves


h = waitbar(0,'Sorting Arrays');
j=8
l=length(T.trials);
spikes=cell(l,1);
M0y=cell(l,1);
Vy=cell(l,1);

fittingParam='velocity'

for i=1:l;

spikes{i}=zeros(4600,1);
M0y{i}=zeros(4600,1);
Vy{i}=zeros(4600,1);

vel=T.get_whisker_velocity(0,T.trialNums(i));

   waitbar(i/l,h);
    if round(T.trials{i}.spikesTrial.spikeTimes/10)
        spikes{i}(round(T.trials{i}.spikesTrial.spikeTimes/10))=1;
    end
    
        for k=1:j
        M0y{i}(round(T.trials{i}.whiskerTrial.time{1}*1000-2.5+5*k),k) = m0fit{k}(contacts{i}.M0combo{1});
 
        
        Vy{i}(round(T.trials{i}.whiskerTrial.time{1}(vel{1}>=0)*1000-2.5+5*k),k) = polyval(velocityfit{k}(:,1),vel{1}(vel{1}>=0));
        Vy{i}(round(T.trials{i}.whiskerTrial.time{1}(vel{1}<0)*1000-2.5+5*k),k)  = polyval(velocityfit{k}(:,2), vel{1}(vel{1}<0));

        
    end
    M0y{i}=mean(M0y{i},2);
    Vy{i}=mean(Vy{i},2);

end
close(h);


%%
figure(103)
a=.5;
b=.7;

i=51;
subplot(3,1,1)
cla;
plot(contacts{i}.M0combo{1})
axis([0 4500 min(contacts{i}.M0combo{1}) max(contacts{i}.M0combo{1})])

subplot(3,1,2)
cla;
hold on;
vel=T.get_whisker_velocity(0,T.trialNums(i));
plot(vel{1},'g');
axis([0 4500 min(vel{1}) max(vel{1})])

subplot(3,1,3)
cla;
hold on
plot(a*round(M0y{i}-T.meanSpikeRateInHz));
plot(b*round(Vy{i}-T.meanSpikeRateInHz),'g');
plot(round(a*(M0y{i}-T.meanSpikeRateInHz)+b*(Vy{i}-T.meanSpikeRateInHz)),'k');
%plot(a*(M0y{i}-T.meanSpikeRateInHz));
%plot(b*(Vy{i}-T.meanSpikeRateInHz),'g');

rspikes=smooth(spikes{i},50)*50;
plot(rspikes,'r')
% plot(smooth(fy,25),'g');z
% plot(floor(smooth(mean(fy,2),25)));
% hold on
% plot(smooth(spikes{i},50)*50,'r')
axis([0 4500 0 max(cat(1,rspikes(:), round(a*(M0y{i}-T.meanSpikeRateInHz)+b*(Vy{i}-T.meanSpikeRateInHz))))]);

%rms=sqrt(nanmean(round(smooth(M0y{i},10)-T.meanSpikeRateInHz)-smooth(spikes{i},50)*50)^2)./sqrt(nanmean(smooth(spikes{i},50)*50).^2)

%%
figure
for i=1:20
%plot(M0y{i}+2*i,'g');
hold on
plot((M0y{i}+2*i),'r.');
plot(smooth(spikes{i},50)*50+2*i,'o')
end

%%
rms=zeros(119,1);
for i=1:119
    rms2(i)=sqrt(nanmean(round(M0y{i}-T.meanSpikeRateInHz)-smooth(spikes{i},50)*50)^2)./sqrt(nanmean(smooth(spikes{i},50)*50).^2);
end
nanmean(rms2)

%%
figure(104);cla;
a=2;
i=51;
windowSize=50;
testTrials=1:119

for i=testTrials
%plot(1:windowSize:length(spikes{i}),sum(reshape(spikes{i},windowSize,length(spikes{i})/windowSize))*.3+i,'ro')
hold on
plot(1:windowSize:length(Vy{i}),round(a*mean(reshape(Vy{i},windowSize,length(M0y{i})/windowSize))-T.meanSpikeRateInHz)*.3+i,'.');
end
axis([0 length(spikes{i}) testTrials(1) testTrials(end)+1]);

%%

fittingParam='both';

a=(.5);
b=(.7)
prratio=zeros(length(a),1);
for j=1:length(a)
windowSize =50;

switch fittingParam
    
    case 'M0'
    
        for i=1:119
            realSpikes(:,i)=sum(reshape(spikes{i},windowSize,length(spikes{i})/windowSize));
            predictedSpikes(:,i)=round(a(j)*mean(reshape(M0y{i},windowSize,length(M0y{i})/windowSize))-T.meanSpikeRateInHz);

          

        end
    
    case 'velocity'
        
        for i=1:119
        realSpikes(:,i)=sum(reshape(spikes{i},windowSize,length(spikes{i})/windowSize));
        predictedSpikes(:,i)=round(b(j)*mean(reshape(Vy{i},windowSize,length(Vy{i})/windowSize))-T.meanSpikeRateInHz);

        end
     
    case 'both'
        
         for i=1:119
        realSpikes(:,i)=sum(reshape(spikes{i},windowSize,length(spikes{i})/windowSize));
        predictedSpikes(:,i)=round(  a(j)*mean(reshape(M0y{i},windowSize,length(M0y{i})/windowSize)-T.meanSpikeRateInHz)...
            +b(j)*mean(reshape(Vy{i},windowSize,length(Vy{i})/windowSize)-T.meanSpikeRateInHz));
        
        end
        
    otherwise
end
predictedSpikes(predictedSpikes<0)=0;
excessSpikes=sum(nansum((predictedSpikes((predictedSpikes(:)-realSpikes(:))>0)...
    -realSpikes((predictedSpikes(:)-realSpikes(:))>0))))
missingSpikes=sum(nansum((realSpikes((realSpikes(:)-predictedSpikes(:))>0)...
    -predictedSpikes((realSpikes(:)-predictedSpikes(:))>0))))
correctSpikes=nansum(realSpikes(:))-missingSpikes
prratio(j)=correctSpikes/(excessSpikes+nansum(realSpikes(:)))
end