function outimg = imgquilt(srcimg, synthimg, pd)
%conduct image quilting

[ph, pw] = size(srcimg);

kh = ph - 2*pd;
kw = pw - 2*pd;

%find overlapping region
mark = zeros(1, 8);
for i = 1:8
    if(srcimg(pd + kh + 1, 1)>=0)
        mark(1) = 1;
    end
    if(srcimg(pd + kh - 1, 1)>=0)
        mark(2) = 1;
    end
    if(srcimg(1, 1)>=0)
        mark(3) = 1;
    end
    if(srcimg(1, pd + 1)>=0)
        mark(4) = 1;
    end
    if(srcimg(1, pd + kw + 1)>=0)
        mark(5) = 1;
    end
    if(srcimg(pd + kh - 1, pd + kw + 1)>=0)
        mark(6) = 1;
    end
    if(srcimg(pd + kh + 1, pd + kw + 1)>=0)
        mark(7) = 1;
    end
    if(srcimg(pd + kh + 1, pd + 1)>=0)
        mark(8) = 1;
    end
end

%divide overlapping region
if(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==0 && mark(8)==0)
    sign = 1;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==0)
    sign = 2;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==1 && mark(8)==1)
    sign = 3;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==1 && mark(8)==0)
    sign = 4;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==1)
    sign = 5;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==0 && ...
        mark(5)==0 && mark(6)==0 && mark(7)==0 && mark(8)==0)
    sign = 6;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==0 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==0)
    sign = 7;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==0 && ...
        mark(5)==0 && mark(6)==0 && mark(7)==1 && mark(8)==1)
    sign = 8;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==0 && ...
        mark(5)==0 && mark(6)==0 && mark(7)==1 && mark(8)==0)
    sign = 9;
elseif(mark(1)==1 && mark(2)==1 && mark(3)==1 && mark(4)==0 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==1)
    sign = 10;
elseif(mark(1)==0 && mark(2)==0 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==0 && mark(8)==0)
    sign = 11;
elseif(mark(1)==0 && mark(2)==0 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==0)
    sign = 12;
elseif(mark(1)==1 && mark(2)==0 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==1 && mark(8)==1)
    sign = 13;
elseif(mark(1)==0 && mark(2)==0 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==0 && mark(7)==1 && mark(8)==0)
    sign = 14;
elseif(mark(1)==1 && mark(2)==0 && mark(3)==1 && mark(4)==1 && ...
        mark(5)==1 && mark(6)==1 && mark(7)==1 && mark(8)==1)
    sign = 15;
else
    fprintf('error!!!!!   ')
    mark
    fprintf('\n');
end

%mark regions with vertical:0 and horizontal:1
%prtg{:, 4}: means whether src part & synth part need to be exchanged
if(sign==1)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:pd, pd+1:pw); ptrg{2, 2} = synthimg(1:pd, pd+1:pw); ptrg{2, 3} = 1; ptrg{2, 4} = 0;
    num = 2;
elseif(sign==2)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:pd, pd+1:pw-pd); ptrg{2, 2} = synthimg(1:pd, pd+1:pw-pd); ptrg{2, 3} = 1; ptrg{2, 4} = 0;
    ptrg{3, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{3, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{3, 3} = 0; ptrg{3, 4} = 1;
    num = 3;
elseif(sign==3)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:pd, pd+1:pw); ptrg{2, 2} = synthimg(1:pd, pd+1:pw); ptrg{2, 3} = 1; ptrg{2, 4} = 0;
    ptrg{3, 1} = srcimg(pd+kh+1:ph, pd+1:pw); ptrg{3, 2} = synthimg(pd+kh+1:ph, pd+1:pw); ptrg{3, 3} = 1; ptrg{3, 4} = 1;
    num = 3;
elseif(sign==4)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:pd, pd+1:pw); ptrg{2, 2} = synthimg(1:pd, pd+1:pw); ptrg{2, 3} = 1; ptrg{2, 4} = 0;
    ptrg{3, 1} = srcimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{3, 2} = synthimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{3, 3} = 0; ptrg{3, 4} = 1;
    num = 3;
elseif(sign==5)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:pd, pd+1:pw-pd); ptrg{2, 2} = synthimg(1:pd, pd+1:pw-pd); ptrg{2, 3} = 1; ptrg{2, 4} = 0;
    ptrg{3, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{3, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{3, 3} = 0; ptrg{3, 4} = 1;
    ptrg{4, 1} = srcimg(pd+kh+1:ph, pd+1:pw-pd); ptrg{4, 2} = synthimg(pd+kh+1:ph, pd+1:pw-pd); ptrg{4, 3} = 1; ptrg{4, 4} = 1;
    num = 4;
elseif(sign==6)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    num = 1;
elseif(sign==7)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==8)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(pd+kh+1:ph, pd+1:pw); ptrg{2, 2} = synthimg(pd+kh+1:ph, pd+1:pw); ptrg{2, 3} = 1; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==9)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==10)
    ptrg{1, 1} = srcimg(1:ph, 1:pd); ptrg{1, 2} = synthimg(1:ph, 1:pd); ptrg{1, 3} = 0; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    ptrg{3, 1} = srcimg(pd+kh+1:ph, pd+1:pw-pd); ptrg{3, 2} = synthimg(pd+kh+1:ph, pd+1:pw-pd); ptrg{3, 3} = 1; ptrg{3, 4} = 1;
    num = 3;
