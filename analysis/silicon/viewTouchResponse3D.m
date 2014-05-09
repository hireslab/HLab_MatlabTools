 figure(10); cla;hold on
        
        colors = jet(112);
        for i=1:148
            
            value(i) = (max(S.M0ConMod{i}{1}(:,1))-min(S.M0ConMod{i}{2}(:,1)))/(S.M0ConMod{i}{3}(1))
        end
        coloring = zeros(length(value),3);
            coloring(value > 1,:) = repmat([1 0 0 ], sum(value >1),1); 

for i=1:148
    
            try
            plot3(S.recordingLocation{i}(1)+(rand-.5)*.05,-S.recordingLocation{i}(2)+(rand-.5)*.05,-S.recordingLocation{i}(3)+(rand-.5)*.04,'o',...
                'Color', coloring(i,:),'MarkerSize', 6)
            end
        
        t = 0:.25:2*pi
end




        for i=2:8
                    plot3(.13*sin(t),.13*cos(t),repmat(-.1*i,length(t)),'r')
        end

        axis equal
        grid on 