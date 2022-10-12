function [pdf1, pdf2, pdf3, pdf4] = GLDM(inImg, d)
s=size(inImg);
inImg=double(inImg);
%matrices
pro1=zeros(s);
pro2=zeros(s);
pro3=zeros(s);
pro4=zeros(s);
for i=1:s(1)
    for j=1:s(2)
        if((j+d)<=s(2))
            pro1(i,j)=abs(inImg(i,j)-inImg(i,(j+d)));
        end
        if((i-d)>0)&((j+d)<=s(2))
            pro2(i,j)=abs(inImg(i,j)-inImg((i-d),(j+d)));
        end
        if((i+d)<=s(1))
            pro3(i,j)=abs(inImg(i,j)-inImg((i+d),j));
        end
        if((i-d)>0)&((j-d)>0)
            pro4(i,j)=abs(inImg(i,j)-inImg((i-d),(j-d)));
        end
    end
end
%probability density functions
pdf1=zeros(256,1);
pdf2=zeros(256,1);
pdf3=zeros(256,1);
pdf4=zeros(256,1);
[cnt x]=imhist(uint8(pro1));
pdf1 = cumsum(cnt);
[cnt x]=imhist(uint8(pro2));
pdf2 = cumsum(cnt);
[cnt x]=imhist(uint8(pro3));
pdf3 = cumsum(cnt);
[cnt x]=imhist(uint8(pro4));
pdf4 = cumsum(cnt);
