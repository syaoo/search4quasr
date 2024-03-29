% ֱ�ӱȽϳྭ��γ�Ĳ�
% ����������ַ�'Sun' | 'Mercury' | 'Venus' | 'Earth' | 'Moon' |
% 'Mars' | 'Jupiter' | 'Saturn' | 'Uranus' | 'Neptune' | 'Pluto' | 
clear
% filename1 = 'icrf3sx.txt';
% dat1 = readfile1(filename1);
% % dec = hms2dec(cell2mat(dat(:,5:7)),cell2mat(dat(:,8:10)));
% 
% filename2 = 'vlbaCalib.txt';
% dat2 = readfile(filename2,"J\d");

load sourcedata.mat
dat = allsrc;
dec = hms2dec(cell2mat(dat(:,2)),cell2mat(dat(:,3)));
drc = deg2xyz(dec);
% ����ֵ
% c=3e8; % m/s
% M_sun = 1.9891e30; %kg
% G = 6.67e-11; % N*m^2/kg^2 = (kg*m/s^2)*m^2/kg^2
% GM = G*M_sun;
% U_tau = - 2*GM/c^3; % s
st ='2026-7-1';
et ='2026-7-1 2:0';
startime = juliandate(datetime(st));
endtime = juliandate(datetime(et)); 
step = 2/24;
tarr = startime:step:endtime-step;

idxs=zeros(size(dec,1),1);
% fname=strcat(st,'.txt');
% fname = 'tt1.txt';
% f=fullfile('../data',fname);
% fid = fopen(f,'w');
% tit = ["DateTime","Name","RA","DEC","E_Theta","M_Theta"];
% fprintf(fid,'%+19s\t %+16s\t %+17s\t %+17s\t %+9s\t %+9s\n',tit);
% sss = 0
for nt = tarr
    datetime(nt,'convertfrom','juliandate')
    vec1 = planetEphemeris(nt,'Earth','Sun','430','km');
    vec2 = planetEphemeris(nt,'Moon','Sun','430','km');
    % test
    p1 = -planetEphemeris(nt,'SolarSystem','Earth','430','km');
    p2 = -planetEphemeris(nt,'SolarSystem','sun','430','km');
    vec = p1-p2;
    RD = xyz2deg(vec1);
    rang1 = 18;
    rang2 = 16;
    idx1 = dec(:,1)>RD(:,1)-rang1 & dec(:,1)<RD(:,1)+rang1;
    idx2 = dec(:,2)>RD(:,2)-rang2 & dec(:,2)<RD(:,2)+rang2;
    idx = idx1 & idx2;
    sum(idx)
    sdec = deg2xyz(dec(idx,:));
%     drc = drc(idx,:);
    ndat = dat(idx,:);
    for i = 1:size(sdec,1)
        theta = acosd(dot(vec1,sdec(i,:))/(norm(vec1)*norm(sdec(i,:))));
        qsa = p1-sdec(i,:);
        theta11 = acosd(dot(vec,qsa)/(norm(vec)*norm(qsa)));
        theta12 = acosd(dot(vec,sdec(i,:))/(norm(vec)*norm(sdec(i,:))));
        % theta == theta12; theta ~= theta11;
        theta1 = acosd(dot(vec2,sdec(i,:))/(norm(vec2)*norm(sdec(i,:))));
%         sss=sss+(theta == theta11);
        if theta <= 15
            idxs(i)=1;
            tt = datetime(nt,'convertfrom','juliandate');
            fprintf(fid,'%s\t',tt);
            fprintf(fid, '%s\t',ndat{i,1});
            fprintf(fid,'%02.0f %02.0f %011.8f\t',ndat{i,2});
            fprintf(fid,'%02.0f %02.0f %010.7f\t',ndat{i,3});
            fprintf(fid,'%09.5f\t %09.5f\n',theta,theta1);
        end
    end
%     sss
end
fclose(fid);


%%
function delta_tau=caldt(vec1,vec2,vec4,U_tau)
% DELTA_TAU�������ڼ���������˵�̨վ������"G_source"������ʱ�Ӳ
% vec1: ̨վ1��������ķ���ʸ����E_S
% vec2: ̨վ2���������λ��ʸ����M_S

% ��λ��
vec1 = vec1/norm(vec1);
vec2 = vec2/norm(vec2);
vec4 = vec4/norm(vec4);

% acos(dot(vec13,vec14)/(norm(vec13)*norm(vec14)))*180/pi
% acos(dot(vec23,vec24)/(norm(vec23)*norm(vec24)))*180/pi
delta_tau = -U_tau*log((1-dot(vec1,vec4))/(1-dot(vec2,vec4)));
end