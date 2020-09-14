function [ Rmin ] = localMinFilter( fin,w )
%LOCALMINFILTER Summary of this function goes here
%   Detailed explanation goes here

sym    = (w - 1)/2;
[minput, ninput] = size(fin);
rowpad=(ceil(minput/w)*w)-minput;
columnpad=(ceil(ninput/w)*w)-ninput;
template=padarray(fin,[rowpad,columnpad],Inf,'post');
[m,n]=size(template);
Rmin = nan(minput,ninput);

% scan along row
for ii = 1 : minput
    L     = zeros(n, 1);
    R     = zeros(n, 1);
    L(1)  = template(ii, 1);
    R(n)  = template(ii, n);
    for k = 2 : n
        if  mod(k - 1, w) == 0
            L(k)          = template(ii ,  k);
            R(n - k + 1)  = template(ii ,  n - k + 1);
        else
            L(k)          = min( L(k-1) , template(ii, k) );
            R(n - k + 1)  = min( R(n - k + 2), template(ii, n - k + 1) );
        end
    end
    for k = 1 : n
        p = k - sym;
        q = k + sym;
        if p < 1
            r = Inf;
        else
            r = R(p);
        end
        if q > n
            l = Inf;
        else
            l = L(q);
        end
        template(ii, k) = min(r,l);
    end
end
% scan along column
for jj = 1 : ninput
    L    = zeros(m, 1);
    R    = zeros(m, 1);
    L(1) = template(1, jj);
    R(m) = template(m, jj);
    for k = 2 : m
        if  mod(k - 1, w) == 0
            L(k)          = template(k, jj);
            R(m - k + 1)  = template(m - k + 1, jj);
        else
            L(k)          = min( L(k - 1), template(k, jj) );
            R(m - k + 1)  = min( R(m - k + 2), template(m - k + 1, jj));
        end
    end
    for k = 1 : m
        p = k - sym;
        q = k + sym;
        if p < 1
            r = Inf;
        else
            r = R(p);
        end
        if q > m
            l = Inf;
        else
            l = L(q);
        end
        
        if (k<=minput)
            Rmin(k,jj) = min(r,l);
        end
    end
end

end

