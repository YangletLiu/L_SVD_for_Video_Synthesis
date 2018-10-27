function b = bcirc( a )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
     [a_n1 a_n2 a_n3]=size(a);
     
     index_up=zeros(1,a_n3);
       index_down=zeros(1, a_n3);
       for i=1:a_n3
           index_up(i)=a_n3-i+1;
           index_down(i)=i;
       end
       
     m=a_n1*a_n3;
     
     n=a_n2*a_n3;
     
     b=zeros(m,n);
     for j=1:a_n3
         for i=1:a_n3
             if i==j
                   b((i-1)*a_n1+1:i*a_n1,(j-1)*a_n2+1:j*a_n2)=a(:,:,1);
               end
               if j>i
                   b((i-1)*a_n1+1:i*a_n1,(j-1)*a_n2+1:j*a_n2)=a(:,:,index_up(j-i));
               end
               if j<i
                   b((i-1)*a_n1+1:i*a_n1,(j-1)*a_n2+1:j*a_n2)=a(:,:,index_down(i-j+1));
               end
         end
     end

end

