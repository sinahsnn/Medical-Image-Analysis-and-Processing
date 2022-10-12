clc; clear all ; close all  
img_path =  '..\pics\hand.jpg';  % image path 
image_1  = imread(img_path); clear img_path;
%% Part A 
image_n_1 = imnoise(image_1, "gaussian", 0.05, 0.01);
image_1 = image_1(:,:,1);
image_n_1 = image_n_1(:,:,1);
image_1 = double(image_1);
image_n_1 = double(image_n_1);
mont_array = reshape([image_1,image_n_1],[size(image_n_1),2]);
montage(uint8(mont_array))
title("Pure image   --------   Noisy image ")
SNR = 10 * log10(sum(image_1 .^ 2, "all") / sum((image_1 - image_n_1) .^2, "all"));
disp("SNR is equal to "+num2str(SNR))
%% Part B
%   Gaussian matrix with size of l*l and l must be odd
l = 5;
image_n_1_normalized = image_n_1/255;
one_side = (l+1)/2;
Gx = zeros(l);
hx = 1;
for i = 1:l
    for j = 1:l
        Gx(i, j) = exp(-((i-one_side)^2 + (j-one_side)^2) / (2*hx^2));
    end
end
Gx = Gx/sum(sum(Gx));
img_den_1 = conv2(1.0*image_n_1_normalized,Gx,'same')*255;
mont_array = reshape([image_n_1,img_den_1],[size(image_n_1),2]);
montage(uint8(mont_array))
title("Gaussian Filtering: Noisy image ----- Denoised image")
SNR1 = 10 * log10(sum(image_1 .^ 2, "all") / sum((image_1 - img_den_1) .^2, "all"));
disp("SNR is equal to "+num2str(SNR1))
%% Part C 
l = 7;
Gx = zeros(l);
image_n_1_normalized = image_n_1/255;
hx = 1.2;
for i = 1:l
    for j = 1:l
        Gx(i, j) = exp(-((i-(l+1)/2)^2 + (j-(l+1)/2)^2) / (2*hx^2));
    end
end
one_side = (l+1)/2;
Gx = Gx/sum(sum(Gx));
new_size = size(image_1)+(l-1);
img_extended = zeros(new_size);
img_extended(one_side:end-(one_side-1), one_side:end-(one_side-1)) = image_n_1_normalized;
hg = 0.8;
img_den_2 = zeros(size(image_1));
for i = 1:651
    for j = 1:719
        Gg = exp(-(img_extended(i:i+(l-1), j:j+(l-1)) - img_extended(i+(l-1)/2, j+(l-1)/2))^2 / (2*hg^2));
        G = Gg .* Gx;
        img_den_2(i, j) = round(255*(sum(img_extended(i:i+(l-1), j:j+(l-1)) .* G, "all") / sum(G, "all")));
    end
end
mont_array = reshape([image_n_1,img_den_2],[size(image_n_1),2]);
figure;
montage(uint8(mont_array))
title("Bilateral filtering : Noisy image    --------    Filtered image")
SNR2 = 10 * log10(sum(image_1 .^ 2, "all") / sum((image_1 - img_den_2) .^2, "all"));
disp("SNR is equal to "+num2str(SNR2))
%% part d 
%%%%%%% It takes time %%%%%%%%
%%%%%%%  !Be patient! %%%%%%%%
[N,M] = size(image_n_1);

l_s = 7; % squre of neighbourhood with size of l_s*l_s and l_s is odd
l_ones_side = floor(l_s/2);
n_s = 11; %neighbourhood searching with area of n_s*n_s
n_one_side = floor(n_s/2);
pad_req = n_one_side+l_ones_side; % Padding required
image_extended = padarray(image_n_1, [pad_req pad_req], 'replicate'); 
Gx = zeros(l_s);
for i = 1:l_s
    for j = 1:l_s
        Gx(i, j) = exp(-((i-(l_s+1)/2)^2 + (j-(l_s+1)/2)^2) / (l_s*l_s));
    end
