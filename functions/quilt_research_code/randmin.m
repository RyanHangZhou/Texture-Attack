% Given a vector X, find all minima and return a random one
%
function [val, ind] = randmin(x);
  
  perm = randperm(length(x));
  [val ind] = min(x(perm));
  ind = perm(ind);
  
