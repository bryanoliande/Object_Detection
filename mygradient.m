function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%


%choice of filter from piazza
%https://piazza.com/class/ixxracir6wn35b?cid=169
xfilter = [-1 1]
yfilter = [-1 ; 1]


dx = imfilter(I, xfilter, 'replicate');
dy = imfilter(I, yfilter, 'replicate');

mag = sqrt(dx.*dx + dy.*dy);
ori = atan2(dy, dx);