function [ fout , param ]  =  shiftableBF_box_adaptive(fin, r, sigmar)
[m, n]   =  size(fin);
fout  =  zeros(m, n);
ii = sqrt(-1);

% compute local dynamic range
w = 2*max(r(:)) +1;
T  =  maxFilter(fin, w);
Tmax = max(T,ceil(3*sigmar));

% Fourier Basis Algorithm
eps = 1e-1;
K = T+1;
w0 = pi/Tmax;
samples = (1:K)';
b = exp(-0.5*(samples-1).^2/sigmar^2);
m = 1;
a = cos((m-1)*w0*(samples-1));
R = norm(a);
Q = a/R;
A = a;
proj = Q'*b;
residual = norm(b - Q*proj);
while residual > eps
    m = m+1;
    rho = zeros(m,1);
    q = cos((m-1)*w0*(samples-1));
    A = [A, q]; %#ok<*AGROW>
    for j = 1 : m-1
        % new q and rho
        qm = Q(:,j);
        rho(j) = qm'*q;
        q = q - rho(j)*qm;
    end
    rho(m) =norm(q);
    q = q/rho(m);
    Q = [Q, q];
    proj = [proj; q'*b];
    R = [R; zeros(1,m-1)];
    R = [R, rho];
    c = backSub(R,proj,m);
    residual = [residual, norm(b-A*c)];
    % save parameters
    param.T  = T;
    param.N  = m-1;
    param.coeff = c;
end
L = length(c);
H0=exp(ii*w0*fin);
H = ones(size(fin));

fnum=c(1)* AdaptiveBox(fin, r);

fdenom  = c(1);
for k = 2 : L
    H = H.*H0;
    G  = conj(H);
    F  =  G.*fin;
    barF  =  AdaptiveBox(F, r);
    barG  =  AdaptiveBox(G, r);
    fnum =  fnum + real(c(k)*(H.*barF));
    fdenom  = fdenom + real(c(k)*(H.*barG));
end

% check for division by small numbers
idx1 = find( fdenom < 1e-3);
idx2 = find( fdenom >= 1e-3);
fout( idx1 ) = fin( idx1 );
fout( idx2 ) = (fnum( idx2 )./fdenom (idx2 ));

end
