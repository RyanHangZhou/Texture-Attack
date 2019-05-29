function outimg = compound(leftimg, intoimg, indx, reverse)

if(reverse==1)
    rev = leftimg;
    leftimg = intoimg;
    intoimg = rev;
end

[h, w] = size(leftimg);
outimg = zeros(h, w);

temp1 = (leftimg - intoimg).^2;

indximg = mincut(temp1, indx);

for i = 1:h
    for j = 1:w
        if(indximg(i, j)==-1)
            outimg(i, j) = leftimg(i, j);
        else
            outimg(i, j) = intoimg(i, j);
        end
    end
end


end