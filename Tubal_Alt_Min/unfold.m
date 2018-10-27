function [ y ] = unfold( Y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   [n1 n2 n3]=size(Y);
   y=zeros(n1*n3,1);
   for i=1:n3
       y((i-1)*n1+1:i*n1)=Y(:,1,i);
   end

end

