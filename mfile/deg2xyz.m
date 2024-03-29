function xyz = deg2xyz(deg)
% convert RA&DEC to XYZ
% deg = [RA,DEC]
narginchk(1,1);
xyz(:,1)=cosd(deg(:,2)).*cosd(deg(:,1));
xyz(:,2)=cosd(deg(:,2)).*sind(deg(:,1));
xyz(:,3)=sind(deg(:,2));
end