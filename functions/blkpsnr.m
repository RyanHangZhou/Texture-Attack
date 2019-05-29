function sum = blkpsnr(patch, candidate, ph, pw)
%compute edge psnr between two blocks

patch = double(patch);
candidate = double(candidate);
sum = 0;
% times = 0;
for i = 1:ph
    for j = 1:pw
        if(patch(i, j)~=-1)
            sum = sum + (patch(i, j) - candidate(i, j))^2;
        end
    end
end

end