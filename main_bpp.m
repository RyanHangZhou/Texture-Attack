% ========================================================================
% USAGE: main_bpp(filename, imgnum, position, kw, kh ,pd)
% Extract Message
%
% Inputs
%       filename     -filename of the image
%       imgnum       -image No
%       position     -position of source patches in synthetic image S
%       kw           -width of kernel
%       kh           -height of kernel
%       pd           -depth of patch
%
% Outputs
%
% Hang Zhou, November 23, 2015
% ========================================================================

function main_bpp(filename, imgnum, position, kw, kh ,pd)

%% Read synthetic image S
origimg = imread(fullfile('srcImg', filename));
[tw, th] = size(origimg);

%% Read Recovered source image A'
orig_img = imread(fullfile('rcvImg', filename));
[sw, sh] = size(orig_img);
pw = kw + 2*pd; ph = kh + 2*pd;

tpw = floor((tw-pw)/(pw-pd) + 1);
tph = floor((th-ph)/(ph-pd) + 1);
tpn = tpw*tph; %index table number
l1 = ceil((tpw-2)/2)*ceil((tph-2)/2);
l2 = floor((tpw-2)/2)*floor((tph-2)/2);
spn = sw*sh/(kw*kh); nw = sw/kw;

%% Obtain candidate patches (cp)
cpn = (sw-pw+1)*(sh-ph+1);
swn = sw-pw+1;

for i = 1:cpn
    rtemp = floor(i/swn); ctemp = mod(i, swn);
    if(ctemp==0)
        ctemp = swn; rtemp = rtemp - 1;
    end
    cp{i, 1} = orig_img(rtemp+1:rtemp+ph, ctemp:ctemp+pw-1);
    cp{i, 2} = 0;
end

realposi(1) = position(1);
realposi(2) = position(9);
realposi(3) = position(11);
realposi(4) = position(3);
realposi(5) = position(5);
realposi(6) = position(13);
realposi(7) = position(15);
realposi(8) = position(6);
realposi(9) = position(7);
realposi(10) = position(14);
realposi(11) = position(16);
realposi(12) = position(8);
realposi(13) = position(2);
realposi(14) = position(10);
realposi(15) = position(12);
realposi(16) = position(4);

for i = 1:tpn
    indtbl(1, i) = -1;
end

for i = 1:spn
    indtbl(1, realposi(i)) = i;
end

%% Acquire kernel blocks (kb) & source patches (sp)
[~, exp_img] = genepatch(orig_img, pd, sh, sw, spn, nw, kh, kw);
for i = 1:spn
    rtemp = floor(i/nw); ctemp = mod(i, nw);
    if(ctemp==0)
        ctemp = nw; rtemp = rtemp - 1;
    end
    sp{i, 1} = exp_img(rtemp*kh+1:(rtemp+1)*kh+2*pd, (ctemp-1)*kw+1:ctemp*kw+2*pd);
end

%% Pad source patches
synth_img = zeros(th, tw);
for i = 1:th
    for j = 1:tw
        synth_img(i, j) = -1;
    end
end
for i = 1:spn
    rtemp = floor(realposi(i)/tpw); ctemp = mod(realposi(i), tpw);
    if(ctemp==0)
        ctemp = tpw; rtemp = rtemp - 1;
    end
    synth_img(rtemp*(ph-pd)+1:(rtemp+1)*(ph-pd)+pd, (ctemp-1)*(pw-pd)+1:ctemp*(pw-pd)+pd) = sp{i, 1};
end

