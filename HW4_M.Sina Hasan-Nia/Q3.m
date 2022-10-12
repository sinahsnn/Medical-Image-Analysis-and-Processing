%-------------------------------  Q3  -------------------------------------
clc ; clear all ; close all ;
path = 'C:\Users\Sun Media\Desktop\MIAP\HW\HW4_M.Sina Hasan-Nia_96108515\pics\';
nevus = imread([path,'nevus_gray.jpg']);
melanoma = imread([path,'melanoma_gray.jpg']);
%% Part A
bw_bn1 = chanvese(nevus, "boundary");
BW_cen1 = chanvese(nevus, "center");
bw_bn2 = chanvese(melanoma, "boundary");
BW_cen2 = chanvese(melanoma, "center");
%% Part B.1
image = imread([path,'MRI3.png']);
bw_bn3 = chanvese(image, "boundary");
BW_cen3 = chanvese(image, "center");
%% Part B.2
thresh = multithresh(image, 4);
mask = image >= thresh(4);
bw  = activecontour(image, mask);
bw_show = double(bw);
bw_show(bw_show == 1) = 255;
figure()
subplot(1,3,1)
imshow(image)
title("Original image")
subplot(1,3,2)
imshow(uint8(bw_show))
title("Binary mask")
subplot(1,3,3)
imshow(uint8(bw .* double(image)))
title("selected")
suptitle("Visuallization of figures(automatic mode) " )