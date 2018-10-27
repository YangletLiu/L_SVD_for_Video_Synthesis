clear;

%profile on

% % parameter setting
% rng(234923);    % for reproducible results
fileName='person15_walking_d1_uncomp.avi';
obj=VideoReader(fileName);
dura=obj.Duration;
fraR=obj.FrameRate;
N=dura*fraR;
H=obj.Height;
W=obj.Width;

Original_Video=zeros(H,W,N);

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
V0=zeros(H,W,num_fra);
V0(:,:,1:29)=V1;
V0(:,:,30:58)=V2;
V0(:,:,59:84)=V3;
V0(:,:,85:113)=V4;

m=H/4;
n=W/4;
V=zeros(m,n,N);
for f=1:num_fra
    for i=1:m
        for j=1:n
            V(i,j,f)=V0(i*4,j*4,f);
        end
    end
end
clear i j f;
        
k=80;
r=2;
T=V(:,:,1:k);
%[m,n,k] = size(T);

T_f = fft(T, [], 3);
% observations
p=8000:8000:11*8000;
error = zeros(1,75);
%T_omega = zeros(m,n,k);

for ii=1:11
    num_miss_frame         =         p(ii)                            ;
    omega                  =        ones(m,n,k)                ;
    miss_index             =        randperm(m*n*k,num_miss_frame)   ;
    %miss                   =        zeros(n1,n2);
    for i=1:num_miss_frame
        for m1=1:1:m
            for n1=1:1:n
                for k1=1:1:k
                    if miss_index(i)==m*n*(k1-1)+m*(n1-1)+m1
                        omega(m1,n1,k1)=0;
                    end
                end
            end
        end
    end
                
   % for i=1:num_miss_frame
   %     omega(:,:,miss_index(i))  =        zeros(m,n)            ;
   % end
    clear i;

    %omega = rand(m,n,k) <= 0.5;
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
while iter <=5
    fprintf('Sample--%f---Round--#%d\n', p(ii), iter);
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
error(ii) = norm(temp(:)) / norm(T(:));
end

save('error_tubal_run','error');

S_R=8000:8000:11*8000;
i=1:11;
figure;
plot(S_R(i),error(12-i),'-o');xlabel('Sample number');
ylabel('RSE in log-scale');
   

    

%profile viewer
