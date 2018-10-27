clear;

addpath('tSVD','proxFunctions','solvers')      ;

fileName='person01_running_d1_uncomp.avi';
obj=VideoReader(fileName);
dura=obj.Duration;
fraR=obj.FrameRate;
N=dura*fraR;
n1=obj.Height;
n2=obj.Width;

Original_Video=zeros(n1,n2,N);

for i=1:N
    video=readFrame(obj);
    video=rgb2gray(video);
    Original_Video(:,:,i)=video;
end

Video=Original_Video;

V1=Video(:,:,3:31);
V2=Video(:,:,97:125);
V3=Video(:,:,207:232);
V4=Video(:,:,302:330);
sum_fra=113;
V0=zeros(n1,n2,sum_fra);
V0(:,:,1:29)=V1;
V0(:,:,30:58)=V2;
V0(:,:,59:84)=V3;
V0(:,:,85:113)=V4;
n3=40;
T=V0(:,:,1:n3);
Xn=T/255;

num_miss_frame         =         1                            ;
Omega                  =        ones(n1,n2,n3)                ;
miss_index             =        randperm(n3,num_miss_frame)   ;
%miss                   =        zeros(n1,n2)                  ;
for i=1:num_miss_frame
    Omega(:,:,miss_index(i))  =        zeros(n1,n2)            ;
end
clear i;

alpha                  =        1                             ;
maxItr                 =        1000                          ; % maximum iteration
rho                    =        0.01                          ;
myNorm                 =        'tSVD_1'                      ; % dont change for now

A                      =        diag(sparse(double(Omega(:)))); % sampling operator     
b                      =        A * Xn(:)                     ; % available data
bb                     =        reshape(b,[n1,n2,n3]);

%% ================ main process of completion =======================
X   =    tensor_cpl_admm( A , b , rho , alpha , ...
                     [n1,n2,n3] , maxItr , myNorm , 0 );
X                      =        X * 255                 ;
X                      =        reshape(X,[n1,n2,n3])         ;
            
X_dif                  =        T-X                           ;
RSE                    =        norm(X_dif(:))/norm(T(:))     ;
%% ======================== Result Plot =============================

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
