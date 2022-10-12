%% ------------------------       Q2      ---------------------------------
clc ; clear all ; close all 
img_path =  '..\pics\brain.jpg';  % image path 
brain = imread(img_path); clear img_path;
img_path =  '..\pics\sample.png';  % image path 
sample = imread(img_path); clear img_path;
figure()
subplot(1,2,1)
imshow(brain)
title("brain","color",'r')
subplot(1,2,2)
imshow(sample)
title("sample","color",'r')
sgtitle("Visuallization of images","color",'b')
%% Part a
%%% Visuallization of Normalized Histogram
figure()
histogram(brain, "NumBins", 256, "Normalization","probability")
title("Normalized Histogram","FontSize", 10,"color",'r')
ylabel("Prob")
xlabel("x")
grid minor
%%% calculating mean,Varian,uniformity,entropy
[counts,binLocations] = imhist(brain);
probability = counts /(size(brain,1)*size(brain,2));
mean_brain = sum(binLocations.*probability); 
Variance_brain = sum((binLocations.^2).*probability)-mean_brain^2;
uniformity_brain = sum(probability.^2); 
Entropy_brain = -sum(probability(probability~=0) .* log2(probability(probability~=0))); 
disp("Fig Name     "+"mean      "+ "  Variance    "+" uniformity    "+"Entropy")
disp(" Brain     "+ num2str(mean_brain) +"      "+num2str(Variance_brain) + "      "+num2str(uniformity_brain) +"      "+num2str(Entropy_brain)  )
%% part b
figure()
histogram(sample, "NumBins", 256, "Normalization","probability")
title("Normalized Histogram","FontSize", 10,"color",'r')
ylabel("Prob")
xlabel("x")
grid minor
%%% calculating mean,Varian,uniformity,entropy
[counts,binLocations] = imhist(sample);
probability = counts /(size(sample,1)*size(sample,2));
mean_sample = sum(binLocations.*probability); 
Variance_sample = sum((binLocations.^2).*probability)-mean_sample^2;
uniformity_sample = sum(probability.^2); 
Entropy_sample = -sum(probability(probability~=0) .* log2(probability(probability~=0))); 
disp("Fig Name     "+"mean      "+ "  Variance    "+" uniformity    "+"Entropy")
disp(" Brain     "+ num2str(mean_brain) +"      "+num2str(Variance_brain) + ...
    "      "+num2str(uniformity_brain) +"      "+num2str(Entropy_brain)  )
disp(" sample    "+ num2str(mean_sample) +"      "+num2str(Variance_sample) + ...
    "      "+num2str(uniformity_sample) +"      "+num2str(Entropy_sample)  )
%% part c 
glcm_brain1 = glcm_generator(brain,256);
glcm_sample1 = glcm_generator(sample,256);
glcm_brain = graycomatrix(brain, "NumLevels", 256); 
glcm_sample = graycomatrix(sample, "NumLevels", 256);
%% part d 
%%% Brain
glcm_brain_N = glcm_brain / sum(glcm_brain,"all");
%%%% Contrast
Cont_Brain = 0;
len = size(glcm_brain_N,1);
for i=1:len
    for j=1:len
       Cont_Brain = Cont_Brain+( glcm_brain_N(i,j) * (i - j) ^ 2) ;
    end
end
%%%% Uniformity
UNi_Brain = sum(glcm_brain_N.*glcm_brain_N,"all");
%%%% Homoginity
Hmg_Brain = 0 ; 
for i=1:len
    for j=1:len
       Hmg_Brain = Hmg_Brain +  glcm_brain_N(i,j)/(1 + abs(i-j));
    end
end
%%%% ENT
ENT_Brain =  -sum(glcm_brain_N(glcm_brain_N~=0).*log2(glcm_brain_N(glcm_brain_N~=0)), "all");
%%% sample
glcm_sample_N = glcm_sample / sum(glcm_sample,"all");
%%%% Contrast
Cont_sample = 0;
len = size(glcm_sample_N,1);
for i=1:len
    for j=1:len
       Cont_sample = Cont_sample +( glcm_sample_N(i,j) * (i - j) ^ 2) ;
    end
