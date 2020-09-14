function fout = AdaptiveBox(fin, r)

[m, n] = size(fin);
r_max = max(r(:));
y = ComputeSSI(fin, r_max+1);

fout = zeros(size(fin));
K = r_max + 1;

for i=1:m
    for j = 1:n
        k = r(i, j);
        fout(i,j) = (y(i + K - k -1, j + K - k -1) + y(i + K + k, j + K + k) ...
            -(y(i + K - k - 1, j + K + k) + y(i + K + k, j + K - k - 1)))...
            /(2*k + 1)^2;
    end
end
 
