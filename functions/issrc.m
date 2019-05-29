function sumnum = issrc(candipatch, pd, tpnindx)
%discriminate the truth of source kernel
%and tell the rough position

[ph, pw] = size(candipatch{1, 1});

%lower left corner:1
%top left corner:2
%top right corner:3
%lower right corner:4
%left:5
%up:6
%right:7
%down:8
% xx = [1 2 3 4 5 6 7 8];
% yy = 0.6395*xx + 0.4490;

sumnum = zeros(8, tpnindx);
for i = 1:8
    for j = 1:tpnindx
        sumnum(i, j) = similnum(candipatch{j, 1}, i, pd, ph, pw);
    end
end

end


function sumnum = similnum(patch, kind, pd, ph, pw)
%compute similar patches' numbers
xx = 1:pd;
yy = 0.6395*xx + 0.4490;

sumnum = 0;

if(kind==1)
    temp1 = double(patch(ph-2*pd+1:ph-pd, pd+1:pw));
    temp2 = double(flipud(patch(ph-pd+1:ph, pd+1:pw)));
    s1 = sum(sum(temp1-temp2==0));
    temp3 = double(rot90(patch(ph-2*pd+1:ph-pd, pd+1:2*pd), 2));
    temp4 = double(patch(ph-pd+1:ph, 1:pd));
    s2 = sum(sum(temp3-temp4==0));
    temp5 = double(patch(1:ph-pd, pd+1:2*pd));
    temp6 = double(fliplr(patch(1:ph-pd, 1:pd)));
    s3 =  sum(sum(temp5-temp6==0));
    sumnum = s1*s3 + s2;
elseif(kind==2)
    temp1 = double(patch(pd+1:ph, pd+1:2*pd));
    temp2 = double(fliplr(patch(pd+1:ph, 1:pd)));
    s1 = sum(sum(temp1-temp2==0));
    temp3 = double(rot90(patch(pd+1:2*pd, pd+1:2*pd), 2));
    temp4 = double(patch(1:pd, 1:pd));
    s2 = sum(sum(temp3-temp4==0));
    temp5 = double(patch(pd+1:2*pd, pd+1:pw));
    temp6 = double(flipud(patch(1:pd, pd+1:pw)));
    s3 = sum(sum(temp5-temp6==0));
    sumnum = s1*s3 + s2;
elseif(kind==3)
    temp1 = double(patch(pd+1:2*pd, 1:pw-pd));
    temp2 = double(flipud(patch(1:pd, 1:pw-pd)));
    s1 = sum(sum(temp1-temp2==0));
    temp3 = double(rot90(patch(pd+1:2*pd, pw-2*pd+1:pw-pd), 2));
    temp4 = double(patch(1:pd, pw-pd+1:pw));
    s2 = sum(sum(temp3-temp4==0));
    temp5 = double(patch(pd+1:ph, pw-2*pd+1:pw-pd));
    temp6 = double(fliplr(patch(pd+1:ph, pw-pd+1:pw)));
    s3 = sum(sum(temp5-temp6==0));
    sumnum = s1*s3 + s2;
elseif(kind==4)
    temp1 = double(patch(1:ph-pd, pw-2*pd+1:pw-pd));
    temp2 = double(fliplr(patch(1:ph-pd, pw-pd+1:pw)));
    s1 = sum(sum(temp1-temp2==0));
    temp3 = double(rot90(patch(ph-2*pd+1:ph-pd, pw-2*pd+1:pw-pd), 2));
    temp4 = double(patch(ph-pd+1:ph, pw-pd+1:pw));
    s2 = sum(sum(temp3-temp4==0));
    temp5 = double(patch(ph-2*pd+1:ph-pd, 1:pw-pd));
    temp6 = double(flipud(patch(ph-pd+1:ph, 1:pw-pd)));
    s3 = sum(sum(temp5-temp6==0));
    sumnum = s1*s3 + s2;
elseif(kind==5)
    temp1 = double(patch(1:ph, pd+1:pd*2));
    temp2 = double(fliplr(patch(1:ph, 1:pd)));
    for ts = 1:pd
        sumnum = sumnum + yy(pd-ts+1)*sum(sum(temp1(:, ts)-temp2(:, ts)==0));
    end
elseif(kind==6)
    temp1 = double(patch(pd+1:2*pd, 1:pw));
    temp2 = double(flipud(patch(1:pd, 1:pw)));
    for ts = 1:pd
        sumnum = sumnum + yy(pd-ts+1)*sum(sum(temp1(ts, :)-temp2(ts, :)==0));
    end
elseif(kind==7)
    temp1 = double(patch(1:ph, pw-2*pd+1:pw-pd));
    temp2 = double(fliplr(patch(1:ph, pw-pd+1:pw)));
    for ts = 1:pd
        sumnum = sumnum + yy(pd-ts+1)*sum(sum(temp1(:, ts)-temp2(:, ts)==0));
    end
elseif(kind==8)
    temp1 = double(patch(ph-2*pd+1:ph-pd, 1:pw));
    temp2 = double(flipud(patch(ph-pd+1:ph, 1:pw)));
    for ts = 1:pd
        sumnum = sumnum + yy(pd-ts+1)*sum(sum(temp1(ts, :)-temp2(ts, :)==0));
    end
end

end