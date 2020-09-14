function [ S ] = textureFilter( f,W,sigma_0,gamma,iter )
%TEXTUREFILTER Summary of this function goes here
%   Detailed explanation goes here

h = fspecial('average',[5,5]);
f_blurred = imfilter(double(f), h);

S = cell(1,iter);
ftemp = f_blurred;
for j = 1:iter
    F = zeros(size(f));
    for c = 1 : size(f,3)
        F(:,:,c) = shiftableBF_box_adaptive(ftemp(:,:,c), W, sigma_0*(gamma^j));
    end
    S{j} = F;
    ftemp = F;
end

if(iter==1)
    S = S{1};
end

end

