function glcm = glcm_generator(img,NumQuantLevels)
A=double(img)+1;
Displacement = 1;  
glcm = zeros([NumQuantLevels,NumQuantLevels]); %PREALLOCATE GLCM MATRIX
% 
for i = 1:size(A,1)
    for j = 1 :size(A,2)-1
        glcm(A(i,j),A(i,j+1))=glcm(A(i,j),A(i,j+1))+1; %INCREMENT BY 1
    end
end