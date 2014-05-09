function runfromto(mfile, lfrom, lto)
% Runs mfile script from line lfrom to line lto.
if nargin < 1
    error('No script m-file specified.');
end
if ~strcmp(mfile(end-1:end),'.m')
    mfile = [mfile '.m'];
end
if ~exist(mfile,'file')
    error(['Cannot access ' mfile])
end
M = textread(mfile,'%s','delimiter','\n');
if nargin < 2
    lfrom = 1;
end
if nargin < 3 || lto > numel(M)
    lto = numel(M);
end
if lfrom > numel(M)
    error(['Script contains only ' num2str(numel(M)) ' lines.'])
end

for k=lfrom:lto
    try
        evalin('base',M{k})
    catch ME
        error('RunFromTo:ScriptError',...
            [ME.message '\n\nError in ==> ' mfile ' at ' num2str(k) '\n\t' M{k}]);
    end
end