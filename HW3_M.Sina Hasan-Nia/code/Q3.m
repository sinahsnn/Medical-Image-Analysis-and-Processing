%----------------------------------------  Q3  ----------------------------
clc ; clear all ; close all ;
%% Part a
load("mainPhantom.mat")
load("noisyPhantom.mat")
figure()
subplot(121)
imshow(P)
title("Original Phantom",'Interpreter','latex','color','r')
subplot(122)
imshow(P_N)
title("Noisy Phantom",'Interpreter','latex','color','r')
sgtitle("Visuallization of original and noisy Image",'Interpreter','latex', ...
'color','b')
%% part b
img_den1 = TVL1denoise(P_N, 1, 100);
figure()
subplot(131)
imshow(P)
title("Original Phantom",'Interpreter','latex','color','r')
subplot(132)
imshow(P_N)
title("Noisy Phantom",'Interpreter','latex','color','r')
subplot(133)
imshow(img_den1)
title("denoised Phantom",'Interpreter','latex','color','r')
sgtitle("Visuallization of original and noisy and denoised Image(using TVL1denoise)",'Interpreter','latex', ...
'color','b')
%% part c
[epi,SNR]= measure_im(P, img_den1);