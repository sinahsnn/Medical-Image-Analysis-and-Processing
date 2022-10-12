%-------------------------------  Q1  -------------------------------------
clc ; clear all ; close all ;
path = 'C:\Users\Sun Media\Desktop\MIAP\HW\HW4_M.Sina Hasan-Nia_96108515\pics\';
%% Part 1
Mri1 = imread([path,'MRI1.png']);
Mri2 = imread([path,'MRI2.png']);
Mri3 = imread([path,'MRI3.png']);
Mri4 = imread([path,'MRI4.png']);
Img(:,:,1) = Mri1;
Img(:,:,2) = Mri2;
Img(:,:,3) = Mri3;
Img(:,:,4) = Mri4;
figure()
subplot(2,2,1);
imshow(Img(:,:,1:3));
title(' features 1,2,3');
subplot(2,2,2);
imshow(Img(:,:,2:4));
title(' features 2,3,4');
subplot(2,2,3);
imshow(Img(:,:,[1,3,4]));
title(' features 1,3,4');
subplot(2,2,4);
imshow(Img(:,:,[1,2,4]));
title(' features 1,2,4');
suptitle('3D feature image');
figure()
imshow(Img(:,:,1:3));
title(' features 1,2,3');
%% Part B
cluster_numbers =4;
data = reshape(Img, [], 4);
data = im2double(data);
q = 2;
[~, U] = fcm(data, cluster_numbers, q);
prob = reshape(U,cluster_numbers,200,256);
map = permute(prob, [2 3 1]); % to correct dimensions

a = zeros(200,256*cluster_numbers);
for i = 1:cluster_numbers
    a(:,(i-1)*256+1:i*256) = map(:,:,i);
end
figure()
imshow(a);
title([' FCM clustering when q = ', num2str(q)]);
%% Part C 
data = reshape(Img, [], 4);
data = double(data);
cluster_numbers = 4;
[U, c] = kmeans(data, cluster_numbers);
index = reshape(U, 200,256);
initial = zeros(200,256,cluster_numbers);
for i = 1:200
    for j = 1:256
        initial(i,j,index(i,j)) = 1;
    end
end

a = zeros(200,256*cluster_numbers);
for i = 1:cluster_numbers
    a(:,(i-1)*256+1:i*256) = initial(:,:,i);
end
figure()
imshow(a);
title("k means output for number of clusters = "+ num2str(cluster_numbers));
%% Part C
cluster_numbers = 4 ;
q = 1.1;
[~, U2] = fcm_matlab(data, cluster_numbers, q,c);

a = zeros(200,256*cluster_numbers);
for i = 1:cluster_numbers
    temp = U2(:,:,i);
    temp = (temp- min(min(temp)))./(max(max(temp))- min(min(temp)));
    a(:,(i-1)*256+1:i*256) =temp ;
    
end
figure()
imshow(a);
title(['segmentation output when q = ' num2str(q)]);
%% Part D 
%%% GMM
cluster_numbers = 4 ;
data = reshape(Img, [], 4);
data = im2double(data);
q = 5 ;
[~, U] = fcm(data, cluster_numbers, q);

[~,class] = max(U);

a1 = data(class==1,:);
a2 = data(class == 2,:);
a3 = data(class == 3,:);
a4 = data(class == 4,:);


mu1 = mean(a1);
mu2 = mean(a2);
mu3 = mean(a3);
mu4 = mean(a4);

         
cov1 = cov(a1);
cov2 = cov(a2);
cov3 = cov(a3);
cov4 = cov(a4);


gm1 = gmdistribution(mu1,cov1);
gm2 = gmdistribution(mu2,cov2);
gm3 = gmdistribution(mu3,cov3);
gm4 = gmdistribution(mu4,cov4);


map1 = zeros(200,256);
map2 = zeros(200,256);
map3 = zeros(200,256);
map4 = zeros(200,256);


for i= 1:200
    for j = 1:256
        temp = Img(i,j,:);
        temp = reshape(temp,4,1);
        temp = im2double(temp);
        
        map1(i,j) = pdf(gm1,temp');
        map2(i,j) = pdf(gm2,temp');
        map3(i,j) = pdf(gm3,temp');
        map4(i,j) = pdf(gm4,temp');
    end
end
P_x = map1+map2+map3+map4;
feature_map_1 = map1./P_x;
feature_map_2 = map2./P_x;
feature_map_3 = map3./P_x;
feature_map_4 = map4./P_x;

figure()
subplot(1,4,1)
imshow(feature_map_1);
subplot(1,4,2)
imshow(feature_map_2);
subplot(1,4,3)
imshow(feature_map_3);
subplot(1,4,4)
imshow(feature_map_4);
suptitle(['output with GMM method when q = ', num2str(q)]);
%% second method 
P_x = map1+map2+map3+map4;
feature_map_1 = (sum(class == 1)/length(class))*map1./P_x;
feature_map_2 =(sum(class == 2)/length(class))* map2./P_x;
feature_map_3 = (sum(class == 3)/length(class))*map3./P_x;
feature_map_4 = (sum(class == 4)/length(class))*map4./P_x;
feature_map_1 = ((feature_map_1 - min(min(feature_map_1)))/(max(max(feature_map_1)) - min(min(feature_map_1))));
feature_map_2 = ((feature_map_2 - min(min(feature_map_2)))/(max(max(feature_map_2)) - min(min(feature_map_2))));
feature_map_3 = ((feature_map_3 - min(min(feature_map_3)))/(max(max(feature_map_3)) - min(min(feature_map_3))));
feature_map_4 = ((feature_map_4 - min(min(feature_map_4)))/(max(max(feature_map_4)) - min(min(feature_map_4))));

figure()
subplot(1,4,1)
imshow(feature_map_1);
subplot(1,4,2)
imshow(feature_map_2);
subplot(1,4,3)
imshow(feature_map_3);
subplot(1,4,4)
imshow(feature_map_4);
suptitle(['output with GMM method when q = ', num2str(q)]);

%% PVE
cluster_numbers =4;
data = reshape(Img, [], 4);
data = im2double(data);
q = 5;
[centers, U] = fcm(data, cluster_numbers, q);
prob = reshape(U, cluster_numbers, 200,256);
map = permute(prob, [2 3 1]);

pve_map = zeros(200,256);
for i = 1:200
    for j = 1:256
        prob_vec = map(i,j,:);
        prob_vec = sort(prob_vec);
        temp = prob_vec(end)/prob_vec(end-1);
        if temp < 1.07
            pve_map(i,j) = 1;
        end
    end
end

figure()
imshow(pve_map)
title(['PVE map when q = ',num2str(q)]);
%% 