end
Gx = Gx/sum(sum(Gx));
hv = 1000;
img_den_3 = zeros(size(image_1));
for i = 1:N
    for j = 1:M
        img_den_3(i,j) = NLM_filt(i+pad_req,j+pad_req,hv,image_extended,Gx,l_ones_side,n_one_side);
    end
end
mont_array = reshape([image_n_1,img_den_3,image_1],[size(image_n_1),3]);
figure;
montage(uint8(mont_array), 'Size', [1 3])
title("Noisy image ------ NLM_filtered image ----- Original image ")
SNR3 = 10 * log10(sum(image_1 .^ 2, "all") / sum((image_1 - img_den_3) .^2, "all"));
disp("SNR is equal to " + num2str(SNR3))
%% PART E 
img_path =  '..\pics\hand.jpg';  % image path 
image_1  = imread(img_path);
sigma=0.1225; window_size= 8; search_width= 8; 
l2= 0; selection_number = 8; l3= 2.7;
channel = 1;
img = padarray(image_1(1:4:end,1:4:end,channel),[search_width search_width], ...
    'symmetric','both');
noisy_image = image_n_1(1:4:end,1:4:end);
noisy_image(:,:,channel) = noisy_image;
basic_result(:,:,channel) = first_step(noisy_image, sigma, ...
    window_size, search_width, l2, l3, selection_number);
basic_padded = padarray(basic_result(:,:,channel), ...
    [search_width search_width],'symmetric','both');
final_result(:,:,channel) = second_step(noisy_image,basic_padded, ...
    sigma, window_size, search_width, l2, selection_number);
%% SNR
final_result1 = final_result(:,:);
figure;
subplot(133)
imshow(uint8(final_result1))
title("Denoised image  ")
subplot(132)
imshow(uint8(noisy_image))
title("Noisy image e ")
subplot(131)
imshow(uint8(img1))
title("Original image ")
img1=(padarray(final_result(:,:,channel), ...
    [search_width search_width],'symmetric','both'));

SNR4 = 10 * log10(sum(double(image_1(1:4:end,1:4:end,channel)) .^ 2, "all") / sum((double(image_1(1:4:end,1:4:end,channel)) - img1) .^2, "all"));
disp("SNR is equal to " + num2str(SNR4))
sgtitle("visuallization of original,noisy and denoised image")
%% Functions
function finalvalue = NLM_filt(pi,pj,sigma2,Im,mask,psh,nsh)
A = Im(pi-psh:pi+psh, pj-psh:pj+psh); 
normalising_factor = 0;
weighted_sum=0;
for i = pi-nsh:pi+nsh
    for j = pj-nsh:pj+nsh
        Iij = Im(i,j);
        B = Im(i-psh:i+psh,j-psh:j+psh); 
        B = A-B; 
        B = B.^2; 
        B = B.*mask; 
        wt = sum(B,'all'); 
        wt = exp(-wt/sigma2); 
        normalising_factor = normalising_factor + wt;
        weighted_sum = weighted_sum + wt*Iij;    
    end
end
finalvalue = weighted_sum/normalising_factor; 
finalvalue = round(finalvalue); 
end
%%%%
function basic_result = first_step(noisy_image, sigma, ws, sw, l2, l3, sn)
    image_size = size(noisy_image);
    numerator = zeros(size(noisy_image));
    denomerator = zeros(size(noisy_image));
    bpr = (sw*2+1) - ws + 1; % number of blocks per row/col
    center_block = bpr^2 / 2 + bpr/2 + 1;
    for i = sw+1:image_size(1)-sw
        for j = sw+1:image_size(2)-sw
            window = noisy_image(i-sw:i+sw , j-sw:j+sw);
            blocks = double(im2col(window, [ws ws], 'sliding'));
            dist = zeros(size(blocks,2),1);
            for k = 1:size(blocks,2)
                tmp = wthresh(blocks(:,center_block),'h',sigma*l2)- ...
                    wthresh(blocks(:,k),'h',sigma*l2);
                tmp = reshape(tmp, [ws ws]);
                tmp = norm(tmp,2)^2;
                dist(k) = tmp/(ws^2);
            end
            [~, inds] = sort(dist);
            inds = inds(1:sn);
            blocks = blocks(:, inds);
            p = zeros([ws ws sn]);
            for k = 1:sn
                p(:,:,k) = reshape(blocks(:,k), [ws ws]);
            end
            p = dct3(p);
            p = wthresh(p,'h',sigma*l3);
            wp = 1/sum(p(:)>0);
            p = dct3(p,'inverse');
            for k = 1:sn
                x = max(1,i-sw) + floor((center_block-1)/bpr);
                y = max(1,j-sw) + (mod(center_block-1,bpr));
                numerator(x:x+ws-1 , y:y+ws-1) = ...
                    numerator(x:x+ws-1 , y:y+ws-1) + (wp * p(:,:,k));
                denomerator(x:x+ws-1 , y:y+ws-1) = ...
                    denomerator(x:x+ws-1 , y:y+ws-1) + wp;
            end
        end
    end 
    basic_result = numerator./denomerator;
    basic_result = basic_result(sw+1:end-sw,sw+1:end-sw);
