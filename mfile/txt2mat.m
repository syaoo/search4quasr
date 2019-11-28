% read data from txt file,then process data and svae in mat file.

clear
icrf3sx=readfile('../icrf3sx.txt');
icrf3k=readfile('../icrf3k.txt');
icrf3xka=readfile('../icrf3xka.txt');
vlba=readfile('../vlbaCalib.txt','vlba');
fluxdat = getflux('../vlbaCalib.txt','lg','x');
sinfo = struct();
% find the same soure in ICRF3K,ICRF3SX and ICRF3XKA, and remove it.
allsrc  = icrf3sx;
len = length(icrf3sx);
sinfo.icrf3sx = len;

[~,~,idx] = intersect(icrf3k(:,1),allsrc(:,1));
allsrc(idx,:)=[];
len = length(icrf3k);
sinfo.icrf3k = len;
allsrc(end+1:end+len,:)=icrf3k;

[~,~,idx] = intersect(icrf3xka(:,1),allsrc(:,1));
allsrc(idx,:)=[];
len = length(icrf3xka);
sinfo.icrf3xka = len;
allsrc(end+1:end+len,:)=icrf3xka;
% Now all icrf source are in ICRF3 cell(ICRF name and RA,DEC).

% find same source in ICRF3 and VLBA, then mearge it with ICRF3 data.
[~,~,idx] = intersect(vlba(:,1),allsrc(:,1));
allsrc(idx,:)=[];
len = length(vlba);
sinfo.vlba = len;
allsrc(end+1:end+len,:)=vlba;

save('sourcedata.mat','allsrc','sinfo','fluxdat');