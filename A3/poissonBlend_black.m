function [v] = poissonBlend_black(mask_s, im_s, im_background)

% # variables of pixels
nv = sum(mask_s==1, 'all');
[y, x] = find(mask_s);
ny = max(y)-min(y)+1;
nx = max(x)-min(x)+1;

% Set M sufficiently large
M = 3*nv;
N = nv;
nzmax = 2*M;
A = sparse([],[],[], M, N, nzmax);
b = zeros(M,1);
s = im_s;
t = im_background;

imh = size(s, 1);
imw = size(s, 2);
im2var = zeros(imh, imw);
for i = 1:nv
    im2var(y(i),x(i)) = i;
end

e = 0;
for i = 1:nv
    vy = y(i);
    vx = x(i);
    if mask_s(vy, vx+1) == 1
        e = e+1;
        A(e, im2var(vy, vx+1)) = 1;
        A(e, im2var(vy, vx)) = -1;
        b(e) = s(vy,vx+1)-s(vy,vx);
    end 
    if mask_s(vy+1, vx) == 1
        e = e+1;
        A(e, im2var(vy+1, vx)) = 1;
        A(e, im2var(vy, vx)) = -1;
        b(e) = s(vy+1,vx)-s(vy,vx);
    end 
    
    if mask_s(vy, vx-1)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        b(e) = s(vy,vx)-s(vy,vx-1)+t(vy,vx-1);
    end
    if mask_s(vy, vx+1)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        b(e) = s(vy,vx)-s(vy,vx+1)+t(vy,vx+1);
    end
    if mask_s(vy-1, vx)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        b(e) = s(vy,vx)-s(vy-1,vx)+t(vy-1,vx);
    end
    if mask_s(vy+1, vx)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        b(e) = s(vy,vx)-s(vy+1,vx)+t(vy+1,vx);
    end
end

v = A \ b;

end