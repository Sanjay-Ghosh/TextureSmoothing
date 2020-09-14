function [ eroded,grad,blurred ] = edgeDetector( f,blursize,erodesize )
%EDGEDETECTOR 
% f = Input image
% blursize = Length of blurring filter (odd)
% erodesize = Length of eroding structuring element (odd)
% H = Output metric

if(size(f,3)==3)
    f = double(rgb2gray(uint8(f)));
end

blurred = imfilter(f,ones(blursize)/(blursize*blursize),'symmetric');
grad = imgradient(blurred);
eroded = imerode(grad,ones(erodesize));
eroded = eroded/max(eroded(:));

end