end
%%%% Uniformity
UNi_sample = sum(glcm_sample_N.*glcm_sample_N,"all");
%%%% Homoginity
Hmg_sample = 0 ; 
for i=1:len
    for j=1:len
       Hmg_sample = Hmg_sample +  glcm_sample_N(i,j)/(1 + abs(i-j));
    end
end
%%%% ENT
ENT_sample =  -sum(glcm_sample_N(glcm_sample_N~=0).*log2(glcm_sample_N(glcm_sample_N~=0)), "all");
%%%%
disp("Fig Name     "+"contrast    "+ "uniformity    "+"Homoginity    "+"Entropy")
disp(" Brain_f     "+ num2str(Cont_Brain) +"      "+num2str(UNi_Brain) + ...
    "      "+num2str(Hmg_Brain) +"      "+num2str(ENT_Brain)  )
disp("sample_f      "+ num2str(Cont_sample) +"        "+num2str(UNi_sample) + ...
    "      "+num2str(Hmg_sample) +"        "+num2str(ENT_sample)  )
%% part e 
thr = 0:4:252-4;
values = [thr, max(brain(:))];
brain_quant = imquantize(brain, thr);
sample_quant = imquantize(sample, thr);
brain_q = values(brain_quant);
sample_q = values(sample_quant);
glcm_brain_q = graycomatrix(brain_q, "NumLevels", 64); 
glcm_sample_q = graycomatrix(sample_q, "NumLevels", 64);
%%% Brain
glcm_brain_N_q = glcm_brain_q / sum(glcm_brain_q,"all");
%%%% Contrast
Cont_Brain_q = 0;
len = size(glcm_brain_N_q,1);
for i=1:len
    for j=1:len
       Cont_Brain_q = Cont_Brain_q+( glcm_brain_N_q(i,j) * (i - j) ^ 2) ;
    end
end
%%%% Uniformity
UNi_Brain_q = sum(glcm_brain_N_q.*glcm_brain_N_q,"all");
%%%% Homoginity
Hmg_Brain_q = 0 ; 
for i=1:len
    for j=1:len
       Hmg_Brain_q = Hmg_Brain_q +  glcm_brain_N_q(i,j)/(1 + abs(i-j));
    end
end
%%%% ENT
ENT_Brain_q =  -sum(glcm_brain_N_q(glcm_brain_N_q~=0).*log2(glcm_brain_N_q(glcm_brain_N_q~=0)), "all");
%%% sample
glcm_sample_N_q = glcm_sample / sum(glcm_sample,"all");
%%%% Contrast
Cont_sample_q = 0;
len = size(glcm_sample_N_q,1);
for i=1:len
    for j=1:len
       Cont_sample_q = Cont_sample_q +( glcm_sample_N_q(i,j) * (i - j) ^ 2) ;
    end
end
%%%% Uniformity
UNi_sample_q = sum(glcm_sample_N_q.*glcm_sample_N_q,"all");
%%%% Homoginity
Hmg_sample_q = 0 ; 
for i=1:len
    for j=1:len
       Hmg_sample_q = Hmg_sample_q +  glcm_sample_N_q(i,j)/(1 + abs(i-j));
    end
end
%%%% ENT
ENT_sample_q =  -sum(glcm_sample_N_q(glcm_sample_N_q~=0).*log2(glcm_sample_N_q(glcm_sample_N_q~=0)), "all");
%%%%
disp(" Fig Name     "+" contrast    "+ " uniformity    "+"Homoginity    "+" Entropy")
disp("Brain_f_q       "+ num2str(Cont_Brain_q) +"       "+num2str(UNi_Brain_q) + ...
    "      "+num2str(Hmg_Brain_q) +"       "+num2str(ENT_Brain_q)  )
disp("sample_f_q      "+ num2str(Cont_sample_q) +"        "+num2str(UNi_sample_q) + ...
    "      "+num2str(Hmg_sample_q) +"        "+num2str(ENT_sample_q)  )


