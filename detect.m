function [x,y,score] = detect(I,template,ndet)
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%
x = zeros(1, ndet); y = zeros(1, ndet); score = zeros(1, ndet);

% compute the feature map for the image
f = hog(I);
nori = size(f,3);

% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + imfilter(f(:,:,i),template(:,:,i),'replicate');
end

% now return locations of the top ndet detections

% sort response from high to low
[R_val,R_ind] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
[yindices, xindices] = ind2sub(size(f), R_ind);


while ((detcount < ndet) && (i < length(R_ind)))
  xblock = xindices(i);
  yblock = yindices(i);
  assert(R_val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates 
  %Your code should return the locations of the detections in terms of the original 
  %image pixel coordinates so if your detector had a high response at block (i,j) 
  %then you should return (8*i,8*j) as the pixel coordinates.
  xpixel = 8 * xblock;
  ypixel = 8 * yblock;


  % check if this detection overlaps any detections which we've already added to the list
  if (detcount == 0)
      overlapcount = 0;
  else
      distance = sqrt((x - xpixel).^2 + (y - ypixel).^2);
      overlapcount = sum(distance < size(f,3));
  end
  
  % if not, then add this detection location and score to the list we return
  if (overlapcount == 0)
    detcount = detcount + 1;
    x(detcount) = xpixel;
    y(detcount) = ypixel;
    score(detcount) = R(yblock,xblock);
  end
  i = i + 1;
end