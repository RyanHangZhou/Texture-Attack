
function mask = dp(raw_data);

[depth,len] = size(raw_data);
data = raw_data(:,1:len-1) + raw_data(:,2:len);
len = len-1;
mins = zeros(size(data));
paths = zeros(size(data));

mins(1,:) = data(1,:);

for ii=2:depth,
  minline = mins(ii-1,:);
  % fast way to do min over nearest neighbors
  min3 = [minline; ...
	  inf minline(1:len-1); ...
	  minline(2:len) inf];
  [newminline minind] = min(min3);
  minind = minind - 1;
  minind(minind == 2) = -1;
  paths(ii-1,:) = minind;
  mins(ii,:) = newminline + data(ii,:);
end;

mask = zeros(size(raw_data));
[val ind] = randmin(mins(depth,:));
mask(depth,1:ind) = 1;
for ii=depth-1:-1:1,
  ind = ind - paths(ii,ind);
  mask(ii,1:ind) = 1;
end;

