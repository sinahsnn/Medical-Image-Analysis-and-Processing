%% ------------------------       Q1      ---------------------------------
clc ; clear all ; close all 
img_path =  '..\pics\melanome1.jpg';  % image path 
melanome1 = imread(img_path); clear img_path;
img_path =  '..\pics\melanome2.jpg';  % image path 
melanome2 = imread(img_path); clear img_path;
img_path =  '..\pics\melanome3.jpg';  % image path 
melanome3 = imread(img_path); clear img_path;
img_path =  '..\pics\melanome4.jpg';  % image path 
melanome4 = imread(img_path); clear img_path;
thr = 0.25;
melanome1_Binary = ~im2bw(melanome1, thr);
melanome2_Binary = ~im2bw(melanome2, thr);
melanome3_Binary = ~im2bw(melanome3, thr);
melanome4_Binary = ~im2bw(melanome4, thr);
figure()
subplot(4,2,1)
imshow(melanome1)
title(" original melanome 1 ","FontSize", 10,"color",'r')
subplot(4,2,2)
imshow(melanome1_Binary)
title(" Binary melanome 1 ","FontSize", 10,"color",'r')
subplot(4,2,3)
imshow(melanome2)
title(" original melanome 2 ","FontSize", 10,"color",'r')
subplot(4,2,4)
imshow(melanome2_Binary)
title(" Binary melanome 2 ","FontSize", 10,"color",'r')
subplot(4,2,5)
imshow(melanome3)
title(" original melanome 3 ","FontSize", 10,"color",'r')
subplot(4,2,6)
imshow(melanome3_Binary)
title(" Binary melanome 3 ","FontSize", 10,"color",'r')
subplot(4,2,7)
imshow(melanome4)
title(" original melanome 4 ","FontSize", 10,"color",'r')
subplot(4,2,8)
imshow(melanome4_Binary)
title(" Binary melanome 4 ","FontSize", 10,"color",'r')
sgtitle("visuallization of Original & Binary images with threshold = 0.25","FontSize", 10,"color",'b')
%% Part A
structure_element_MIC = strel("square", 5);
melanome1_bin_1comp = imdilate(melanome1_Binary, structure_element_MIC);
structure_element_mic = strel("square", 3);
melanome1_bin_1comp = imerode(melanome1_bin_1comp, structure_element_mic);
figure;
subplot(2, 2, [1 2])
imshow(melanome1)
title("original image","FontSize", 10,"color",'r')
subplot(2, 2, 3)
imshow(melanome1_Binary)
title(" Original Binary Image ","FontSize", 10,"color",'r')
subplot(2, 2, 4)
imshow(melanome1_bin_1comp)
title("Enhanced Binary Image", "FontSize", 10,"color",'r')
sgtitle("Melanome 1","FontSize", 15,"color",'b')
%% Part B 
structure_element_mic = strel("square", 3);
melanome2_bin_den = imdilate (imerode(melanome2_Binary, structure_element_mic),structure_element_mic);
figure;
subplot(2, 2, [1 2])
imshow(melanome2)
title("original image","FontSize", 10,"color",'r')
subplot(2, 2, 3)
imshow(melanome2_Binary)
title(" Original Binary Image ","FontSize", 10,"color",'r')
subplot(2, 2, 4)
imshow(melanome2_bin_den)
title("Denoised Binary Image", "FontSize", 10,"color",'r')
sgtitle("Melanome 2","FontSize", 15,"color",'b')
%% Part C 
structure_element_MIC = strel("square", 5);
melanome3_bin_p = imclose(imdilate(melanome3_Binary, structure_element_MIC),structure_element_MIC);
melanome3_bin_p = imfill(melanome3_bin_p,"holes");
structure_element_mic = strel("square", 3);
melanome3_bin_p = imerode(melanome3_bin_p, structure_element_mic);
figure;
subplot(2, 2, [1 2])
imshow(melanome3)
title("original image","FontSize", 10,"color",'r')
subplot(2, 2, 3)
imshow(melanome3_Binary)
title(" Original Binary Image ","FontSize", 10,"color",'r')
subplot(2, 2, 4)
imshow(melanome3_bin_p)
title("Enhanced Binary Image", "FontSize", 10,"color",'r')
sgtitle("Melanome 3","FontSize", 15,"color",'b')
%% Part d 
structure_element1 = strel("square", 15);
structure_element2 = strel("square", 10);
structure_element3 = strel("square", 5);
structure_element4 = strel("square", 20);
melanome4_2c = imopen(melanome4_Binary, structure_element1);
melanome4_2c = imerode(melanome4_2c, structure_element2);
melanome4_2c = imdilate(melanome4_2c, structure_element3);
melanome4_2c = imopen(melanome4_2c, structure_element4);
figure;
subplot(2, 2, [1 2])
imshow(melanome4)
title("original image","FontSize", 10,"color",'r')
subplot(2, 2, 3)
imshow(melanome4_Binary)
title(" Original Binary Image ","FontSize", 10,"color",'r')
subplot(2, 2, 4)
imshow(melanome4_2c)
title("Enhanced Binary Image", "FontSize", 10,"color",'r')
sgtitle("Melanome 4","FontSize", 15,"color",'b')
%% Part e 
[ labelmat, n_connectedoObj] = bwlabeln(melanome4_2c);
obj1 = labelmat == 1;
obj2 = labelmat == 2;
figure;
subplot(1, 2, 1)
imshow(obj1)
title("1^{st} component", "FontSize", 10,"color",'r')
subplot(1, 2, 2)
imshow(obj2)
title("2^{nd} component", "FontSize", 10,"color",'r')
sgtitle("component number = " + num2str(n_connectedoObj),"FontSize", 15,"color",'b')


