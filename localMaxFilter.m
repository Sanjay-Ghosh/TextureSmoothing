function [ Rmax ] = localMaxFilter( fin,w )
%LOCALMAXFILTER Summary of this function goes here
%   Detailed explanation goes here

sym    = (w - 1)/2;
[minput, ninput] = size(fin);
rowpad=(ceil(minput/w)*w)-minput;
columnpad=(ceil(ninput/w)*w)-ninput;
template=padarray(fin,[rowpad,columnpad],'post','replicate');
[m,n]=size(template);
Rmax = nan(minput,ninput);

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
            L(k)          = max( L(k-1) , template(ii, k) );
            R(n - k + 1)  = max( R(n - k + 2), template(ii, n - k + 1) );
        end
    end
    for k = 1 : n
        p = k - sym;
        q = k + sym;
        if p < 1
            r = -1;
        else
            r = R(p);
        end
        if q > n
            l = -1;
        else
            l = L(q);
        end
        template(ii, k) = max(r,l);
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
            L(k)          = max( L(k - 1), template(k, jj) );
            R(m - k + 1)  = max( R(m - k + 2), template(m - k + 1, jj));
        end
    end
    for k = 1 : m
        p = k - sym;
        q = k + sym;
        if p < 1
            r = -1;
        else
            r = R(p);
        end
        if q > m
            l = -1;
        else
            l = L(q);
        end
        
        if (k<=minput)
            Rmax(k,jj) = max(r,l);
        end
    end
end

end

