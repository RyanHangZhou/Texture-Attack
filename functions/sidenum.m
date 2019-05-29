function [srcimg, clrposi] = sidenum(srcimg, srcpatch, candipatch, valsort, iter, tag, pd, ph, pw, kh, kw, posi)
%compute side overlapping pixels number and return the
%recovered image

%tag
%5:left  6:up  7:right  8:down

for i = 1:iter
    if(tag==5 || tag==7)%left
        temp1 = srcpatch(ph-pd+1:ph, 1:pw);
        temp = double(candipatch{valsort{tag, 1}(i), 1});
        temp2 = temp(pd+1:2*pd, 1:pw);
        val(i) = sum(sum(temp1-temp2==0));
        temp3 = srcpatch(ph-2*pd+1:ph-pd, 1:pw);
        temp4 = temp(1:pd, 1:pw);
        val(i) = val(i) + sum(sum(temp3-temp4==0));
    elseif(tag==6 || tag==8)
        temp1 = srcpatch(1:ph, pw-pd+1:pw);
        temp = double(candipatch{valsort{tag, 1}(i), 1});
        temp2 = temp(1:ph, pd+1:2*pd);
        val(i) = sum(sum(temp1-temp2==0));
        temp3 = srcpatch(1:ph, pw-2*pd+1:pw-pd);
        temp4 = temp(1:ph, 1:pd);
        val(i) = val(i) + sum(sum(temp3-temp4==0));
    end
end

[~, maxval] = sort(val, 'descend');
if(tag==5)
    if(posi==iter+1)
        srcimg((posi-1)*kh+1:posi*kh, 1:kw+pd) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph-pd, pd+1:pw));
    else
        srcimg((posi-1)*kh+1:posi*kh+pd, 1:kw+pd) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph, pd+1:pw));
    end
elseif(tag==6)
    if(posi==iter+1)
        srcimg(1:kh+pd, (posi-1)*kw+1:posi*kw) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph, pd+1:pw-pd));
    else
        srcimg(1:kh+pd, (posi-1)*kw+1:posi*kw+pd) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph, pd+1:pw));
    end
elseif(tag==7)
    if(posi==iter+1)
        srcimg((posi-1)*kh+1:posi*kh, (iter+1)*kw-pd+1:(iter+2)*kw) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph-pd, 1:pw-pd));
    else
        srcimg((posi-1)*kh+1:posi*kh+pd, (iter+1)*kw-pd+1:(iter+2)*kw) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(pd+1:ph, 1:pw-pd));
    end
elseif(tag==8)
    if(posi==iter+1)
        srcimg((iter+1)*kh-pd+1:(iter+2)*kh, (posi-1)*kw+1:posi*kw) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(1:ph-pd, pd+1:pw-pd));
    else
        srcimg((iter+1)*kh-pd+1:(iter+2)*kh, (posi-1)*kw+1:posi*kw+pd) = ...
            double(candipatch{valsort{tag, 1}(maxval(1)), 1}(1:ph-pd, pd+1:pw));
    end
end

clrposi = valsort{tag, 1}(maxval(1));


end