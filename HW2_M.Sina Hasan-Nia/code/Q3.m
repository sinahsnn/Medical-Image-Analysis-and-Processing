clc ; clear all ; close all 
img_path =  '..\pics\boat.png';  % image path 
img = imread(img_path); clear img_path;
%% Part B 
low_mask_f = (1/(4*sqrt(2))) * [1+sqrt(3), 3+sqrt(3), 3-sqrt(3), 1-sqrt(3)];
high_mask_f = (1/(4*sqrt(2))) * [1-sqrt(3), -3+sqrt(3), 3+sqrt(3), -1-sqrt(3)];
[cA,cH,cV,cD] = dwt2(img,low_mask_f,high_mask_f);
figure()
subplot(3,2,[1,2])
imshow(img)
title("Original image","FontSize", 10,"color",'r')
subplot(3,2,3)
imagesc(cA)
colormap gray
title('Approximation Coefficients',"FontSize", 10,"color",'r')
subplot(3,2,4)
imagesc(cH)
colormap gray
title('Horizontal Detail Coefficients',"FontSize", 10,"color",'r')
subplot(3,2,5)
imagesc(cV)
colormap gray
title('Vertical Detail Coefficients',"FontSize", 10,"color",'r')
subplot(3,2,6)
imagesc(cD)
colormap gray
title('Diagonal Detail coefficients',"FontSize", 10,"color",'r')
%% Part C 
low_mask_B = (1/(4*sqrt(2))) * [3-sqrt(3), 3+sqrt(3), 1+sqrt(3), 1-sqrt(3)];
high_mask_B = (1/(4*sqrt(2))) * [1-sqrt(3), -1-sqrt(3), 3+sqrt(3), -3+sqrt(3)];
img_reconstructed = idwt2(cA,cH,cV,cD,low_mask_B,high_mask_B);
rmse = sqrt(mean((double(img) - (img_reconstructed)).^2, "all"));
figure()
subplot(1,2,1)
imshow(img)
title("original image","FontSize", 10,"color",'r')
subplot(1,2,2)
imshow(uint8(img_reconstructed))
title("Reconstructed image", "FontSize", 10,"color",'r')
sgtitle("Original & Reconstructed image with Reconstruction error = " + num2str(rmse))
%% Part D 
[C, S] = wavedec2(img, 1, low_mask_f, high_mask_f);
[C_sorted , I_sorted] = sort(C, "descend");
%% 95%  
p1 = 0.95;
n1 = floor(length(C)*p1);
thr1 = C_sorted(n1);
C_new1 = (C >= thr1) .* C;
imgR95 = waverec2(C_new1, S, low_mask_B, high_mask_B);
%% 95% 
percent =0.95; 
element_num = floor(length(C)*percent);
C_temp = [C_sorted(1:element_num) zeros(1,length(C_sorted)-element_num)];
C_new_rec(I_sorted) = C_temp;
Reconst_image95 = waverec2(C_new_rec, S, low_mask_B, high_mask_B);
%% 40%
percent =0.4; 
element_num = floor(length(C)*percent);
C_temp = [C_sorted(1:element_num) zeros(1,length(C_sorted)-element_num)];
C_new_rec(I_sorted) = C_temp;
Reconst_image40 = waverec2(C_new_rec, S, low_mask_B, high_mask_B);
%% 5%
percent =0.05; 
element_num = floor(length(C)*percent);
C_temp = [C_sorted(1:element_num) zeros(1,length(C_sorted)-element_num)];
C_new_rec(I_sorted) = C_temp;
Reconst_image5 = waverec2(C_new_rec, S, low_mask_B, high_mask_B);
%% RMSE for part D
RMSE95 = sqrt(mean((double(img) - (Reconst_image95)).^2, "all"))
RMSE40 = sqrt(mean((double(img) - (Reconst_image40)).^2, "all"))
RMSE5 = sqrt(mean((double(img) - (Reconst_image5)).^2, "all"))
%% visualization of Part D
figure;
subplot(221)
imshow(img)
title("original image","FontSize", 10,"color",'r')
subplot(222)
imshow(uint8(Reconst_image95))
title("percent = 95% with rmse = "+ num2str(RMSE95), "FontSize", 10 ,"color",'r')
subplot(223)
imshow(uint8(Reconst_image40))
title("percent = 40% with rmse = "+ num2str(RMSE40), "FontSize", 10 ,"color",'r')
subplot(224)
imshow(uint8(Reconst_image5))
title("percent = 5% with rmse = "+ num2str(RMSE5), "FontSize", 10 ,"color",'r')
sgtitle("Visuallization of Original & compressed images ","FontSize", 10,"color",'b')
%% Part E.1: calculate compression ratio using wavelet
imwrite(uint8(Reconst_image95), "..\recons\reconc95.png")
imwrite(uint8(Reconst_image40), "..\recons\reconc40.png")
imwrite(uint8(Reconst_image5), "..\recons\reconc5.png")
main_dir = dir("..\pics\boat.png");
main_size = main_dir.bytes;
reconc95_dir = dir("..\recons\reconc95.png");
Compress_Ratio95 = main_size / reconc95_dir.bytes;
reconc40_dir = dir("..\recons\reconc40.png");
Compress_Ratio40 = main_size / reconc40_dir.bytes;
reconc5_dir = dir("..\recons\reconc5.png");
Compress_Ratio5 = main_size /reconc5_dir.bytes;
%% Part E.2 : calculate compression ratio using FFT
FFTvec = reshape(fft2(img), 1, numel(fft2(img)));
FFT_vec_abs = abs(FFTvec);
[FFT_sorted, indx_sorted] = sort(FFT_vec_abs, "descend");
%% 95%
percent =0.95; 
element_num = floor(length(FFTvec)*percent);
FFTvec_temp = [FFT_sorted(1:element_num) zeros(1,length(FFT_sorted)-element_num)];
FFTvec_new_rec(indx_sorted) = FFTvec_temp;
FFT_B95 = reshape(FFTvec, size(fft2(img)));
Reconst_image_FFT95 = ifft2(FFT_B95);
%% 40 % 
percent =0.4; 
element_num = floor(length(FFTvec)*percent);
FFTvec_temp = [FFT_sorted(1:element_num) zeros(1,length(FFT_sorted)-element_num)];
FFTvec_new_rec(indx_sorted) = FFTvec_temp;
FFT_B40 = reshape(FFTvec, size(fft2(img)));
Reconst_image_FFT40 = ifft2(FFT_B40);
%% 5%
percent =0.05; 
element_num = floor(length(FFTvec)*percent);
FFTvec_temp = [FFT_sorted(1:element_num) zeros(1,length(FFT_sorted)-element_num)];
FFTvec_new_rec(indx_sorted) = FFTvec_temp;
FFT_B5 = reshape(FFTvec, size(fft2(img)));
Reconst_image_FFT5 = ifft2(FFT_B5);
%% RRMSE
RMSE95_FFT = sqrt(mean((double(img) - (Reconst_image_FFT95)).^2, "all"));
RMSE40_FFT = sqrt(mean((double(img) - (Reconst_image_FFT40)).^2, "all"));
RMSE5_FFT = sqrt(mean((double(img) - (Reconst_image_FFT5)).^2, "all"));
%% Visuallization for FFT
figure;
subplot(2,2,1)
imshow(img)
title("original image","FontSize", 10,"color",'r')
subplot(2,2,2)
imshow(uint8(Reconst_image_FFT95))
title("percent = 95% with rmse = "+ num2str(RMSE95_FFT), "FontSize", 10 ,"color",'r')
subplot(2,2,3)
imshow(uint8(Reconst_image_FFT40))
title("percent = 40% with rmse = "+ num2str(RMSE40_FFT), "FontSize", 10 ,"color",'r')
subplot(2,2,4)
imshow(uint8(Reconst_image_FFT5))
title("percent = 5% with rmse = "+ num2str(RMSE5_FFT), "FontSize", 10 ,"color",'r')
sgtitle("Visuallization of Original & compressed images using FFT ","FontSize", 10,"color",'b')
%% part E.3 :%% Part E.1: calculate compression ratio using FFT
imwrite(uint8(Reconst_image_FFT95), "..\recons\Reconst_image_FFT95.png")
imwrite(uint8(Reconst_image_FFT95), "..\recons\Reconst_image_FFT40.png")
imwrite(uint8(Reconst_image_FFT95), "..\recons\Reconst_image_FFT5.png")
main_dir = dir("..\pics\boat.png");
main_size = main_dir.bytes;
reconc95_dir = dir("..\recons\Reconst_image_FFT95.png");
Compress_Ratio95_FFT = main_size / reconc95_dir.bytes;
reconc40_dir = dir("..\recons\Reconst_image_FFT40.png");
Compress_Ratio40_FFT = main_size / reconc40_dir.bytes;
reconc5_dir = dir("..\recons\Reconst_image_FFT5.png");
Compress_Ratio5_FFT = main_size /reconc5_dir.bytes;
%% display compress ratio 
disp("Ratio        "+"FFT      "+ "  wavelet")
disp(" 95%     "+ num2str(Compress_Ratio95_FFT) + ":1"+"      "+num2str(Compress_Ratio95) + ":1" )
disp(" 40%     " + num2str(Compress_Ratio40_FFT) + ":1"+"      "+num2str(Compress_Ratio40) + ":1" )
disp(" 05%     " + num2str(Compress_Ratio5_FFT) + ":1"+"      "+num2str(Compress_Ratio5) + ":1" )







