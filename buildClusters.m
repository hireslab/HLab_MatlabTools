%baseDir = 'Q:\Silicon\';
%behavDir = 'Q:\Silicon\Behavior\SoloArrays\'

baseDir = 'Q:\Silicon\Mouse\'
behavDir = 'Q:\Silicon\Behavior\SoloArrays\'

d_b = dir([behavDir 'solo*'])
d_behav=cell(length(d_b),1);
for i=1:length(d_b);
    d_behav{i} = d_b(i).name;
end
cd(baseDir)
d1 = dir('*ANM140536*')
for i = 1:length(d1)
    cd(d1(i).name)
    d2 = dir('*110823*')
    
    for j=1:length(d2)
        cd(d2(j).name)
        d21 = [pwd filesep]
        cd('extract')
        d3 = dir('*Export*')
        
        for k=1:length(d3)
            load(d3(k).name)
            load([d3(k).name(8:13) '_summary'])
           
            load([behavDir d_b(find(cellfun(@(x)~isempty(strfind(x,d2(j).name)),d_behav) & ...
                cellfun(@(x)~isempty(strfind(x,d1(i).name(4:end))),d_behav))).name])
            summarizeCluster(eval(d3(k).name(8:13)), str2num(d3(k).name(13)), d21, clustparam,b)
            eval('clear shank*');
            
        end
        cd ..
        cd ..
    end
    cd ..
end

        

           
        