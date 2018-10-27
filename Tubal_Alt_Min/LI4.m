clear;

fileName='running\person01_running_d1_uncomp.avi';
obj=VideoReader(fileName);
dura=obj.Duration;
fraR=obj.FrameRate;
N=dura*fraR;
m=obj.Height;
n=obj.Width;

Original_Video=zeros(m,n,N);

for i=1:N
    video=readFrame(obj);
    video=rgb2gray(video);
    Original_Video(:,:,i)=video;
end
Original_Video=Original_Video/255;
Video=Original_Video;

V1=Video(:,:,3:31);
V2=Video(:,:,97:125);
V3=Video(:,:,207:232);
V4=Video(:,:,302:330);
num_fra=113;
V0=zeros(m,n,num_fra);
V0(:,:,1:29)=V1;
V0(:,:,30:58)=V2;
V0(:,:,59:84)=V3;
V0(:,:,85:113)=V4;

k=40;
T=V0(:,:,1:k);

num_miss_frame         =         1                            ;
Omega                  =        ones(m,n,k)                ;
miss_index             =        randperm(k,num_miss_frame)   ;
%miss                   =        zeros(n1,n2)                  ;
for i=1:num_miss_frame
    Omega(:,:,miss_index(i))  =        zeros(m,n)            ;
end
clear i;

%% ================ main process of completion =======================
r=20;
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
    fprintf('Sampling--%f---Round--#%d\n', p(ii), iter);
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

temp = T - T_est;   
error = norm(temp(:)) / norm(T(:));

for i=1:num_miss_frame
    figure;
    subplot(121);imagesc(Xn(:,:,miss_index(i)));axis off;
    colormap(gray);title('Original Video Frame');
    subplot(122);imagesc(X(:,:,miss_index(i)));axis off;
    colormap(gray);title('Recovered Video Frame');
end



%for i=1:num_fra
  %  imshow(V0(:,:,i));
%end
