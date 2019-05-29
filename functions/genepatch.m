function [sp, exp_img] = genepatch(srcimg, pd, sh, sw, spn, nw, kh, kw)

fliplr_img = fliplr(srcimg);%flip left & right
flipud_img = flipud(srcimg);%flip up & down
tlcorn_img = rot90(srcimg(1:pd, 1:pd),2);%top left corner
trcorn_img = rot90(srcimg(1:pd, sw-pd+1:sw),2);%top right corner
llcorn_img = rot90(srcimg(sh-pd+1:sh, 1:pd),2);%lower left corner
lrcorn_img = rot90(srcimg(sh-pd+1:sh, sw-pd+1:sw),2);%lower right corner
exp_img(pd+1: pd+sh, pd+1:pd+sw) = srcimg;%middle
exp_img(pd+1: pd+sh, 1:pd) = fliplr_img(1:sh, sw-pd+1:sw);%left
exp_img(pd+1: pd+sh, sw+pd+1:sw+2*pd) = fliplr_img(1:sh, 1:pd);%right
exp_img(1:pd, pd+1: pd+sw) = flipud_img(sh-pd+1:sh, 1:sw);%up
exp_img(sh+pd+1:sh+2*pd, pd+1: pd+sw) = flipud_img(1:pd, 1:sw);%down
exp_img(1:pd, 1:pd) = tlcorn_img;%top left corner
exp_img(1:pd, pd+sw+1:pd*2+sw) = trcorn_img;%top right corner
exp_img(pd+sh+1:pd*2+sh, 1:pd) = llcorn_img;%lower left corner
exp_img(pd+sh+1:pd*2+sh, sw+pd+1:sw+2*pd) = lrcorn_img;%lower right corner
% figure(2)
% imshow(exp_img)

%acquire kernel block(kb) & source patch(sp)
for i = 1:spn
    rtemp = floor(i/nw); ctemp = mod(i, nw);
    if(ctemp==0)
        ctemp = nw; rtemp = rtemp - 1;
    end
    sp{i, 1} = exp_img(rtemp*kh+1:(rtemp+1)*kh+2*pd, (ctemp-1)*kw+1:ctemp*kw+2*pd);
%     sp{i, 1} = exp_img(rtemp*(kh+pd)+1:(rtemp+1)*(kh+pd)+pd, (ctemp-1)*(kw+pd)+1, ctemp*(kh+pd)+pd);
end


end