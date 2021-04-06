%CENG 462 IMAGE PROCESSING
%Pelinsu SERİMER, Kemal Berke SAKA, Önen Emre CAN

%Workspace cleaning:
clc
clear all
close all

%Image reading:
RGBImage = imread('image4.png');

%Converting rgb image to grayscale:
input = double(RGBImage) / 255;
gray = (input(:,:,1) + input(:,:,2) + input(:,:,3)) / 3;

%Threshold value:
Threshold = 0.2; 

%Applying sobel masking with tresholding:
Sobel = edge(gray, 'sobel', Threshold);

%Normalization:                     
ImNormal = (Sobel-min(Sobel(:)))/(max(Sobel(:))-min(Sobel(:))); 

%Dilation:
ImDilate = imdilate(ImNormal,strel('rectangle',[1,5]));

%Filling the holes in the image:
ImFill   = imfill(ImDilate,'holes');  

%Computing areas over the image:
[labels,num] = bwlabel(ImFill);
Areas   = zeros(num,1);
for i = 1:num                          
[r,c,v]  = find(labels == i);                
Areas(i) = sum(v);                         
end   

%Coordinating the biggest area over the image: 
Biggest = find(Areas == max(Areas));  
[x,y]   = find(labels == Biggest);  
rCorner = (min(x) :max(x));
cCorner = (min(y) :max(y));

%Car Plate Location:
figure
imshow(RGBImage); title('Car Plate')
hold on
rectangle('Position',[min(cCorner),min(rCorner),max(cCorner)-min(cCorner),max(rCorner)-min(rCorner)],'LineWidth',5,'EdgeColor','y')
hold off