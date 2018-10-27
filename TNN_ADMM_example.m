
clear all
close all
clc

%% ====================== Load data ==============================
addpath('TNN_ADMM/tSVD','TNN_ADMM/proxFunctions','TNN_ADMM/solvers') ;
load walking1

[n1,n2,n3]=size(M);
miss_frames_num=2;
miss_index=[3,6];
Omega=ones([n1,n2,n3]);
for i=1:miss_frames_num
    Omega(:,:,miss_index(i))=0;
end
Xn=M/255;

    clear i;

    alpha                  =        1.0                             ;
    maxItr                 =        10000                          ; % maximum iteration
    rho                    =        0.01                          ;
    myNorm                 =        'tSVD_1'                      ; % dont change for now

    A                      =        diag(sparse(double(Omega(:)))); % sampling operator     
    b                      =        A * Xn(:)                     ; % available data
    bb                     =        reshape(b,[n1,n2,n3]);

    %% ================ main process of completion =======================
    X   =    tensor_cpl_admm( A , b , rho , alpha , ...
                         [n1,n2,n3] , maxItr , myNorm , 0 );
    %X                      =        X * normalize                 ;
    X                      =        reshape(X,[n1,n2,n3])         ;

    X_dif                  =        Xn-X                           ;
    RSE                    =        norm(X_dif(:))/norm(Xn(:))     ;
    error=RSE;
%% ======================== Result Plot =============================
save('error_tnn_run','error');

%figure;
subplot(221);imagesc(Xn(:,:,3));axis off;
colormap(gray);title('Original Video');
subplot(222);imagesc(X(:,:,3)) ;axis off;
colormap(gray);title('Recovered Video');

