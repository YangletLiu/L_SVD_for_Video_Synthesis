addpath('NCPC');
clear all
load walking1

[m,n,k]=size(M);
known=ones([m,n,k]);
miss_frames_num=2;
miss_index=[3,6];
for i=1:miss_frames_num
    known(:,:,miss_index(i))=0;
end
known=known(:);
index=1;
for i=1:m*n*k
    if known(i)~=0
        Omega(index)=i;
        index=index+1;
    end
end
data=M(Omega);
ndim = [m,n,k];
%% Solve problem
% exact rank works but a rough rank overestimate is also fine
esr = 27; % overestimate of rank
opts.tol = 1e-15; opts.maxit = 100000;
t0 = tic;
[A,Out] = ncpc(data,Omega,ndim,esr,opts);
time = toc(t0);

%% Reporting
B=double(A);
relerr = norm(B(:)-M(:))/norm(M(:));
fprintf('time = %4.2e, ',time);
fprintf('solution relative error = %4.2e\n\n',relerr);

figure;
semilogy(1:Out.iter, Out.hist_obj,'k-','linewidth',2);
xlabel('iteration','fontsize',12);
ylabel('objective value','fontsize',12)

figure;
semilogy(1:Out.iter, Out.hist_rel(2,:),'k-','linewidth',2);
xlabel('iteration','fontsize',12);
ylabel('relative residual','fontsize',12)


 subplot(2,1,1);imagesc(double(B(:,:,3)));colormap(gray);
 subplot(2,1,2);imagesc(M(:,:,3));colormap(gray);

%% <http://www.caam.rice.edu/~optimization/bcu/ncpc/example_ncpc.m Download this m-file>