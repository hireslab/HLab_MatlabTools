
filelist = dir('*.xsg')
for i = 78:length(filelist)
    load (filelist(i).name, '-mat') 
    data.acquirer.trace_1(1:end-9900)=data.acquirer.trace_1(9901:end)
    save(filelist(i).name, 'data', 'header', '-mat')
end

