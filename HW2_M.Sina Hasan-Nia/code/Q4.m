%% ------------------------       Q4      ---------------------------------
clc ; clear all ; close all 
img_path =  '..\pics\covid.png';  % image path 
img = imread(img_path); clear img_path;
img = img(:,:,1);
%% Part A
[cA,cH,cV,cD] = dwt2(img, "haar");
lamda_cH = median(abs(cH(:)))*sqrt(2*log(size(img,1)*size(img,2))) / 0.6745;
lamda_cV = median(abs(cV(:)))*sqrt(2*log(size(img,1)*size(img,2))) / 0.6745;
lamda_cD = median(abs(cD(:)))*sqrt(2*log(size(img,1)*size(img,2))) / 0.6745;
cH_rep = wthresh(cH, "s", lamda_cH);
cV_rep = wthresh(cV, "s", lamda_cV);
cD_rep = wthresh(cD, "s", lamda_cD);
figure()
sgtitle("Visuallization of Coefficients with out threshold","FontSize", 15,"color",'b')
subplot(221)
imagesc(cA)
colormap gray
title('Approximation ',"FontSize", 10,"color",'r')
subplot(2,2,2)
imagesc(cV)
colormap gray
title('Vertical',"FontSize", 10,"color",'r')
subplot(2,2,3)
imagesc(cH)
colormap gray
title('Horizontal',"FontSize", 10,"color",'r')
subplot(2,2,4)
imagesc(cD)
title('Diogonal ',"FontSize", 10,"color",'r')
figure()
sgtitle("Visuallization of Coefficients with threshold","FontSize", 15,"color",'b')
subplot(221)
imagesc(cA)
colormap gray
title('Approximation ',"FontSize", 10,"color",'r')
subplot(2,2,2)
imagesc(cV_rep)
colormap gray
title('Vertical',"FontSize", 10,"color",'r')
subplot(2,2,3)
imagesc(cH_rep)
colormap gray
title('Horizontal',"FontSize", 10,"color",'r')
subplot(2,2,4)
imagesc(cD_rep)
title('Diogonal ',"FontSize", 10,"color",'r')

%% Part B 
denoised_img = idwt2(cA, cH_rep, cV_rep, cD_rep, "haar");
figure();
subplot(2,1,1)
imshow(img)
title("Original","FontSize", 10,"color",'r')
subplot(2,1,2)
imshow(uint8(denoised_img))
title("Denoised ","FontSize", 10,"color",'r')
sgtitle("Visuallization of Original and Denoised images","FontSize", 15,"color",'b')
%% Part C 
FFTvec = reshape(fft2(img), 1, numel(fft2(img)));
FFT_vec_abs = abs(FFTvec);
[FFT_sorted, indx_sorted] = sort(FFT_vec_abs, "descend");
%%%%%%%95%
thr = 1e7; 
FFTvec_temp = FFT_sorted > thr;
FFTvec_new_rec(indx_sorted) = FFTvec_temp;
FFT_B = reshape(FFTvec, size(fft2(img)));
denoised_img2 = ifft2(FFT_B);
figure();
subplot(2,2,[1,2])
imshow(img)
title("Original","FontSize", 10,"color",'r')
subplot(2,2,3)
imshow(uint8(denoised_img))
title("Denoised using Wavelet ","FontSize", 10,"color",'r')
subplot(2,2,4)
imshow(uint8(denoised_img2))
title("Denoised using FFT ","FontSize", 10,"color",'r')
sgtitle("Visuallization of Original and Denoised images","FontSize", 15,"color",'b')
