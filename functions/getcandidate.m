function indx = getcandidate(srcimg, candipatch, tpn)

[h, w] = size(srcimg);

num = zeros(tpn);  
for i = 1:tpn
    for len = 1:8
        srcimg2 = srcimg;
        srcimg2(len+1: h-len, len+1:w-len) = 0 - ones(h-2*len, w-2*len);
        patch = double(candipatch{i, 1});
        tag = candipatch{i, 2};
        if(tag==0)
            num(i) = num(i) + sum(sum(srcimg2-patch==0))*(8 - len);
        else
            num(i) = -1;
        end
    end

end

[~, posi] = sort(num, 'descend');
indx = posi(1);

end