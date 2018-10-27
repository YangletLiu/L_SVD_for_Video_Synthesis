%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tensor completion for esimtating missing values in visual data, PAMI,
% example.m file
% Date Mar. 13, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('LRTC');
clc;
clear;
close all;

load walking1
[m,n,k]=size(M);
Original=M;
%set the number of missing frames
miss_frames_num=2;
miss_index=[3,6];
Omega = ones([m,n,k]);
for i=1:miss_frames_num
    Omega(:,:,miss_index(i))=0;
end

T=M.*Omega;
Omega=logical(Omega);

alpha = [1, 2, 1e-3];
alpha = alpha / sum(alpha);

maxIter = 100000;
epsilon = 1e-10;

% "X" returns the estimation, 
% "errList" returns the list of the relative difference of outputs of two neighbor iterations 

%% High Accuracy LRTC (solve the original problem, HaLRTC algorithm in the paper)
rho = 1e-6;
[X_H, errList_H] = HaLRTC(...
    T, ...                       % a tensor whose elements in Omega are used for estimating missing value
    Omega,...               % the index set indicating the obeserved elements
    alpha,...                  % the coefficient of the objective function, i.e., \|X\|_* := \alpha_i \|X_{i(i)}\|_* 
    rho,...                      % the initial value of the parameter; it should be small enough  
    maxIter,...               % the maximum iterations
    epsilon...                 % the tolerance of the relative difference of outputs of two neighbor iterations 
    );



figure('units','normalized','outerposition',[0 0 1 1]);
% figure;
% set(0, 'DefaultFigurePosition', [0, 0, 2000, 1000]);
subplot(2,4,1);
imagesc(Original(:,:,3));colormap(gray);
title('Original');
subplot(2,4,2);
imagesc(T(:,:,3));colormap(gray);
title('Missing Values');
subplot(2,4,3);
imagesc(X_H(:,:,3));colormap(gray);
title('HaLRTC');



