%----------------------------------------  Q2  ----------------------------
clc ; clear all ; close all ;
%% 
P = phantom('Modified Shepp-Logan',700);
P_N =  imnoise(P,"salt & pepper",0.03); 
%save('noisyPhantom.mat','P_N')
figure()
subplot(121)
imshow(P)
title("Original Phantom",'Interpreter','latex','color','r')
subplot(122)
imshow(P_N)
title("Noisy Phantom",'Interpreter','latex','color','r')
sgtitle("Visuallization of original and noisy Image",'Interpreter','latex', ...
'color','b')
%% Part B
im = P_N;
niter = 10;
kappa = 50; 
lambda = 0.11;
option = 2;
diff = anisodiff(im, niter, kappa, lambda, option);
close all 
%plotting
figure()
subplot(131)
imshow(P)
title("Original Phantom",'Interpreter','latex','color','r')
subplot(132)
imshow(P_N)
title("Noisy Phantom",'Interpreter','latex','color','r')
subplot(133)
imshow(diff)
title("denoised Phantom",'Interpreter','latex','color','r')
sgtitle("Visuallization of original and noisy Image",'Interpreter','latex', ...
'color','b')

%% Part C 
[epi,SNR]= measure_im(P, diff);