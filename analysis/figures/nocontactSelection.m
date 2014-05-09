
SU_ConDir = ('Z:\Users\Andrew\Whisker Project\SingleUnit\ConTA\')
SU_TDir =   ('Z:\Users\Andrew\Whisker Project\SingleUnit\TrialArrays\')
Si_ConDir = ('Z:\Users\Andrew\Whisker Project\Silicon\ConTA\')
Si_TDir =   ('Z:\Users\Andrew\Whisker Project\Silicon\CTA\')

SiTNames    = dir([Si_TDir '*CTA*'])
SiConNames  = dir([Si_ConDir '*ConTA*'])
SUTNames    = dir([SU_TDir 'trial_array*'])
SUConNames  = dir([SU_ConDir '*ConTA*'])

for i = 2
    load([Si_TDir SiTNames(i).name])
    load([Si_ConDir SiConNames(i).name])

 trialCondition = T.whiskerTrialNums(cellfun(@(x)x.trialContactType == 0, contacts))

[~,~,c_ind] = intersect(trialCondition, T.trialNums);
[~,~,w_ind] = intersect(trialCondition, T.trialNums);

    cellfun(@(x)x.trialContactType == 0, contacts)

for j = 1:length(c_ind);
    
    if ~isfield(contacts{c_ind(j)},'contactInds')
    elseif ~isempty(contacts{c_ind(j)}.contactInds{1})
        
    end
end

end

