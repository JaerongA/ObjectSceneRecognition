
ratNumber = 214;
sessionSize = 11;

graphRoot = ['H:\rat', num2str(ratNumber),'\position analysis\position_',num2str(ratNumber)];
root = ['H:\rat', num2str(ratNumber),'\position analysis'];

if ~exist(graphRoot)
    mkdir(graphRoot)
end

for iter = 1:sessionSize
    sessionRoot = [root,'\rat',num2str(ratNumber),'_',num2str(iter)];
    load([sessionRoot '\ParsedPosition.mat']);
    
    posN = length(x); % will not be needed after revising.

    flag = void(:,1) & side(:,1);
    flag = flag & ~area(:,5);

    plot(x(flag),(y(flag)),'.','Color',[1 0 0], 'MarkerSize', 2);
    
    hold on;
    
    flag = void(:,1) & side(:,2);
    flag = flag & ~area(:,5);
    
    plot(x(flag),(y(flag)),'.','Color',[0 0 1], 'MarkerSize', 2);

    x = [345.3 380.2 380.2 423.1 423.1 302.1 302.1 345.3 345.3];
    y = [391.7 391.7 228.8 228.8 176.8 176.8 228.8 228.8 391.7];
    
    plot(x,y);
    
    saveas(gcf, [graphRoot '\' 'rat',num2str(ratNumber),'_',num2str(iter),'.png']);
    
    hold off;
end