function deg = xyz2deg(vec)
% ����λ���ת��Ϊ�ྭ��γ��
% vec = vec./norm(vec);
idx1 = vec(:,1)>0;
idx2 = vec(:,2)>0;

% Alpha quadrant;
idx = idx1 & idx2;
deg(idx,1) = atand(vec(idx,2)./vec(idx,1));
% Second quadrant;
idx = ~idx1 & idx2;
deg(idx,1) = 180+atand(vec(idx,2)./vec(idx,1));
% Third quadrant;
idx = ~(idx1 & idx2);
deg(idx,1) = 180+atand(vec(idx,2)./vec(idx,1));
% Delta quadrant;
idx = idx1 & ~idx2;
deg(idx,1) = 360+atand(vec(idx,2)./vec(idx,1));

deg(:,2) = atand(vec(:,3)./sqrt(vec(:,1).^2+vec(:,2).^2));
end