function [ W ] = edges2W( edgemap,Wmin,Wmax,lambda )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

W_temp = (Wmax - Wmin) * exp( -lambda* edgemap.^2 ) + Wmin;
W = round(W_temp);

end

