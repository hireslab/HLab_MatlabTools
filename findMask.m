function [ mask ] = findMask(xin,yin);
% Find the xy intercepts for two matched x and y vectors
% output is formatted to add to the mask switch

pf = polyfit(xin,yin,1);
[~, xend] = min(abs( polyval(pf,[1:350])));

mask = [1 xend; pf(2) 1];

end

