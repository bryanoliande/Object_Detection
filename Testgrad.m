I = im2double(imread('cameraman.tif'));
figure, imshow(I)

[mag ori] = mygradient(I);

figure, colormap hsv, imshow(mag)
figure, colormap hsv, imshow(ori)