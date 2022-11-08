function [im_s2, mask2] = alignSource(im_s, mask, sx, sy, im_t)
% Asks user for bottom-center position, top position and outputs an aligned, resized source image.

figure(1), hold off, imagesc(im_s), axis image
figure(2), hold off, imagesc(im_t), axis image

disp('choose target bottom-center location')
[tx, ty] = ginput(1);

[y, x] = find(mask);
y1 = min(y)-1; y2 = max(y)+1; x1 = min(x)-1; x2 = max(x)+1;
im_s2 = zeros(size(im_t));

disp('choose target top location for scaling')
[~, ty2] = ginput(1);
scale = (ty-ty2)/(y2-y1);

im_s = imresize(im_s, scale);
y1 = round(scale*y1);
y2 = round(scale*y2);
x1 = round(scale*x1);
x2 = round(scale*x2);
max_y = round(scale*max(y));
mean_x = round(scale*mean(x));

yind = (y1:y2);
yind2 = yind - max_y + round(ty);
xind = (x1:x2);
xind2 = xind - mean_x + round(tx);
mask = poly2mask(round(scale*sx), round(scale*sy), ...
    size(im_s, 1), size(im_s, 2));

[y, x] = find(mask);

y = y - max_y + round(ty);
x = x - mean_x + round(tx);
ind = y + (x-1)*size(im_t, 1);
mask2 = false(size(im_t, 1), size(im_t, 2));
mask2(ind) = true;

im_s2(yind2, xind2, :) = im_s(yind, xind, :);
im_t(repmat(mask2, [1 1 3])) = im_s2(repmat(mask2, [1 1 3]));

figure(1), hold off, imagesc(im_s2), axis image;
figure(2), hold off, imagesc(im_t), axis image;
drawnow;