end
%%%%
function result = second_step(noisy_image, basic_res, sigma, ws,sw, l2, sn)
    image_size = size(noisy_image);
    numerator = zeros(size(noisy_image));
    denomerator = zeros(size(noisy_image));
    bpr = (sw*2+1) - ws + 1; % number of blocks per row/col
    center_block = bpr^2 / 2 + bpr/2 + 1;
    for i = sw+1:image_size(1)-sw
        for j = sw+1:image_size(2)-sw
            window  = noisy_image (i-sw:i+sw, j-sw:j+sw);
            window2 = basic_res(i-sw:i+sw, j-sw:j+sw);
            blocks  = double(im2col(window, [ws ws], 'sliding'));
            blocks2 = double(im2col(window2, [ws ws], 'sliding'));
            dist = zeros(size(blocks,2),1);
            for k = 1:size(blocks,2)
                tmp = wthresh(blocks2(:,center_block),'h',sigma*l2)- ...
                    wthresh(blocks2(:,k),'h',sigma*l2);
                tmp = reshape(tmp, [ws ws]);
                tmp = norm(tmp,2)^2;
                dist(k) = tmp/(ws^2);
            end
            [~, I] = sort(dist);
            I = I(1:sn);
            blocks = blocks(:, I);
            blocks2 = blocks2(:, I);
            p = zeros([ws ws sn]);
            basic_p = zeros([ws ws sn]);
            for k = 1:sn
                p(:,:,k) = reshape(blocks(:,k), [ws ws]);
                basic_p(:,:,k) = reshape(blocks2(:,k), [ws ws]);
            end
            basic_p = dct3(basic_p);
            wp = zeros(sn,1);
            for k = 1:sn
                tmp = basic_p(:,:,k);
                tmp = norm(tmp,1).^2;
                wp(k) = tmp/(tmp+(sigma^2));
            end
            p = dct3(p);
            for k = 1:sn
                p(:,:,k) = p(:,:,k)*wp(k);
            end
            p = dct3(p,'inverse');
            wp = 1/sum(wp(:).^2);
            for k = 1:sn
                q = p(:,:,k);
                x = max(1,i-sw) + floor((center_block-1)/bpr);
                y = max(1,j-sw) + (mod(center_block-1,bpr));
                numerator(x:x+ws-1 , y:y+ws-1) = ...
                    numerator(x:x+ws-1 , y:y+ws-1) + (wp * q);
                denomerator(x:x+ws-1 , y:y+ws-1) = ...
                    wp + denomerator(x:x+ws-1 , y:y+ws-1);
            end
        end
    end 
    result = numerator./denomerator;
    result = result(sw+1:end-sw,sw+1:end-sw);
end
%%%%%%%
function res = dct3(data, mode)
if(nargin > 2 && mode == 'inverse')
    res = idct(data,'dim',3);
    for i = 1:size(data,3)
        res(:,:,i)=idct2(res(:,:,i));
    end
else
    res=zeros(size(data));
    for i=1:size(data,2)
        res(:,:,i)=dct2(data(:,:,i));
    end
    dct(res,'dim',3);
end
end
