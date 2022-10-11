%---------------------------  Q5  -----------------------------
close all ; clear all , clc;
num_images = 6 ;         % image numbers in directory
dir = "..\pics\river\";                               % directory of images
PC_numvec = [20,50,80,100,150];          % each element corresponds to spece
for i = 1 : num_images
    img_path = dir + "river"+num2str(i)+".png";
    imgpca(img_path,PC_numvec,length(PC_numvec),i)
end

function imgpca(image_path, PC_num,len,sts)
image = double(rgb2gray(imread(image_path)));
[PC_coeff, PC_score, PC_var] = pca((image-mean(image, 2))');
B = diag(PC_var)^(-1/2) * PC_coeff';
z = diag(PC_var)^(-1/2) * PC_score';
figure();
for i = 1 :len
reconstructed_image = pinv(B(1:PC_num(i), :)) * z(1:PC_num(i), :) + mean(image, 2);
subplot(len, 3, i*3-2)
imshow(uint8(image))
title('Original image', 'Interpreter','latex')
subplot(len, 3, i*3-1)
imshow(uint8(PC_score))
title('whitened image', 'Interpreter','latex')
subplot(len, 3, i*3)
imshow(uint8(reconstructed_image))
title("Compressed Image "+num2str(sts)+" with "+num2str(PC_num(i))+ " Component", 'Interpreter','latex')
end
sgtitle('Principal Component Analysis', 'Interpreter','latex')
end