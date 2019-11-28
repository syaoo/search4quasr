% ֱ�ӱȽϳྭ��γ�Ĳ�
% ����������ַ�'Sun' | 'Mercury' | 'Venus' | 'Earth' | 'Moon' |
% 'Mars' | 'Jupiter' | 'Saturn' | 'Uranus' | 'Neptune' | 'Pluto' | 
clear

load('sourcedata.mat', 'allsrc');
dat = allsrc;
drc = hms2dec(cell2mat(dat(:,2)),cell2mat(dat(:,3)));
drc = deg2xyz(drc);

% years = ["2023-1-1","2024-1-1","2025-1-1","2026-1-1","2027-1-1"];
years = ["2027-1-1","2028-1-1","2029-1-1","2030-1-1","2031-1-1"];

for st =1:4
% st ='2027-1-1';
% et ='2031-1-1';
startime = juliandate(datetime(years(st)));
endtime = juliandate(datetime(years(st+1))); 
step = 2/24;
tarr = startime:step:endtime-step;

fname=strcat(years(st),'.txt');
% fname = 'tt.txt';
f=fullfile('../data1',fname);
fid = fopen(f,'w');
tit = ["DateTime","Name","RA","DEC","E_Theta","M_Theta"];
fprintf(fid,'%+19s\t %+16s\t %+17s\t %+17s\t %+9s\t %+9s\n',tit);

for nt = tarr
    datetime(nt,'convertfrom','juliandate')
    vec1 = planetEphemeris(nt,'Earth','Sun','430','km');
    vec2 = planetEphemeris(nt,'Moon','Sun','430','km');
    for i = 1:size(drc,1)
        theta = acosd(dot(vec1,drc(i,:))/(norm(vec1)*norm(drc(i,:))));
        theta1 = acosd(dot(vec2,drc(i,:))/(norm(vec2)*norm(drc(i,:))));
     
        if theta <= 15
            tt = datetime(nt,'convertfrom','juliandate');
            tt.Format='yyyy-MM-dd HH:mm:ss';
            fprintf(fid,'%s\t',tt);
            fprintf(fid, '%s\t',dat{i,1});
            fprintf(fid,'%02.0f %02.0f %011.8f\t',dat{i,2});
            fprintf(fid,'%02.0f %02.0f %010.7f\t',dat{i,3});
            fprintf(fid,'%09.5f\t %09.5f\n',theta,theta1);
        end
    end
end
fclose(fid);
end