function ker = patchtokernel(pat, pw, ph, pd)
%cut the original image into kernel img

for i = pd + 1:ph - pd
    for j = pd + 1: pw - pd
        ker(i - pd, j - pd) = pat(i, j);
    end
end

end