% Perform t-SVD

function [U,Theta, V]=t_svd(M)

[n1,n2,n3]=size(M);

%% FFT along the third dimension
D = zeros(n1,n2,n3);
% for i=1:n1
%     for j=1:n2
%        D(i,j,:) = fft(M(i,j,:));
%     end
% end

D = fft(M,[],3); % FFT along the third dimension

Uf = zeros(n1,n1,n3);
Thetaf = zeros(n1,n2,n3);
Vf = zeros(n2,n2,n3);

for i=1:n3
    [temp_U, temp_Theta, temp_V] = svd( D(:,:,i));
    Uf(:,:,i) = temp_U; 
    Thetaf(:,:,i) = temp_Theta;
    Vf(:,:,i) = temp_V;
end

% for i = 1:n1
%     for j=1:n2
%         U(i,j,:) = ifft(Uf(i,j,:));
%         Theta(i,j,:) = ifft(Thetaf(i,j,:));
%         V(i,j,:) = ifft(Vf(i,j,:));
%     end
% end

% FFT along the third dimension
U = ifft(Uf,[],3);
Theta = ifft(Thetaf,[],3);
V = ifft(Vf,[],3);

