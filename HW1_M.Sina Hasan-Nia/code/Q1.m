%---------------------------  Q1  -----------------------------
close all ; clear all , clc;
image =  "..\pics\histogram.jpeg";  % image path 
img = imread(image);
%% Part a 
image_heq = histeq(img);
subplot(2, 2, 1);
imshow(img)
title('original image', 'Interpreter','latex','Color','blue');
subplot(2, 2, 2);
imhist(img);
title('original image histogram', 'Interpreter','latex','Color','red');
subplot(2, 2, 3);
imshow(image_heq)
title('image hisogram equalization', 'Interpreter','latex','Color','blue');
subplot(2, 2, 4);
imhist(image_heq);
title('image hisogram equalization hisogram', 'Interpreter','latex','Color','red');
sgtitle('Original Image (up) and Contrast Enhanced Image (down)','Interpreter','latex','Color','k')
%% Part b
figure();
subplot(2, 2, 1);
imshow(img)
title('original image', 'Interpreter','latex','Color','blue');
subplot(2, 2, 2);
myhist(img,64);
title('original image histogram', 'Interpreter','latex','Color','red');
subplot(2, 2, 3);
imshow(image_heq)
title('image hisogram equalization', 'Interpreter','latex','Color','blue');
subplot(2, 2, 4);
myhist(image_heq,64);
title('image hisogram equalization hisogram', 'Interpreter','latex','Color','red');
sgtitle('Histograms using myimhist', 'interpreter', 'latex')
%% Part C 
img_clahe = zeros(size(img), 'uint8');
for i = 1:3
    img_clahe(:, :, i) = adapthisteq(img(:, :, i));
end
figure();
subplot(2, 2, 1);
imshow(img)
title('original image', 'Interpreter','latex','Color','blue');
subplot(2, 2, 2);
imhist(img);
title('original image histogram', 'Interpreter','latex','Color','red');
subplot(2, 2, 3);
imshow(img_clahe)
title('image CLAHE', 'Interpreter','latex','Color','blue');
subplot(2, 2, 4);
imhist(img_clahe);
title('image CLAHE histogram', 'Interpreter','latex','Color','red');
sgtitle('Original Image (up) and Developed Contrast Enhanced Image (down)','Interpreter','latex','Color','k')
%% part D 
figure();
subplot(3, 1, 1);
imhist(img);
title('original image histogram', 'Interpreter','latex');
subplot(3, 1, 2);
imhist(image_heq);
title('image hisogram equalization hisogram', 'Interpreter','latex');
subplot(3,1, 3);
imhist(img_clahe);
title('image CLAHE histogram', 'Interpreter','latex');
%% functions 
function myhist(image,nbins)
cnt = zeros(1, 256);
for i = 1:numel(image)
    cnt(image(i)+1) = cnt(image(i)+1) + 1;
end
histogram = zeros(1,nbins);
interv_len = 256 /nbins;
for i = 1 :256
    idx = floor((i-1)/interv_len);
    histogram(idx+1) = histogram(idx+1)+cnt(i);
end
stem(cnt,'marker','none')
colorbar("southoutside");caxis([0 255]);colormap("gray");xlim([0 255]);
end



