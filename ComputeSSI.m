function s = ComputeSSI(Image, Rmax)
% Input:
%   Image - Noised image
%   M     - Patch size
% Output:
%   s -  Sum of pixels in M x M patch around every pixels
% For every pixel k in input image, ComputeSSI routine calculates sum of squared
% pixels in a M x M patch around k
size(Rmax);
Img = double(Image);
Image = padarray(Img, [Rmax,Rmax],'symmetric');
[nRows, nCols] = size(Image);
SquaredImage = Image; % Image.^2;
SSI = zeros(size(Image));
% Find squared integral image
for i = 1 : nRows
    for j = 1 : nCols
        if (i == 1) && (j == 1) % for first element
            SSI(i,j) = SquaredImage(i,j);
        elseif (i == 1) && (j > 1) % for first row elements
            SSI(i,j) = SSI(i,j-1) + SquaredImage(i,j);
        elseif (i > 1) && (j == 1) % for first column elements
            SSI(i,j) = SSI(i-1,j) + SquaredImage(i,j);
        elseif (i > 1) && (j > 1)  % for remaining elements
            SSI(i,j) = SSI(i,j-1) + SSI(i-1,j) - SSI(i-1,j-1) + SquaredImage(i,j);
        end
    end
end
s = SSI;
end
