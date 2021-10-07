function makePlotExpCodecs(Tin,DoF,Content,dataset,lwidth)
    rows = Tin.DoF == DoF & Tin.Content == Content;
    %rows =  Tin.Content == Content;
    T = Tin(rows,:);
    rows = T.Codec == 1;
    TContent = sortrows(T(rows,:),'Rate');
    X = TContent.Rate;
    Y = TContent.DMOS;
    CI = abs(TContent.CIHigh - TContent.CILow)/2;
    errorbar(X,Y,CI,'Color','green','LineStyle','--','Linewidth',lwidth);
    %legend('V-PCC');
    hold on;
    Y = TContent.HRScore;
    CI = abs(TContent.HRCIHigh - TContent.HRCILow)/2;
    errorbar(X,Y,CI,'Color','black','LineStyle','--');
    %legend('HR');
    hold on;
    rows = T.Codec == 2;
    TContent = sortrows(T(rows,:),'Rate');
    X = TContent.Rate;
    Y = TContent.DMOS;
    CI = abs(TContent.CIHigh - TContent.CILow)/2;
    errorbar(X,Y,CI,'Color','blue','Linewidth',lwidth);
    hold on;
    %Add other codecs + tiling approaches
    rows = T.Codec == 3;
    TContent = sortrows(T(rows,:),'Rate');
    X = TContent.Rate;
    Y = TContent.DMOS;
    CI = abs(TContent.CIHigh - TContent.CILow)/2;
    errorbar(X,Y,CI,'Color','red','Linewidth',lwidth);
    
%     rows = T.Codec == 4;
%     TContent = sortrows(T(rows,:),'Rate');
%     X = TContent.Rate;
%     Y = TContent.DMOS;
%     CI = abs(TContent.CIHigh - TContent.CILow)/2;
%     errorbar(X,Y,CI,'Color','cyan');
    
    
    rows = T.Codec == 4;
    TContent = sortrows(T(rows,:),'Rate');
    X = TContent.Rate;
    Y = TContent.DMOS;
    CI = abs(TContent.CIHigh - TContent.CILow)/2;
    errorbar(X,Y,CI,'Color','#964B00','Linewidth',lwidth);
    
    
%     rows = T.Codec == 6;
%     TContent = sortrows(T(rows,:),'Rate');
%     X = TContent.Rate;
%     Y = TContent.DMOS;
%     CI = abs(TContent.CIHigh - TContent.CILow)/2;
%     errorbar(X,Y,CI,'Color','black');
    
    rows = T.Codec == 5;
    TContent = sortrows(T(rows,:),'Rate');
    X = TContent.Rate;
    Y = TContent.DMOS;
    CI = abs(TContent.CIHigh - TContent.CILow)/2;
    errorbar(X,Y,CI,'Color','black','Linewidth',lwidth);
    %End of individual codec part 
    
    %legend('V-PCC','HR','CWI-PCC','Greedy','Hybrid','Uniform','GreedyPrime','WeightedHybrid');
    legend('V-PCC:Naive','Uncompressed-Original','Anchor:Naive','Anchor:Adaptive-Greedy','Anchor:Adaptive-Uniform','Anchor:Adaptive-WHybrid');
    %title("T" + dataset + " DoF " + DoF + " Content " + Content);
    xlabel('Bandwidth in Mbit/sec');
    ylabel('Mean Opinion Score');
    xlim([0 inf]);
    ylim([1 6]);
    %xticks([1 2 3 4]);
    legend('Location','southeast');
    hold off;
    ax = gca;
    %exportgraphics(ax,'Charts/test1234.jpg');
    %exportgraphics(ax,"Charts/T"+dataset+"DoF"+DoF+"Content"+Content+".jpg");
    saveas(ax,"Charts/T"+dataset+"DoF"+DoF+"Content"+Content+".jpg");
end
