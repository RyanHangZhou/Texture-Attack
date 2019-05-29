function mask = dp2(paths, ind);
[depth,len] = size(paths);
len = len + 1;
mask = zeros(depth,len);
mask(ind,1:ind) = 1;
start = ind+1;
for ii=start:depth,
  ind = ind - paths(ii,ind);
  mask(ii,1:ind) = 1;
end;

