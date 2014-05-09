function output=bins(dataSet, spikeRate, varargin)
    if nargin==2
        inputVector=linspace(min(dataSet),max(dataSet),25)
    else
    end
        output=cell(length(inputVector)-1,1);
for i=1:length(inputVector)-1
    output{i}=spikeRate(dataSet>inputVector(i) & dataSet<=inputVector(i+1));
end
