load 140536_Location
M.L{1}=L.shankFinal{1}
cd ..
cd 144441
load 144441_Location
M.L{2}=L.shankFinal{1}
cd ..
cd 144442
load 144442_Location
M.L{3}=L.shankFinal{1}
cd ..
cd 144443
load 144443_Location
L.shankFinal{1}(25:28,:)=mean(cat(3,L.shankFinal{1}(9:12,:),L.shankFinal{1}(13:16,:)),3);
M.L{4}=L.shankFinal{1};
%%

tmp=cat(1,repmat(tmp,1,4)')
%%
for i=1:4
tmp=squareform(pdist(cat(1,[0 0],M.L{i})));
M.dist{i}=tmp(2:end,1)
end


%%
animalName={'ANM140536','ANM144441','ANM144442','ANM144443'};
sessionName{1} = {'110822','110823','110824','110825','110826'};
sessionName{2} = {'110809','110810','110815','110816'};
sessionName{3} = {'110810','110812','110813','110814'};
sessionName{4} = {'110811','110812','110813','110814','110815','110816','110818'};


for i=1:4
    for j=1:length(M.L{i})/4
        for k =1:4
            try
                d=dir(['*' animalName{i} '_' sessionName{i}{j} '_Shank' num2str(k) '*'])
            for l=1:length(d)
                load(d(l).name)
                M.rates{i}{(j-1)*4+k}{l}=S
            end
            end
        end
    end
end

%%
figure(1);clf
hold on


subplot(1,3,1);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.hit(11:30)/max(M.rates{i}{j}{1}.miss(11:30))),'ko','LineWidth',3);
            end
        
    end
end
ylabel('Hit / (class)')
subplot(1,3,2);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.hit(11:30)/max(M.rates{i}{j}{1}.FA(11:30))),'go','LineWidth',3);
            end
        
    end
end

title('Pole Period Modulation - MultiUnit')
xlabel('Distance from C2 center (mm)')
subplot(1,3,3);cla;hold on

for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.hit(11:30)/max(M.rates{i}{j}{1}.CR(11:30))),'ro','LineWidth',3);
            end
        
    end
end

        

%%
figure(1);clf
hold on


subplot(1,4,1);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.hit(11:30)/max(M.rates{i}{j}{1}.hit(1:10))),'bo','LineWidth',3);
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,2);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.miss(11:30)/max(M.rates{i}{j}{1}.miss(1:10))),'ko','LineWidth',3);
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,3);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.FA(11:30)/max(M.rates{i}{j}{1}.FA(1:10))),'go','LineWidth',3);
            end
        
    end
end

title('Pole Period Modulation - MultiUnit')
xlabel('Distance from C2 center (mm)')


subplot(1,4,4);cla;hold on

for i=1:4
    for j=1:length(M.L{i})
            try
                    plot(M.dist{i}(j),max(M.rates{i}{j}{1}.hit(11:30)/max(M.rates{i}{j}{1}.CR(1:10))),'ro','LineWidth',3);
            end
        
    end
end

        

   %%
   figure(1);clf
hold on


subplot(1,4,1);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.hit(11:30)/max(M.rates{i}{j}{k}.hit(1:10))),'bo','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,2);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.miss(11:30)/max(M.rates{i}{j}{k}.miss(1:10))),'ko','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,3);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.FA(11:30)/max(M.rates{i}{j}{k}.FA(1:10))),'go','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,4);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.CR(11:30)/max(M.rates{i}{j}{k}.CR(1:10))),'ro','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')
   %%
   figure(1);clf
hold on


subplot(1,4,1);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.hit(11:30)/max(M.rates{i}{j}{k}.miss(11:30))),'ko','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,2);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.hit(11:30)/max(M.rates{i}{j}{k}.FA(11:30))),'go','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')

subplot(1,4,3);cla;hold on
for i=1:4
    for j=1:length(M.L{i})
        
            try
                for k=1:(length(M.rates{i}{j})-1)
                    plot(M.dist{i}(j),max(M.rates{i}{j}{k}.hit(11:30)/max(M.rates{i}{j}{k}.CR(11:30))),'ro','LineWidth',3);
                end
            end
        
    end
end
ylabel('Hit / (class)')


