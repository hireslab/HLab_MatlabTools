function runlines(mfile, readlines)
% Runs mfile script lines specified by readlines
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
    readlines = 1:length(M);
end

if length(readlines) > numel(M)
    error(['Script contains only ' num2str(numel(M)) ' lines.'])
end

for k=readlines
    try
        evalin('base',M{k})
    catch ME
        error('RunLines:ScriptError',...
            [ME.message '\n\nError in ==> ' mfile ' at ' num2str(k) '\n\t' M{k}]);
    end
end