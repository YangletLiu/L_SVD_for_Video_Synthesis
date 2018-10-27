function c=transpos(a)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [n1 n2 n3]=size(a);
    c=zeros(n2,n1,n3);
    
    c(:,:,1)=a(:,:,1)';
    for i=2:n3
        c(:,:,i)=a(:,:,n3-i+2)';
    end

end

