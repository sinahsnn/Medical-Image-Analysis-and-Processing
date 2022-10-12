function bw = chanvese(image, option)
figure; 
imshow(image)
if option == "boundary"
    disp("you've selected this option in order to select the mask by determining the boundary")
    mask = roipoly;
    close
    
elseif option == "center"
    disp("you've selected this option in order to select a 9*9 mask by determining the center of the mask ")
    [x,y] = ginput(1); %% enable us to identify point from the current axes and returns their x- and y-coordinates 
    close
    %%% create 9*9 mask
    c = [x-4, x+4, x+4, x-4];      
    r = [y+4, y+4, y-4, y-4];
    mask = roipoly(image,c,r);
end
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
suptitle("Visuallization of figures with '"+option+"' option")