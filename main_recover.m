% ========================================================================
% USAGE: [position, kw, kh, pd] = main_recover(filename, imgnum)
% Recover Source Image
%
% Inputs
%       filename     -filename of the image
%       imgnum       -image No
%
% Outputs
%       position       -positions of source patches
%       kw           -width of kernel
%       kh           -height of kernel
%       pd           -depth of patch
%
% Hang Zhou, November 21, 2015
% ========================================================================

function [position, kw, kh, pd] = main_recover(filename, imgnum)

%% Read synthetic image S
origimg = imread(fullfile('srcImg', filename));
[tw, th] = size(origimg);

%% Read source image A (to be compared with recovered A')
orig_img = imread(fullfile('origImg', filename));

%% find matched K_w, K_h and P_d
for ij = 1:4
    if(ij==1)
        pd = 8; kh = 32; kw = 32;
    elseif(ij==2)
        pd = 4; kh = 18; kw = 18;
    elseif(ij==3)
        pd = 12; kh = 16; kw = 16;
    elseif(ij==4)
        pd = 16; kh = 43; kw = 43;
    end
    
    ph = kh + 2*pd; pw = kw + 2*pd;
    tpw = floor((tw-pw)/(pw-pd) + 1);
    tph = floor((th-ph)/(ph-pd) + 1);
    tpn = tpw*tph; %index table number
    
    %acquire candidate patches
    tpnindx = 1;
    for i = 1:tph
        for j = 1:tpw
            candipatch{tpnindx, 1} = origimg((i-1)*(ph-pd)+1:i*(ph-pd)+pd, (j-1)*(pw-pd)+1:j*(pw-pd)+pd);
            candipatch{tpnindx, 2} = 0; %tag showing whether the patch is padded
            tpnindx = tpnindx + 1;
        end
    end
    
    %sort value and find appropriate positions
    sumnum = issrc(candipatch, pd, tpn);
    
    [~, position] = find(sumnum==max(max(sumnum)));
    for i = 1:8
        sumnum(i, position) = -1;
    end
    v_max(ij) = max(max(sumnum))/((pd*(ph-pd))^2);
end

ij = find(v_max==max(v_max));

fid0 = fopen(fullfile('data', 'size.txt'), 'a');
fprintf(fid0, 'size: %d\r\n', ij);
fclose(fid0);

if(ij==1)
    pd = 8; kh = 32; kw = 32;
elseif(ij==2)
    pd = 4; kh = 18; kw = 18;
elseif(ij==3)
    pd = 12; kh = 16; kw = 16;
elseif(ij==4)
    pd = 16; kh = 43; kw = 43;
end

nh = 4; nw = 4;
sh = nh*kh; sw = nw*kw;
ph = kh + 2*pd; pw = kw + 2*pd;
tpw = floor((tw-pw)/(pw-pd) + 1);
tph = floor((th-ph)/(ph-pd) + 1);
tpn = tpw*tph;%index table number

%% Obtain candidate patches
tpnindx = 1;
for i = 1:tph
    for j = 1:tpw
        candipatch{tpnindx, 1} = origimg((i-1)*(ph-pd)+1:i*(ph-pd)+pd, (j-1)*(pw-pd)+1:j*(pw-pd)+pd);
        candipatch{tpnindx, 2} = 0; %tag showing whether the patch is padded
        tpnindx = tpnindx + 1;
    end
end

%% Sort values and find appropriate positions
sumnum = issrc(candipatch, pd, tpn);

[~, position] = find(sumnum==max(max(sumnum)));
for i = 1:8
    sumnum(i, position) = -1;
end

%% Find appropriate position
candipatch{1, 2} = -1;
for i = 1:8
    [~, valsort{i, 1}] = sort(sumnum(i, :), 'descend');
    if(i<=4 && i~=2)
        sumnum(:, valsort{i, 1}(1)) = -1;
        position = [position valsort{i, 1}(1)];
    end
    if(i~=2)
        candipatch{valsort{i, 1}(1), 2} = -1;
    end
end

%% Recover source image A'
spn = nh*nw;
srcimg = 0 - ones(nh*kh, nw*kw);

%pad 4 corners
srcimg(nh*kh-(ph-pd)+1:nh*kh, 1:kw+pd) ...
    = double(candipatch{valsort{1, 1}(1), 1}(1:ph-pd, pd+1:pw));%left bottom
srcimg(1:kh+pd, 1:kw+pd) ...
    = double(candipatch{1, 1}(pd+1:ph, pd+1:pw));%left upper
srcimg(1:kh+pd, nw*kw-(pw-pd)+1:nw*kw) ...
    = double(candipatch{valsort{3, 1}(1), 1}(pd+1:ph, 1:pw-pd));%right upper
srcimg(nh*kh-(ph-pd)+1:nh*kh, nw*kw-(pw-pd)+1:nw*kw) ...
    = double(candipatch{valsort{4, 1}(1), 1}(1:ph-pd, 1:pw-pd));%right down

%pad 4 sides
for i = 1:nh-2
    sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
    [srcimg, clrposi] = sidenum(srcimg, sp{nw*(i-1)+1, 1}, candipatch, valsort, nh-2, 5, pd, ph, pw, kh, kw, i+1);
    position = [position, clrposi]; candipatch{clrposi, 2} = -1;
    sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
    [srcimg, clrposi] = sidenum(srcimg, sp{nw*i, 1}, candipatch, valsort, nh-2, 7, pd, ph, pw, kh, kw, i+1);
    position = [position, clrposi]; candipatch{clrposi, 2} = -1;
end

for j = 1:nw-2
    sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
    [srcimg, clrposi] = sidenum(srcimg, sp{j, 1}, candipatch, valsort, nh-2, 6, pd, ph, pw, kh, kw, j+1);
    position = [position, clrposi]; candipatch{clrposi, 2} = -1;
    sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
    [srcimg, clrposi] = sidenum(srcimg, sp{(nh-1)*nw+j, 1}, candipatch, valsort, nh-2, 8, pd, ph, pw, kh, kw, j+1);
    position = [position, clrposi]; candipatch{clrposi, 2} = -1;
end

%pad middle patches
sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
padposi = 6;
indx = getcandidate(sp{padposi, 1}, candipatch, tpn);
position = [position, indx];
srcimg(1*kh+1:2*kh+pd, 1*kw+1:2*kw+pd) = double(candipatch{indx, 1}(pd+1:ph, pd+1:pw));
candipatch{indx, 2} = -1;

sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
padposi = 10;
indx = getcandidate(sp{padposi, 1}, candipatch, tpn);
position = [position, indx];
srcimg(2*kh+1:3*kh, 1*kw+1:2*kw+pd) = double(candipatch{indx, 1}(pd+1:ph-pd, pd+1:pw));
candipatch{indx, 2} = -1;

sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
padposi = 7;
indx = getcandidate(sp{padposi, 1}, candipatch, tpn);
position = [position, indx];
srcimg(1*kh+1:2*kh+pd, 2*kw+1:3*kw) = double(candipatch{indx, 1}(pd+1:ph, pd+1:pw-pd));
candipatch{indx, 2} = -1;

sp = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw);
padposi = 11;
indx = getcandidate(sp{padposi, 1}, candipatch, tpn);
position = [position, indx];
srcimg(2*kh+1:3*kh, 2*kw+1:3*kw) = double(candipatch{indx, 1}(pd+1:ph-pd, pd+1:pw-pd));
candipatch{indx, 2} = -1;

%% Verify the sameness of A and A'
[ir, ic] = size(srcimg);
imwrite(uint8(srcimg), fullfile('rcvImg', filename), 'bmp');

mse = sum(sum((srcimg - double(orig_img)).^2))/(ir*ic);
PSNR = 10*log10(255*255/mse);
fprintf('PSNR: %d\n', PSNR);

if(PSNR~=Inf)
    fid = fopen(fullfile('data', 'error.txt'), 'a');
    fprintf(fid, 'image#: %d', imgnum);
    fprintf(fid, '  PSNR is not Inf.\r\n');
    fclose(fid);
end

end
