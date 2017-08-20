function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
    
[h,w] = size(I); %size of the input
h2 = ceil(h/8); %the size of the output
w2 = ceil(w/8);
nori = 9;       %number of orientation bins

[mag,ori] = mygradient(I);
thresh = 0.1*max(mag(:))  %threshold for edges


% separate out pixels into orientation channels
ohist = zeros(h2,w2,nori);
%-pi/2: pi/9 : pi/2
for i = 1:nori
  % create a binary image containing 1's for the pixels that are edges at this orientation
  bin_i_left_ori = -3.14159265359 + 2*(i-1)*3.14159265359/nori
  bin_i_right_ori = -3.14159265359 + 2*i*3.14159265359/nori
  

  B = (mag > thresh & ori >= bin_i_left_ori & ori <= bin_i_right_ori);
  
  % sum up the values over 8x8 pixel blocks.
  chblock = im2col(B,[8 8],'distinct');  %useful function for grabbing blocks
  
  %sum over each block and store result in ohist
  block_sum = sum(chblock);
  ohist(:,:,i) = reshape(block_sum, h2, w2);
end

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
%normalize a vector: v/magnitude(v)

magnitude_all_bins = sum(ohist,3);
for i = 1:nori
    ohist(:,:,i) = ohist(:,:,i)./magnitude_all_bins;
end
ohist(isnan(ohist)) = 0; %leave values 0 
