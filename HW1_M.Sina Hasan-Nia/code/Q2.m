%---------------------------  Q2  -----------------------------
close all ; clear all , clc;
image =  "..\pics\brainMRI.png";  % image path 
img = imread(image);
img = im2double(img(:,:,1));
%% PART A 
% generating the idx of the regions 
x_spliter = floor(size(img,1)/2);
y_spliter = floor(size(img,2)/2);
[noise_saltpeper,noisy_img_saltpeper] = noise_generator(img,"salt & pepper",0.05);
[noise_guassian,noisy_img_guassian] = noise_generator(img,"gaussian",[0,0.08]);
desired_img = img;
desired_img(1:x_spliter,1:y_spliter) = img(1:x_spliter,1:y_spliter) + noise_saltpeper(1:x_spliter,1:y_spliter);
desired_img(x_spliter+1:end,1:y_spliter) = img(x_spliter+1:end,1:y_spliter) + noise_guassian(x_spliter+1:end,1:y_spliter);
desired_img(x_spliter+1:end,y_spliter+1:end) = img(x_spliter+1:end,y_spliter+1:end) + noise_guassian(x_spliter+1:end,y_spliter+1:end)+ noise_saltpeper(x_spliter+1:end,y_spliter+1:end);
imshow(desired_img)
title("Generated Image",'Interpreter','latex','FontSize', 15)
%% Part B 
%mean filter
figure()
for kerlen = 3:2:9
    i = floor(kerlen/2);
    kernel_window = 1 / kerlen^2 * ones(kerlen);
    filtered_img = imfilter(desired_img, kernel_window, 'replicate');
    subplot(1,4,i)
    imshow(filtered_img)
    title("filtered Image with kernel size " + num2str(kerlen)+"x"+num2str(kerlen), 'Interpreter','latex')
end
sgtitle("Filtered image using mean filter",'Interpreter','latex')
% median filter
figure()
for kerlen = 3:2:9
    i = floor(kerlen/2);
    filtered_img = medfilt2(desired_img, [kerlen kerlen]);
    subplot(1,4,i)
    imshow(filtered_img)
    title("filtered Image with kernel size " + num2str(kerlen)+"x"+num2str(kerlen), 'Interpreter','latex')
end
sgtitle("Filtered image using median filter",'Interpreter','latex')
% guassian filter 
figure()
i = 1;
for sigma = [0.5 0.9 1.2 1.5 ]
    filtered_img = imgaussfilt(desired_img,sigma);
    subplot(1,4,i)
    imshow(filtered_img)
    title("filtered Image with kernel size " + num2str(floor(6*sigma))+"x"+num2str(floor(6*sigma)), 'Interpreter','latex')
    i = i + 1 ;
end
sgtitle("Filtered image using guassian filter",'Interpreter','latex')
%% Part C
sigma = 0.8; m = 5;
%%% first : median second : guassian
filtered_img11 = medfilt2(desired_img, [m m]);
filtered_img12 = imgaussfilt(filtered_img11, sigma);
%%% first : guassian second :  median
filtered_img21 = imgaussfilt(desired_img, sigma);
filtered_img22 = medfilt2(filtered_img21, [m m]);
%%% plot 
figure()
subplot(1,2,1)
imshow(filtered_img12)
title("first : median second : guassian",'Interpreter','latex')
subplot(1,2,2)
imshow(filtered_img22)
title("first : guassian second :  median",'Interpreter','latex')
sgtitle("Filtered image using filters simultanous",'Interpreter','latex' )
%% Part D
filtered_img_wnr = wiener2(desired_img, [7, 7]);
figure()
subplot(2,3, 1)
kernel_window = 1 / 49 * ones(7);
imshow(imfilter(desired_img, kernel_window, 'replicate'))
title("Mean filter",'Interpreter','latex')
subplot(2,3, 2)
imshow(medfilt2(desired_img, [7 7]));
title("Median filter",'Interpreter','latex')
subplot(2,3,3)
imshow(imgaussfilt(desired_img,1.2));
title("Guassian filter",'Interpreter','latex')
subplot(2,3,4)
imshow(filtered_img12)
title("first : Median second : Guassian",'Interpreter','latex')
subplot(2,3,5)
imshow(filtered_img22)
title("first : Guassian second :  Median",'Interpreter','latex')
subplot(2,3,6)
imshow(wiener2(desired_img, [7, 7]))
title("Winner filter",'Interpreter','latex')

%% functions 
function [noise,noisy_img] = noise_generator(I,noise_type,noise_hyperparameter)
if noise_type == "gaussian"
    flag = 1 ;                  % guassian
    a1 = noise_hyperparameter(1) ;
    a2 = noise_hyperparameter(2) ;
elseif noise_type== "localvar"
    flag = 1 ;                  % localvar
    a1 = noise_hyperparameter(1) ;
    a2 = noise_hyperparameter(2) ;
else 
     flag = 2 ;                 % salt & peper,poisson , speckle
     b = noise_hyperparameter;
end
if flag == 1 
    noisy_img = imnoise(I,noise_type, a1, a2);
else
   noisy_img = imnoise(I,noise_type, b); 
end
noise = noisy_img - I;
end

