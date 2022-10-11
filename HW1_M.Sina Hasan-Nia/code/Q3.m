%---------------------------  Q3  -----------------------------
close all ; clear all , clc;
image =  "..\pics\wall.jpeg";  % image path 
img = imread(image);
%% Part A
filter = [1, -1];
Org_filteredplotter(img,filter,1,"none")
filter = [1,0];
Org_filteredplotter(img,filter,1,"none")
filter = [1, 0, -1]';
Org_filteredplotter(img,filter,0,"none")
filter = [1, -2, 1];
Org_filteredplotter(img,filter,1,"none")
filter = [1, -2, 1]';
Org_filteredplotter(img,filter,0,"none")
%% Part B
%%% Sobel
filtered_img = edge(rgb2gray(img), "sobel");
figure()
subplot(1,2,1)
imshow(img)
title("Orginal Image",'Interpreter','latex')
subplot(1,2,2)
imshow(filtered_img)
title("Filtered Image",'Interpreter','latex')
sgtitle("Orginal Image & sobel edge detedctor",'Interpreter','latex')
%%% canny
filtered_img = edge(rgb2gray(img), "canny");
figure()
subplot(1,2,1)
imshow(img)
title("Orginal Image",'Interpreter','latex')
subplot(1,2,2)
imshow(filtered_img)
title("Filtered Image",'Interpreter','latex')
sgtitle("Orginal Image & canny edge detedctor",'Interpreter','latex')
%% Part C 
filter = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
Org_filteredplotter(img,filter,-1,"Laplacian")
%% part D
image_noisy = imnoise(img, "gaussian");
lap_filter = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
Iblur1 = imgaussfilt(image_noisy,2);
filtered_img1 = imfilter(image_noisy, lap_filter);
filtered_img2 = imfilter(Iblur1, lap_filter);
filtered_img3 = edge(rgb2gray(image_noisy), "log");
figure()
subplot(1,4,1)
imshow(image_noisy)
title("Orginal Image",'Interpreter','latex')
subplot(1,4,2)
imshow(filtered_img1)
title("Filtered Image using Laplacian without Guassian kernel",'Interpreter','latex')
subplot(1,4,3)
imshow(filtered_img2)
title("Filtered Image using guassian filter befor Laplacian(manually)",'Interpreter','latex')
subplot(1,4,4)
imshow(filtered_img3)
title("Filtered Image(Using matlab command(LOG)",'Interpreter','latex')
sgtitle("Solve Laplacian Filter problem",'Interpreter','latex')
%% Functions 
function Org_filteredplotter(I,filter,flag,name)
filtered_img = imfilter(I, filter);
figure()
subplot(1,2,1)
imshow(I)
title("Orginal Image",'Interpreter','latex')
subplot(1,2,2)
imshow(filtered_img)
title("Filtered Image",'Interpreter','latex')
if flag == 1
    str = "visuallization of Original and Filtered image by filter = [ "  + num2str(filter)+"]" ;
    sgtitle(str,'Interpreter','latex')
elseif flag ==0 
    str = "visuallization of Original and Filtered image by filter = transpose [ "  + num2str(filter') + "]" ; 
    sgtitle(str,'Interpreter','latex')
elseif flag ==-1
    str = "visuallization of Original and Filtered image by filter "+ name ; 
    sgtitle(str,'Interpreter','latex')
end
end