elseif(sign==11)
    ptrg{1, 1} = srcimg(1:pd, 1:pw); ptrg{1, 2} = synthimg(1:pd, 1:pw); ptrg{1, 3} = 1; ptrg{1, 4} = 0;
    num = 1;
elseif(sign==12)
    ptrg{1, 1} = srcimg(1:pd, pd+1:pw); ptrg{1, 2} = synthimg(1:pd, pd+1:pw); ptrg{1, 3} = 1; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==13)
    ptrg{1, 1} = srcimg(1:pd, 1:pw); ptrg{1, 2} = synthimg(1:pd, 1:pw); ptrg{1, 3} = 1; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(pd+kh+1:ph, 1:pw); ptrg{2, 2} = synthimg(pd+kh+1:ph, 1:pw); ptrg{2, 3} = 1; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==14)
    ptrg{1, 1} = srcimg(1:pd, 1:pw); ptrg{1, 2} = synthimg(1:pd, 1:pw); ptrg{1, 3} = 1; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(pd+kh+1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    num = 2;
elseif(sign==15)
    ptrg{1, 1} = srcimg(1:pd, 1:pw); ptrg{1, 2} = synthimg(1:pd, 1:pw); ptrg{1, 3} = 1; ptrg{1, 4} = 0;
    ptrg{2, 1} = srcimg(1:ph, pd+kw+1:pw); ptrg{2, 2} = synthimg(1:ph, pd+kw+1:pw); ptrg{2, 3} = 0; ptrg{2, 4} = 1;
    ptrg{3, 1} = srcimg(pd+kh+1:ph, 1:pw); ptrg{3, 2} = synthimg(pd+kh+1:ph, 1:pw); ptrg{3, 3} = 1; ptrg{3, 4} = 1;
    num = 3;
else
    fprintf('error!!!!!   ')
    mark
    sign
    fprintf('\n');
end

% sign

for i = 1:num
    outpart{i, 1} = compound(ptrg{i, 1}, ptrg{i, 2}, ptrg{i, 3}, ptrg{i, 4});
%     figure(1)
%     imshow(uint8(ptrg{i, 1}));
%     figure(2)
%     imshow(uint8(ptrg{i, 2}));
%     figure(3)
%     imshow(uint8(outpart{i, 1}));
end

outimg = synthimg;

%paste blocks into synthetic image
if(sign==1)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:pd, pd+1:pw) = outpart{2, 1};
elseif(sign==2)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:pd, pd+1:pw-pd) = outpart{2, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{3, 1};
elseif(sign==3)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:pd, pd+1:pw) = outpart{2, 1};
    outimg(pd+kh+1:ph, pd+1:pw) = outpart{3, 1};
elseif(sign==4)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:pd, pd+1:pw) = outpart{2, 1};
    outimg(pd+kh+1:ph, pd+kw+1:pw) = outpart{3, 1};
elseif(sign==5)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:pd, pd+1:pw-pd) = outpart{2, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{3, 1};
    outimg(pd+kh+1:ph, pd+1:pw-pd) = outpart{4, 1};
elseif(sign==6)
    outimg(1:ph, 1:pd) = outpart{1, 1};
elseif(sign==7)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{2, 1};
elseif(sign==8)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(pd+kh+1:ph, pd+1:pw) = outpart{2, 1};
elseif(sign==9)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(pd+kh+1:ph, pd+kw+1:pw) = outpart{2, 1};
elseif(sign==10)
    outimg(1:ph, 1:pd) = outpart{1, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{2, 1};
    outimg(pd+kh+1:ph, pd+1:pw-pd) = outpart{3, 1};
elseif(sign==11)
    outimg(1:pd, 1:pw) = outpart{1, 1};
elseif(sign==12)
    outimg(1:pd, pd+1:pw) = outpart{1, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{2, 1};
elseif(sign==13)
    outimg(1:pd, 1:pw) = outpart{1, 1};
    outimg(pd+kh+1:ph, 1:pw) = outpart{2, 1};
elseif(sign==14)
    outimg(1:pd, 1:pw) = outpart{1, 1};
    outimg(pd+kh+1:ph, pd+kw+1:pw) = outpart{2, 1};
elseif(sign==15)
    outimg(1:pd, 1:pw) = outpart{1, 1};
    outimg(1:ph, pd+kw+1:pw) = outpart{2, 1};
    outimg(pd+kh+1:ph, 1:pw) = outpart{3, 1};
else
    fprintf('error!!!!!   ')
    mark
    sign
    fprintf('\n');
end

end