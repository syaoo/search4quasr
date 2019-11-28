clear
datpath = '../data1/out';
picpath = '../data1/out1';
files = {'min2023-1-1.txt','min2026-1-1.txt','min2029-1-1.txt',...
    'min2024-1-1.txt','min2027-1-1.txt','min2030-1-1.txt',...
    'min2025-1-1.txt','min2028-1-1.txt'};
load('sourcedata.mat','fluxdat');
% files2 = {'sort2030-1-1.txt','sort2024-1-1.txt','sort2025-1-1.txt',...
%     'sort2026-1-1.txt','sort2027-1-1.txt','sort2028-1-1.txt',...
%     'sort2029-1-1.txt','sort2023-1-1.txt'};
idx = cell2mat(fluxdat(:,2)) == -9.99;
fluxdat = fluxdat(~idx,:);
idx = cell2mat(fluxdat(:,2)) < 0;
fluxdat(idx,2) = num2cell(-cell2mat(fluxdat(idx,2)));
rge = {[0 0.25],[0.25 1],[1 2],[2 5],[5 15]};
for f =files
    for r = rge
        figure
        fid=fopen(fullfile(datpath,f{1}));
        dat=textscan(fid,'%s %s %s %s %f %f',"Delimiter",'\t',"HeaderLines",1);
        idx = dat{5}>=r{1}(1) & dat{5} < r{1}(2);
        
        x = datetime(dat{1}(idx));
        y = dat{5}(idx);
        plot(x,y,'.r','MarkerSize',5)
        hold on
        [c,idx1,idx2]=intersect(fluxdat(:,1),dat{2}(idx));
%         scatter(x(idx2),y(idx2),15,cell2mat(fluxdat(idx1,2))*400);
        scatter(x(idx2),y(idx2),cell2mat(fluxdat(idx1,2))*400,cell2mat(fluxdat(idx1,2)),'filled');
        h = colorbar;
        colormap('winter')
        h.Label.String='Flux (Jy)';
        ylabel('Flux(Jy)')
        ylabel('Angle of Q_S_E (Deg)','Interpreter','none')
        title(strcat(string(r{1}(1)),'-',string(r{1}(2))))
        grid on
        ax = gca;
        ax.GridLineStyle='-.';
        set(gcf,'position',get(0,'screensize'));
        th = strcat(num2str(r{1}(1)),f{1}(1:7),'.fig');
        saveas(gcf,fullfile(picpath,th));
        th = strcat(num2str(r{1}(1)),f{1}(1:7),'.png');
        saveas(gcf,fullfile(picpath,th));
        close(gcf)
    end
end


% for f =files
% %     figure
%     fid=fopen(fullfile(datpath,f{1}));
%     dat=textscan(fid,'%s %s %s %s %f %f',"Delimiter",'\t',"HeaderLines",1);
%     plot(datetime(dat{1}),dat{5},'.');
%     hold on
% end
% leg = {'2023','2024','2025','2026','2027','2028','2029','2030'};
% legend(leg,'Location','northeastoutside');
% title('time & angle');
% ylabel('Deg')