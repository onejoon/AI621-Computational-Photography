function [g,lE] = gsolve(Z,B,l,w)

n = 256;
M = size(Z,1)*size(Z,2)+n+1;
A = sparse([],[],[],M,n+size(Z,1),3*M);
b = zeros(size(A,1),1);

k = 1;
for i=1:size(Z,1)
    for j=1:size(Z,2)
        wij = w(Z(i,j)+1);
        A(k,Z(i,j)+1) = wij;
        A(k,n+i) = -wij;
        b(k,1) = wij*B(i,j);
        k = k+1;
    end
end

A(k,129) = 1; % middle value = zero
k = k+1;

% smoothness equation
for i=1:n-2
    A(k,i) = l*w(i+1);
    A(k,i+1) = -2*l*w(i+1);
    A(k,i+2) = l*w(i+1);
    k = k+1;
end

x = A\b;

g = x(1:n);
lE = x(n+1:size(x,1));

end

