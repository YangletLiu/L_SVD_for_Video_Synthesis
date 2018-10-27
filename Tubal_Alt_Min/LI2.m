clear;

fileName='running\person01_running_d1_uncomp.avi';
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

%‘§¥¶¿Ì
pre_H=H;
pre_W=W;

Video=Original_Video;

V1=Video(:,:,5:30);
%[U1,S1,V1]=t_svd(V1);

F=26; S_F=25;
Ob_V1=zeros(pre_H,pre_W,F);

Ob_index=randperm(F,S_F);
Ob_index=sort(Ob_index);
Wh=1:F;
Loss_index=setdiff(Wh,Ob_index);

Omega=zeros(pre_H,pre_W,F);

for i=1:S_F
    Omega(:,:,Ob_index(i))=ones(pre_H,pre_W);
    Ob_V1(:,:,Ob_index(i))=V1(:,:,Ob_index(i));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=V1;
r=20;
m=pre_H;n=pre_W;k=F;
T_omega=Ob_V1;

omega=Omega;

T_omega_f = fft(T_omega,[],3);
    omega_f = fft(omega, [], 3);
    
 Y = rand(r, n, k);
   
    Y_f = fft(Y, [], 3);

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

T_est=round(T_est);
T_est=mod(T_est,255);

temp = T - T_est;   
error = norm(temp(:)) / norm(T(:));

f=Loss_index(1);
subplot(4,4,1);
imagesc(T_est(:,:,f));colormap(gray);
subplot(4,4,2);
imagesc(T(:,:,f));colormap(gray);

