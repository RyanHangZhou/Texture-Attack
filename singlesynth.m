% ========================================================================
% USAGE: singlesynth(imgnum)
% Image synthesis
%
% Inputs
%       imgnum       -image No
%
% Outputs
%
% Hang Zhou, November 24, 2015
% ========================================================================

function singlesynth(imgnum)

filename = [num2str(imgnum), '.bmp'];

%% Print image path and image name
full_file = fullfile('srcImg\', filename);
fprintf('Read synthetic image: %s\n', full_file);

%% Recover source image
[position, kw, kh, pd] = main_recover(filename, imgnum);
fprintf('Source image is recovered. \n');

%% Extract message
main_bpp(filename, imgnum, position, kw, kh, pd);
fprintf('Message is extracted. \n');

end