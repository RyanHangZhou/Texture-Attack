% function [err, ctrs] = dict_match_weighted(dict_im, template, w);
%
% Compute all matches to TEMPLATE in DICT_IM in squared error sense
% and return the sorted errors in ERRS with their centers in CTRS
%
function [min_err, ctrs] = dict_match(template);

% defined in grow.m
global DICT_IM_SQUARED DICT_IM WEIGHT_MAP BORDER_MASK

err_threshold = 0.1;

% Find NaNs and clear them
nan_mask = isnan(template);
template(nan_mask) = 0;

% Make mask and weigh it
mask = ones(size(template));
mask(nan_mask) = 0;

%%imagesc(mask);


% Expanded (y(i) - x)^2
dist_mat = sqrt(conv2(DICT_IM_SQUARED, flipud(fliplr(mask)),'valid') - ...
		2*conv2(DICT_IM, flipud(fliplr(template.*mask)),'valid') + ...
		sum(sum((template.*template).*mask)));


n = max(sum(mask(:)),eps);
rel_dist_mat = dist_mat ./ n;

[min_err r] = min(rel_dist_mat(:));
%[i j] = ind2sub(size(rel_dist_mat),r);

[i,j] = find(rel_dist_mat <= min_err+min_err*err_threshold);
ctrs = [i, j];

%min_err = rel_dist_mat(20,20)/100;
%ctrs = [20 20];

%q = real(sort(rel_dist_mat(:)));
%plot(q(1:20));
%length(ctrs(:,1))
%min_err
%pause;
