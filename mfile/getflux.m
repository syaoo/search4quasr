function dat = getflux(filename,varargin)
% Read source flux in file vlbaCalib.
% fetfulux('file',[flg],[b1],[b2])
%% Input check
narginchk(1,4);
% Valid inputs
validFlg = {'Lg','Sh'};
validB1 = {'S','C','X','U','K'};
validB2 = {'S','C','X','U','K','NAN'};
switch nargin
    case 1
        flg = 'Lg';
        b1 = 'X';
        b2 = 'NAN';
    case 2
        flg = varargin{1};
        b1 = 'X';
        b2 = 'NAN';
    case 3
        flg = varargin{1};
        b1 = varargin{2};
        b2 ='NAN';
    case 4
        flg = varargin{1};
        b1 = varargin{2};
        b2 = varargin{3};
end
flg = validatestring(flg,validFlg);
b1 = validatestring(b1,validB1);
b2 = validatestring(b2,validB2);
%% Main
fid = fopen(filename,'r');
dat = {};
if fid>0
    while ~feof(fid)
        lin = fgetl(fid);
        if length(lin) >100 & regexp(lin(13),'\d') & regexp(lin(20),'\d')
            name = strcat('J', lin(13:20));
            fluxstr = lin(69:95);
            if strcmp(b2,'NAN')
                % single band;
                idx = strfind(fluxstr,b1);
                if idx
                    if strcmp(flg,'Lg')
                        % long baseline.
                        flx1 = str2double(fluxstr(idx+8:idx+12));
                    else
                        % short baseline.
                        flx1 = str2double(fluxstr(idx+2:idx+6));
                    end
                    dat(end+1,1:2) = {name, flx1};
                end
            else
                % two band;
                idx1 = strfind(fluxstr,b1);
                idx2 = strfind(fluxstr,b2);
                if idx1 & idx2
                    if strcmp(flg,'Lg')
                        % long baseline.
                        flx1 = str2double(fluxstr(idx1+8:idx1+12));
                        flx2 = str2double(fluxstr(idx2+8:idx2+12));
                    else
                        % short baseline.
                        flx1 = str2double(fluxstr(idx1+2:idx1+6));
                        flx2 = str2double(fluxstr(idx2+2:idx2+6));
                    end
                    dat(end+1,1:3)={name,flx1,flx2};
                end
            end
        end
    end
    fclose(fid);
else
    error('File open failed, pleas confirm if this file exists.');
end
end