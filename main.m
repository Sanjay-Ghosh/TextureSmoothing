
clearvars; close all;
clc;

input_img = './fish2.jpg';

rsz = 1;            % Resize the input image by this factor
blursize = 9;       % Width of blurring filter
erodesize = 5;      % Width of tructuring element for erosion
Wmin = 0;           % Minimum value of half-width
Wmax = 15;          % Maximum value of half-width
lambda = 4;         % Exponential parameter (see paper)
sigma_r = 30;       % Range kernel parameter
gamma = 0.7;        % Decay parameter (see Section IV-B in paper)
iterations = 2;     % No. of filtering iterations

% Read input image
f = imread(input_img);
f = imresize(f,rsz);
f = double(f);

% Find strong edges
[E,G,B] = edgeDetector(f,blursize,erodesize);
figure; imshow(E); colorbar; title('Edge map'); drawnow; pause(0.01);

% Compute scales
W = edges2W(E,Wmin,Wmax,lambda);

% Filter textures
tic;
S = textureFilter(f,W,sigma_r,gamma,iterations);
toc;

figure; imagesc(W); axis image; axis off; colorbar; title('W'); drawnow; pause(0.01);
if(iterations==1)
    figure; imshow(uint8(S)); title('Output'); drawnow;
else
    figure; imshow(uint8(S{end})); title('Output'); drawnow;
end

