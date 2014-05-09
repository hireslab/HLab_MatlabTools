lickTime=nan(length(U.AH26.behavTrials),1);
for i=1:length(U.AH26.behavTrials)
    if isfinite(U.AH26.behavTrials{i}.answerLickTime)
    lickTime(i)=U.AH26.behavTrials{i}.answerLickTime;
    end
end

angles=cell(length(U.AH26.behavTrials),1);
for i=[1:114 116:length(U.AH26.behavTrials)]
    if numel(U.AH26.behavTrials{i}.answerLickTime)
        j=find(U.AH26.time{i}{1} > U.AH26.behavTrials{i}.pinDescentOnsetTime+U.AH26.params.poleOffset...
            & U.AH26.time{i}{1} < U.AH26.behavTrials{i}.answerLickTime);
        angles{i}=T.trials{i}.whiskerTrial.thetaAtBase{1}(j);
    else
        j=find(U.AH26.time{i}{1} > U.AH26.behavTrials{i}.pinDescentOnsetTime+U.AH26.params.poleOffset...
            & U.AH26.time{i}{1} < U.AH26.params.meanAnswerTime);
        angles{i}=T.trials{i}.whiskerTrial.thetaAtBase{1}(j);
    end
end
%%
angleHist=zeros(length(-50:90),length(U.AH26.behavTrials));
for i=find(U.AH26.info.hitTrialInds)
    angleHist(:,i)=histc(angles{i},-50:90);
end
for i=find(U.AH26.info.correctRejectionTrialInds)
    angleHist(:,i)=histc(angles{i},-50:90);
end
hitSum=sum(angleHist(:,find(U.AH26.info.hitTrialInds)),2)
crSum=sum(angleHist(:,find(U.AH26.info.correctRejectionTrialInds)),2)