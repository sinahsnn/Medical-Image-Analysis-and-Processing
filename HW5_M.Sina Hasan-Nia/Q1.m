%----------------------------------  Q1  ----------------------------------
clc; clear all ; close all ;
cd BCFCM\
Y = (imread("test_biasfield_noise.png"));
Y = im2double(Y);
options = struct('alpha', 2, 'maxit', 20, 'epsilon', 1e-5);
v = [0.42;0.56;0.64];
[B,U]=BCFCM2D(Y, v, options);
figure()
subplot(2,2,1)
imshow(Y), title('input image');
subplot(2,2,2)
imshow(U)
title('Partition matrix');
subplot(2,2,3)
imshow(B,[])
title('Estimated biasfield');
subplot(2,2,4)
imshow(Y-B), title('Corrected');
cd ..
