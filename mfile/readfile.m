function dat = readfile(filename,varargin)
% read vlbaCalib.txt;
% only save source item that has OTHER name.
%% Input check
narginchk(1,2);
switch nargin
    case 1
        fcls = 'icrf3';
    case 2
        fcls = varargin{1};
        validfcls = {'vlba','icrf3'};
        fcls = validatestring(fcls,validfcls);
end
%% Main
fid = fopen(filename,'r');
dat = {};
if fid >0
    if strcmp(fcls,'vlba')
        % read vlbacalib file.
        while ~feof(fid)
            lin = fgetl(fid);
            if length(lin) >100 & regexp(lin(13),'\d') & regexp(lin(20),'\d')
                dat(end+1,1:3) = {strcat('J', lin(13:20)),...
                    [str2double(lin(23:24)),str2double(lin(26:27)),str2double(lin(29:37))],...
                    [str2double(lin(40:42)),str2double(lin(44:45)),str2double(lin(47:54))]};
            end
        end
    else
        % read icrf3 file.
        while ~feof(fid)
            lin = fgetl(fid);
            if length(lin) >100 & regexp(lin(26),'\d') & regexp(lin(33),'\d')
                dat(end+1,1:3) = {strcat('J', lin(26:33)),...
                    [str2double(lin(41:42)),str2double(lin(44:45)),str2double(lin(47:57))],...
                    [str2double(lin(62:64)),str2double(lin(66:67)),str2double(lin(69:78))]};
            end
        end
    end
    fclose(fid);
else
    error('File open failed, pleas confirm if this file exists.');
end
end
