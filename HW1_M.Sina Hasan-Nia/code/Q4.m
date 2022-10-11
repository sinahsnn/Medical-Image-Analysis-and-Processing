%---------------------------  Q4  -----------------------------
close all ; clear all , clc;
impath_hand =  "..\pics\hand.jpg";  % image path
impath_foot =  "..\pics\foot.jpg";  % image path 
img_hand = imread(impath_hand);
img_foot = imread(impath_foot);
img_hand=img_hand(:,:,1);
img_foot=img_foot(:,:,1);
%% Part A
img_hand_W = fftshift(fft2(img_hand));
img_foot_W = fftshift(fft2(img_foot));
figure();
subplot(2, 3, 1)
imshow(img_hand)
title('Hand', 'Interpreter','latex')
subplot(2, 3, 2)
imshow(abs(fft2(img_hand)),[])
title('Hand Fourier Transform', 'Interpreter','latex')
subplot(2, 3, 3)
imshow(abs(img_hand_W), [])
title('Centerd Hand Fourier Transform using fftshift', 'Interpreter','latex')
subplot(2, 3, 4)
imshow(img_foot)
title('Foot', 'Interpreter','latex')
subplot(2, 3, 5)
imshow(abs(fft2(img_foot)),[])
title('Foot Fourier Transform', 'Interpreter','latex')
subplot(2, 3, 6)
imshow(abs(img_foot_W), [])
title('Centered Foot Fourier Transform using fftshift', 'Interpreter','latex')
sgtitle("Visuallization of Fourier Transforms")
%% Part B 
imhand_coen = 255 / max(log(abs(img_hand_W(:)) + 1));
imfoot_coen = 255 / max(log(abs(img_foot_W(:)) + 1));
figure();
subplot(2, 3, 1)
imshow(img_hand)
title('Hand', 'Interpreter','latex')
subplot(2, 3, 2)
imshow(abs(img_hand_W), [])
title('Hand Fourier Transform(Common form)', 'Interpreter','latex')
subplot(2, 3, 3)
imshow(imhand_coen*log(abs(img_hand_W) + 1), [])
title('Hand Fourier Transform(Using Log)', 'Interpreter','latex')
subplot(2, 3, 4)
imshow(img_foot)
title('Foot', 'Interpreter','latex')
subplot(2, 3, 5)
imshow(abs(img_foot_W), [])
title('Foot Fourier Transform(common form)', 'Interpreter','latex')
subplot(2, 3, 6)
imshow(imfoot_coen*log(abs(img_foot_W) + 1), [])
title('Foot Fourier Transform(Using Log)', 'Interpreter','latex')
sgtitle("Visuallization of Different Fourier Transforms")
%% Part C
img_hand_W= fft2(img_hand);
img_foot_W = fft2(img_foot);
img_hand_W_amp =  abs(img_hand_W);
img_hand_W_phase = angle(img_hand_W);
img_foot_W_amp = abs(img_foot_W);
img_foot_W_phase = angle(img_foot_W);
%reconstruct the Image ( Amp : hand Phase: Foot)
recons_img_AHPF = ifft2(img_hand_W_amp .* exp(1i*img_foot_W_phase));
%reconstruct the Image ( Amp : Foot Phase: Hand)
recons_img_AFPH = ifft2(img_foot_W_amp .* exp(1i*img_hand_W_phase));
figure();
subplot(1,2,1)
imshow(uint8(recons_img_AHPF))
title("Amp : hand Phase: Foot",'Interpreter','latex')
subplot(1,2,2)
imshow(uint8(recons_img_AFPH))
title("Amp : Foot Phase: Hand",'Interpreter','latex')
sgtitle("Reconstructed Images",'Interpreter','latex')

