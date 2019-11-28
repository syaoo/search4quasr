function  dec = hms2dec(RA,DEC)
% HMS2DEG����ʮ���ƾ�γת��Ϊʮ���ƣ�
% RA���ྭ[HH MM SS.SSSSS]
% DEC����γ[+/-DD MM SS.SSSSS]
dec(:,1) = (RA(:,1).*15+RA(:,2)./4+RA(:,3)./240);
dec(:,2) = (DEC(:,1)+DEC(:,2)./60+DEC(:,3)./3600);

% x=sin(DEC_deg).*cos(RA_deg);
% y=sin(DEC_deg).*sin(RA_deg);
% z=cos(DEC_deg);
end