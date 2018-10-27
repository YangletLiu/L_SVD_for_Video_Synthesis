clear all
close all
clc

%% ====================== Load data ==============================

load video.mat
normalize              =        max(T(:))                     ;
T                     =        T/normalize                   ;
[m,n,k]             =        size(T)                      ;
num_miss_frame         =         1                            ;
omega                  =        ones(size(T))                ;
miss_index             =        randperm(k,num_miss_frame)   ;
%miss                   =        zeros(n1,n2)                  ;
for i=1:num_miss_frame
    omega(:,:,miss_index(i))  =        zeros(m,n)            ;
end
clear i;
%% ================ main process of completion =======================
r=10;
T_f = fft(T, [], 3);
T_omega = omega .* T;

T_omega_f = fft(T_omega,[],3);
omega_f = fft(omega, [], 3);

% X: m * r * k
% Y: r * n * k
%% Given Y, do LS to get X
    Y = rand(r, n, k);
    %Y= init(T_omega, m,r,k);
    
    %[U, Theta, V]=t_svd(T_omega);
    %Y = V(1:r, :, :);
    
    Y_f = fft(Y, [], 3);

% do the transpose for each frontal slice
    Y_f_trans = zeros(n,r,k);
    X_f = zeros(m,r,k);
    T_omega_f_trans = zeros(n,m,k);
    omega_f_trans = zeros(n,m,k);
for i = 1: k
     Y_f_trans(:,:,i) = Y_f(:,:,i)';
     T_omega_f_trans(:,:,i) = T_omega_f(:,:,i)';
     omega_f_trans(:,:,i) = omega_f(:,:,i)';
end

iter=1;
while iter <=15
    fprintf('Round--#%d\n', iter);
    [X_f_trans] = alter_min_LS_one_step(T_omega_f_trans, omega_f_trans * 1/k, Y_f_trans);
    
    for i =1:k
        X_f(:,:,i) = X_f_trans(:,:,i)';
    end

    % Given X, do LS to get Y
    [Y_f] = alter_min_LS_one_step(T_omega_f, omega_f * 1/k, X_f);
    
    for i = 1: k
    Y_f_trans(:,:,i) = Y_f(:,:,i)';
    end
    
    iter = iter + 1;
end

% The relative error:
%temp = 0;
X_est = ifft(X_f, [], 3); 
Y_est = ifft(Y_f, [], 3);
T_est = tprod(X_est, Y_est);
T_est1=abs(T_est);

temp = T - T_est1;   
error = norm(temp(:)) / norm(T(:));

for i=1:num_miss_frame
    figure;
    subplot(121);imagesc(T(:,:,miss_index(i)));axis off;
    colormap(gray);title('Original Video Frame');
    subplot(122);imagesc(T_est1(:,:,miss_index(i)));axis off;
    colormap(gray);title('Recovered Video Frame');
end

