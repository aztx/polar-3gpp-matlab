addpath '../spectre/bi-awgn'

A = [12:15, 16:2:30, 32:4:60, 64:8:120, 128:16:240, 256:32:480, 512:64:960, 1024:128:1706];
E = [54 108 216 432 864 1728 3456 6912 13824];


K = zeros(size(A));
K(A<=19) = A(A<=19)+3;
K(A>19) = A(A>19)+8;



% Create a figure to plot the results.
figure
axes1 = axes;
ylabel('Required E_s/N_0 [dB]');
xlabel('A');
xt = 0:11;
set(gca, 'XTick', xt);
set (gca, 'XTickLabel', 2.^xt);
grid on
hold on
drawnow

for E_index = 1:length(E)
    
    % Create the plot
    plots(E_index) = plot(nan,'Parent',axes1);
    legend(cellstr(num2str(E(1:E_index)', 'G=%d, capacity')),'Location','eastoutside');
    
    EsN0s = nan(1,length(A));
    
    plot_EsN0s = [];
    plot_As = [];
    for A_index = 1:length(A)
        if E(E_index) <= 8192 || (E(E_index) > 8192 && A(A_index) >= 360)
            if K(A_index)+3 <= E(E_index)
                EsN0 = converse_mc(E(E_index), 0.001, K(A_index)/E(E_index),'On2','error');
                if isempty(plot_EsN0s) || EsN0 > plot_EsN0s(end)
                    plot_EsN0s(end+1) = EsN0;
                    plot_As(end+1) = A(A_index);
                    
                    % Plot the SNR vs A results
                    set(plots(E_index),'XData',log2(plot_As));
                    set(plots(E_index),'YData',plot_EsN0s);
                    
                    xlim auto;
                    xl = xlim;
                    xlim([floor(xl(1)), ceil(xl(2))]);
                    
                    drawnow;
                    
                end
                
            end
        end
    end
end