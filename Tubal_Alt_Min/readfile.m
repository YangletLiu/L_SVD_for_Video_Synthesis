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

%预处理
pre_H=H/2;
pre_W=W/2;
Video=zeros(pre_H,pre_W,N);
for k=1:N
   for j=1:pre_W
       for i=1:pre_H
           Video(i,j,k)= Original_Video((i-1)*2+1,(j-1)*2+1,k);
       end
   end
end

%显示视频帧
hundred_num=fix(N/100);
for j=1:hundred_num
    figure;
    for i=1:100
        subplot(10,10,i);
        imagesc(Video(:,:,(j-1)*100+i));colormap(gray);
    end
    
end
remainder_num=N-hundred_num*100;
figure;
for i=1:remainder_num
   subplot(10,10,i);
   imagesc(Video(:,:,hundred_num*100+i));colormap(gray);
end

%考虑到空的背景图比较多，将视频帧分成小组，有人运动的帧

V1=Video(:,:,5:30);
V2=Video(:,:,99:124);
V3=Video(:,:,207:232);
V4=Video(:,:,303:328);

figure;
for i=1:26
    subplot(10,13,i);
    imagesc(V1(:,:,i));colormap(gray);
end