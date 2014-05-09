% Varargin elements can be 
% mode (equalN or equalX) equal number of elements in each bin or equal
% spacing.
% binBounds (vector of bin boundries)
% 

function [sorted sortedBy binBounds binInds]=binsLinInds(sortBy, toSort, sortMode, binBounds);
if isempty(sortBy) | isempty(toSort)
    sorted={[]};
    sortedBy={[]};
    binBounds={[]};
    disp('Empty input');
else
    if length(binBounds)==1
        if strcmp(sortMode,'equalX');
            binBounds=linspace(min(sortBy),max(sortBy),binBounds);
        elseif strcmp(sortMode,'equalN')
            tmp=sort(sortBy); % arrange the data for equalN indexing
            tmp=tmp(1:sum(isnan(tmp(:))==0)); %remove the NaNs (assumes there is at least 1 non NaN in the input)
            binBounds=round(0:(length(tmp)/binBounds):length(tmp));
            binBounds(1:end-1)=binBounds(1:end-1)+1;
            binBounds=tmp(binBounds)';


        else
        end

    end
        sorted      = cell(length(binBounds)-1,1);
        sortedBy    = cell(length(binBounds)-1,1);
        
    for i=1:length(binBounds)-1
        sorted{i}   = toSort(sortBy>binBounds(i) & sortBy<=binBounds(i+1));
        sortedBy{i} = sortBy(sortBy>binBounds(i) & sortBy<=binBounds(i+1));
        binInds{i}  = find(sortBy>binBounds(i) & sortBy<=binBounds(i+1));
    end
end
   