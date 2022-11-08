function [v] = poissonBlend_mixed_black(mask_s, im_s, im_background)

% # variables of pixels
nv = sum(mask_s==1, 'all');
[y, x] = find(mask_s);
ny = max(y)-min(y)+1;
nx = max(x)-min(x)+1;

% M = 2*nv-ny-nx+1;
% M = 2*nv + ny + nx;
M = 3*nv;
% M = 3*nv;
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
%     internal gradient
    if mask_s(vy, vx+1) == 1
        e = e+1;
        A(e, im2var(vy, vx+1)) = 1;
        A(e, im2var(vy, vx)) = -1;
        d = s(vy,vx+1)-s(vy,vx);
        if abs(d)<abs(t(vy,vx+1)-t(vy,vx))
            d = t(vy,vx+1)-t(vy,vx);
        end
        b(e) = d;
    end 
    if mask_s(vy+1, vx) == 1
        e = e+1;
        A(e, im2var(vy+1, vx)) = 1;
        A(e, im2var(vy, vx)) = -1;
        d = s(vy+1, vx)-s(vy,vx);
        if abs(d)<abs(t(vy+1, vx)-t(vy,vx))
            d = t(vy+1,vx)-t(vy,vx);
        end
        b(e) = d;
    end 
%     boundary condition
    if mask_s(vy, vx-1)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        d = s(vy,vx)-s(vy,vx-1);
        if abs(d)<abs(t(vy,vx)-t(vy,vx-1))
            d = t(vy,vx)-t(vy,vx-1);
        end
        b(e) = d+t(vy,vx-1);
    end
    if mask_s(vy, vx+1)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        d = s(vy,vx)-s(vy,vx+1);
        if abs(d)<abs(t(vy,vx)-t(vy,vx+1))
            d = t(vy,vx)-t(vy,vx+1);
        end
        b(e) = d+t(vy,vx+1);
    end
    if mask_s(vy-1, vx)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        d = s(vy,vx)-s(vy-1,vx);
        if abs(d)<abs(t(vy,vx)-t(vy-1,vx))
            d = t(vy,vx)-t(vy-1,vx);
        end
        b(e) = d+t(vy-1,vx);
    end
    if mask_s(vy+1, vx)==0
        e = e+1;
        A(e, im2var(vy, vx)) = 1;
        d = s(vy,vx)-s(vy+1,vx);
        if abs(d)<abs(t(vy,vx)-t(vy+1,vx))
            d = t(vy,vx)-t(vy+1,vx);
        end
        b(e) = d+t(vy+1,vx);
    end
end

% e = e+1;
% vy = y(1);
% vx = x(1);
% A(e, im2var(vy,vx)) = 1;
% b(e) = im_background(vy,vx);
% b(e) = 0.5;

v = A \ b;
end