%% Extract message
embindx = 1;
for i = 1:tpn
    rtemp = floor(i/tpw); ctemp = mod(i, tpw);
    if(ctemp==0)
        ctemp = tpw; rtemp = rtemp - 1;
    end
    temp = synth_img(rtemp*(ph-pd)+1:(rtemp+1)*(ph-pd)+pd, (ctemp-1)*(pw-pd)+1:ctemp*(pw-pd)+pd);
    temp2 = origimg(rtemp*(ph-pd)+1:(rtemp+1)*(ph-pd)+pd, (ctemp-1)*(pw-pd)+1:ctemp*(pw-pd)+pd);
    if(indtbl(1, i)==-1)
        for j = 1:cpn
            if(cp{j, 2}==0)
                tempsum(j) = blkpsnr(temp, cp{j, 1}, ph, pw);
                siminum(j) = sum(sum(patchtokernel(double(temp2), pw, ph, pd) ...
                    - patchtokernel(double(cp{j, 1}), pw, ph, pd)==0));
            else
                tempsum(j) = inf;
                siminum(j) = inf;
            end
        end
        [~, tempsort] = sort(tempsum);
        [~, simisort] = sort(siminum, 'descend');
        msgprt(embindx) = find(tempsort==simisort(1));
        %image quilting
        srcimg = synth_img(rtemp*(ph-pd)+1:(rtemp+1)*(ph-pd)+pd, (ctemp-1)*(pw-pd)+1:ctemp*(pw-pd)+pd);
        tempsynthimg = double(cp{tempsort(msgprt(embindx)), 1});
        outimg = imgquilt(srcimg, tempsynthimg, pd);
        synth_img(rtemp*(ph-pd)+1:(rtemp+1)*(ph-pd)+pd, (ctemp-1)*(pw-pd)+1:ctemp*(pw-pd)+pd) = ...
            outimg;
        embindx = embindx + 1;
    end
end

msgprt = msgprt-1;
% save outsteam.mat msgprt

[~, mw] = size(msgprt);
maxmsg = max(msgprt);

%% Discriminate whether the message is embedded
if(maxmsg==0)
    fid2 = fopen(fullfile('data', 'msgexist.txt'), 'a');
    fprintf(fid2, 'image#: %d ', imgnum);
    fprintf(fid2, 'Message does not exist.\r\n');
else
    fid2 = fopen(fullfile('data', 'msgexist.txt'), 'a');
    fprintf(fid2, 'image#: %d ', imgnum);
    fprintf(fid2, 'Message exists.\r\n');
    
    itermsg = maxmsg;
    indx = 0;
    
    while(itermsg>0)
        itermsg = floor(itermsg/2);
        indx = indx + 1;
    end
    
    recvmsg = [];
    for i = 1:mw
        for j = 1:indx
            tempindx(j) = mod(msgprt(i), 2);
            msgprt(i) = floor(msgprt(i)/2);
        end
        recvmsg = [recvmsg tempindx];
    end
    
    %Compare original embedded message
    pathstream = fullfile('srcImg\', [num2str(imgnum), '.mat']);
    sdir = dir(pathstream);
    if(isempty(sdir)==1)
        fid = fopen(fullfile('data', 'error.txt'), 'a');
        fprintf(fid, 'image#: %d', imgnum);
        fprintf(fid, 'Cover image is wrongly estimated to stego image.\r\n');
        fclose(fid);
    else
        origmsg = load(pathstream);
        origmsg = origmsg.psestream;
        
        if(length(origmsg)==length(recvmsg))
            errDist = origmsg - recvmsg';
            errLen = length(find(errDist(:)~=0));
            fprintf('error bits: %d\n', errLen);
            errpercentg = errLen/length(errDist);
            fprintf('error percentage: %d\n', errpercentg);
        
            if(errLen~=0)
                fid = fopen(fullfile('data', 'error.txt'), 'a');
                fprintf(fid, 'image#: %d', imgnum);
                fprintf(fid, 'Message is not correctly recovered.\r\n');
                fclose(fid);
            else
                fid = fopen(fullfile('data', 'attack.txt'), 'a');
                fprintf(fid, 'image#: %d', imgnum);
                fprintf(fid, ', bpp: %d\r\n', indx);
                fclose(fid);
            end
        else
            fid = fopen(fullfile('data', 'error.txt'), 'a');
            fprintf(fid, 'image#: %d', imgnum);
            fprintf(fid, 'Message length is not correctly estimated.\r\n');
            fclose(fid);
        end
    end
end

end
