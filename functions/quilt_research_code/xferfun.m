% **************************************************************************
% (C) 2001 Mitsubishi Electric Research Laboratories, all rights reserved.
% This program in source or executable form may be used for research only.
% Commercial use of this program in source or executable form is strictly
% prohibited. If copied, this copyright notice must appear with the
% program.
% **************************************************************************
%
% function out_im = xferfun(src_im,src_im_map, ...
%	  		    dest_im,dest_im_map, ...
%		  	    w,niter,src_mask,dest_mask);
%
%   src_im - input style image 
%   dest_im - destination style image 
%   src_im_map, dest_im_map - correspondence images
%   w - size of patches (w-by-w)
%   niter - how many times to iterate (with decreasing w)
%   src_mask, dest_mask - 1 where input images are not valid

function out_im = xferfun(src_im,src_im_map, ...
			  dest_im,dest_im_map, ...
			  w,niter,src_mask,dest_mask);

global DICT_IM_SQUARED DICT_IM 

border = round(w/3);
filt_w = 4;
smooth_filt = binomialFilter(filt_w)*binomialFilter(filt_w)';

% if no masks, take everything
if ~exist('src_mask'),
  src_mask = logical(zeros(size(src_im_map)));
end;
if ~exist('dest_mask'),
  dest_mask = logical(zeros(size(dest_im_map)));
end;

dest_im_map(dest_mask) = -1;
src_im_map(src_mask) = -1;

% figure(1);
% colormap(gray);
% subplot(1,2,1);
% imshow(src_im);
% title('Src Image');
% subplot(1,2,2);
% imshow(src_im_map.*~src_mask);
% title('Src Map');
% truesize;

cur_dest_im_map = dest_im_map;
cur_dest_im = dest_im;


  DICT_IM = src_im_map;
  DICT_IM_SQUARED = DICT_IM.^2;

  if ~isnan(cur_dest_im(1)),
    work_im_rgb = cur_dest_im;
  else
    work_im_rgb = zeros(size(cur_dest_im));
  end;
  work_im_rgb2 = zeros(size(cur_dest_im));
  rd = size(work_im_rgb);

  cur_error = cur_dest_im_map;


for iter=1:niter,
% %   figure(2);
% %   colormap(gray);
% %   subplot(2,2,1);
% %   imshow(dest_im);
% %   title('Original Dest Image');
% %   subplot(2,2,2);
% %   imshow(dest_im_map.*~dest_mask);
% %   title('Dest Map');
% %   subplot(2,2,3);
% %   imshow(cur_dest_im);
% %   title('Current dest');
% %   subplot(2,2,4);
% %   imshow(work_im_rgb);
% %   title('Result');
% %   truesize;
% %   drawnow;

%   fprintf('W = %d\n', w);

  for ii=[1:w:rd(1)-w-border, rd(1)-w-border+1],
    for jj=[1:w:rd(2)-w-border, rd(2)-w-border+1],
%  for ii=[1:w:rd(1)-w-border],
%    for jj=[1:w:rd(2)-w-border],
     if (~all(all(dest_mask(ii:ii+w+border-1,jj:jj+w+border-1)))),
      template = cur_dest_im_map(ii:ii+w+border-1,jj:jj+w+border-1);
      [errs, ctrs] = dict_match3(template);

      c = ctrs(ceil(rand*size(ctrs,1)),:);
      iii = c(1); jjj = c(2);
      sq_rgb = src_im(iii:iii+w+border-1,jjj:jjj+w+border-1,:);
      sq = src_im_map(iii:iii+w+border-1,jjj:jjj+w+border-1);
      err_sq = (sq - template).^2;
      blend_mask = logical(zeros(size(err_sq)));
      if (ii > 1 & jj > 1),
	blend_mask = dpmain(err_sq,border);
      elseif (ii == 1 & jj == 1),
      elseif (ii == 1),
	blend_mask(:,1:border) = dp(err_sq(:,1:border));
      else 
	blend_mask(1:border,:) = blend_mask(1:border,:) ...
	    | dp(err_sq(1:border,:)')';
      end;

      cur_error(ii:ii+w+border-1,jj:jj+w+border-1) = err_sq.*~blend_mask;

      
      blend_mask = rconv2(double(blend_mask),smooth_filt); % Do blending      
      blend_mask_rgb = repmat(blend_mask,[1 1 3]);
      template(isnan(template)) = 0;
      work_im_rgb(ii:ii+w+border-1,jj:jj+w+border-1,:) ...
	  = work_im_rgb(ii:ii+w+border-1,jj:jj+w+border-1,:).*blend_mask_rgb...
	  + sq_rgb.*(1-blend_mask_rgb);
      work_im_rgb2(ii:ii+w+border-1,jj:jj+w+border-1,:) ...
	  = work_im_rgb2(ii:ii+w+border-1,jj:jj+w+border-1,:)...
	  .*(blend_mask_rgb>=0.95)...
	  + sq_rgb.*((1-blend_mask_rgb)>=0.95);
      cur_dest_im_map(ii:ii+w+border-1,jj:jj+w+border-1) ...
	  = template.*blend_mask + sq.*(1-blend_mask);
 
    
%      figure(1);
%      subplot(1,3,1);
%      imshow(template);
%      subplot(1,3,2);
%      imshow(sq.*~blend_mask);
%      subplot(1,3,3);
%      imshow(err_sq);
%      pause;
     end;

    end;
% %     figure(2);
% %     subplot(2,2,2);
% %     imshow(work_im_rgb2);
% %     subplot(2,2,4);
% %     imshow(work_im_rgb);
% %     drawnow;
%    subplot(2,2,3);
%    imshow(cur_dest_im);
%    figure(3);
%    imshow(cur_dest_im);
%    figure(4);
%    imshow(cur_error);
%     drawnow;
%pause;
  end;

  cur_dest_im = work_im_rgb;
  cur_dest_im_map(dest_mask) = -1;
  
  out_im = cur_dest_im;
  
  w = round(w * 0.7);
%  w = round(w * 0.8);

%   iterstr = num2str(iter);
%   imwrite(work_im_rgb,['temp1-' iterstr '.tif']);
%   imwrite(work_im_rgb2,['temp2-' iterstr '.tif']);
end  
  
dest_mask_rgb = repmat(dest_mask,[1 1 3]);
out_im(dest_mask_rgb) = dest_im(dest_mask_rgb);
% % figure(3);
% % imshow(out_im);


% imwrite(work_im_rgb2,'jigsaw.tif');


