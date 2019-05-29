% **************************************************************************
% (C) 2001 Mitsubishi Electric Research Laboratories, all rights reserved.
% This program in source or executable form may be used for research only.
% Commercial use of this program in source or executable form is strictly
% prohibited. If copied, this copyright notice must appear with the
% program.
% **************************************************************************

function out_im = simplexferfun(src_im,dest_im,w,niter,src_mask,dest_mask);

  % Make all images color
  if ndims(src_im)==2,
    src_im = repmat(src_im,[1 1 3]);
  end;
  if ndims(dest_im)==2,
    dest_im = repmat(dest_im,[1 1 3]);
  end;

  % create images for matching
  src_im_map = rgb2gray(src_im);
  dest_im_map = rgb2gray(dest_im);
%  src_im_map = pcolors(src_im);
%  dest_im_map = pcolors(dest_im);

  if exist('dest_mask'),
    out_im = xferfun(src_im,src_im_map,dest_im,dest_im_map,w,niter,src_mask,dest_mask);
  else 
    out_im = xferfun(src_im,src_im_map,dest_im,dest_im_map,w,niter);
  end;
    