function mask = dpmain(err_sq,border);

[nr nc] = size(err_sq);
[mins1, paths1] = dp1(err_sq(:,1:border));
[mins2, paths2] = dp1(err_sq(1:border,:)');
mask = zeros([nr border]);

minline = diag(mins1(1:border-1,1:border-1)) ...
	  + diag(mins2(1:border-1,1:border-1)');
[val ind] = randmin(minline);
mask = zeros([nr nc]);
mask(:,1:border) = dp2(paths1, ind);
mask(1:border,:) = mask(1:border,:) | dp2(paths2, ind)';
mask(1:ind,1:ind) = 1; 
