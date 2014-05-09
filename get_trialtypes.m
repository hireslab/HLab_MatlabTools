for j=1:length(fieldnames(U))
    for i=1:5
        trialTypes(j,i)=sum(cellfun(@(x)x.trialContactType,U.(cellNames{j}).contacts)==i-1);
    end
end
