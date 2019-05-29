% **************************************************************************
% (C) 2001 Mitsubishi Electric Research Laboratories, all rights reserved.
% This program in source or executable form may be used for research only.
% Commercial use of this program in source or executable form is strictly
% prohibited. If copied, this copyright notice must appear with the
% program.
% **************************************************************************

function out_im = synthfun(src_im,w,niter);

  % create an empty dest
  [x,y,z] = size(src_im);
  zoomx = round(x*2/w);
  zoomy = round(y*2/w);

  border = round(w/3); % assume for size determination
  dest_im = repmat(NaN, [w*zoomx+border w*zoomy+border 3]);

  % Make all images color
  if ndims(src_im)==2,
    src_im = repmat(src_im,[1 1 3]);
  end;
%  if ndims(dest_im)==2,
%    dest_im = repmat(dest_im,[1 1 3]);
%  end;

  % create images for matching
  src_im_map = rgb2gray(src_im);
  dest_im_map = dest_im(:,:,1);
%  dest_im_map = rgb2gray(dest_im);
%  src_im_map = pcolors(src_im);
%  dest_im_map = pcolors(dest_im);

  out_im = xferfun(src_im,src_im_map,dest_im,dest_im_map,w,niter);
  
