function c=t_product(a,b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [a_n1 a_n2 a_n3]=size(a);
    [b_n1 b_n2 b_n3]=size(b);
    if a_n2==b_n1&&a_n3==b_n3
       c=zeros(a_n1,b_n2,a_n3);
       A=cell(a_n3,1);
       B=cell(b_n3,1);
       
       for i=1:a_n3
           A{i}=a(:,:,i);
           B{i}=b(:,:,i);
       end
       
       index_up=zeros(1,a_n3);
       index_down=zeros(1, a_n3);
       for i=1:a_n3
           index_up(i)=a_n3-i+1;
           index_down(i)=i;
       end
       
       s=cell(a_n3,a_n3);
       for i=1:a_n3
           for j=1:a_n3
               if i==j
                   s{i,j}=A{1};
               end
               if j>i
                   s{i,j}=A{index_up(j-i)};
               end
               if j<i
                   s{i,j}=A{index_down(i-j+1)};
               end
           end
       end
       
       re=cell(a_n3,1);
       for i=1:a_n3
           re{i}=zeros(a_n1,b_n2);
       end
       
       for i=1:a_n3
           for j=1:a_n3
               for k=1:1
                   re{i,k}=re{i,k}+s{i,j}*B{j,k};
               end
           end
       end
       for i=1:a_n3
           c(:,:,i)=re{i};
       end
    
    else
        c=0;
    end
    

end

