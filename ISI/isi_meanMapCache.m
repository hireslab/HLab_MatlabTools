function isi_meanMapCache(varargin)
%
%   Will display the resulting mean difference image (ISI "blob" map) in 
%    imtool().  May require contrast/brightness adjustment with the imtool().
%
% USAGE: isi_meanMapCache('myrun1')
%        isi_meanMapCache('myrun1','myrun2')
%        isi_meanMapCache('myrun1','myrun2','myrun3')
%        etc...
%
% Input arguments: any number of file names, with or without extensions. 
% Each file should correspond to a 10-minute run of intrinsic signal 
% imaging, and must be *either* a .qcamraw file with the raw data from an
% imaging run, *or* a .mat file with the mean difference image pre-computed
% from the corresponding .qcamraw file (e.g., output from 
% isi_writeMeanRuns.m).  If the extension for a file name is not given
% isi_meanMapCache() will first look for the corresponding .mat file.  
% If not found, it looks for 
% a corresponding file with extension '.qcamraw', loads it and computes the
% mean difference image, and then writes a
% .mat file to the current directory so that subsequent calls to this 
% function will load the .mat file.
%
% For example, isi_meanMapCache('myrun')
% will first try to load a file named 'myrun.mat'. If 'myrun.mat' does not
% exist, it will next try to load a file named 'myrun.qcamraw', and will then
% make file 'myrun.mat'. 

% isi_meanMapCache() will *always* try to load the .mat file first, even
% if the '.qcamraw' extension is given.  I.e., isi_meanMapCache('myrun.qcamraw')
% will first try to load 'myrun.mat'.
%
%
% See files isi_writeRunMeans.m and isi_meanMap.m for explanation of what's 
% computed.
%
% Requires: read_qcamraw.m, Image Processing Toolbox.
%
% DHO, 10/08.
%
%
%
nfiles = nargin;

if nfiles < 1
    error('Must input at least one file name.')
end


stimPeriod = 1:4; basePeriod = 11:20; chunksize = 20; nchunks = 30;

for j=1:nfiles

    fn = varargin{j};
    
    % First, strip file name of any either extension:
    x = strfind(fn,'.qcamraw');
    if ~isempty(x) % argument includes .qcamraw extension
        fn = fn(1:(x-1));
    end

    x = strfind(fn,'.mat');
    if ~isempty(x) % argument includes .mat extension
        fn = fn(1:(x-1));
    end

    % First try to load a .mat file corresponding to file name prefix:
    if exist([fn '.mat'],'file')
        r = load(fn);
        diffMean = r.diffMean;
    % If doesn't exist, try to load corresponding .qcamraw file with 
    % raw data:
    elseif exist([fn '.qcamraw'],'file')
        f = 1;
        for k = 1:nchunks
            rep = read_qcamraw([fn '.qcamraw'], f:(f+chunksize-1));
            stim = mean(rep(:,:,stimPeriod),3);
            base = mean(rep(:,:,basePeriod),3);
            if k==1
                stimMean = stim;
                baseMean = base;
                diffMean = stim-base;
            else
                stimMean = (stimMean + stim)/2;
                baseMean = (baseMean + base)/2;
                diffMean = (diffMean + (stim-base))/2;
            end
            f = f+chunksize;
        end
        % Didn't find .mat file, so write it now:
        outfn = [fn '.mat'];
        save(outfn, 'stimMean', 'baseMean','diffMean');
    else
        error(['Could not find either file ' fn '.qcamraw or ' fn '.mat'])
    end

    % Now we have diffMean for input file.  Average these across files:
    if j==1
        m = diffMean;
    else
        m = m + diffMean;
    end
end

m = m ./ nfiles;

m = m';
%     G = fspecial('gaussian',[5 5],.75);
%     m = imfilter(m,G);
imtool(m,[-10 10])






