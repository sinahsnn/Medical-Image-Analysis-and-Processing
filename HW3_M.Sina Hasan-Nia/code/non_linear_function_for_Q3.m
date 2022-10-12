clc ; close all ; clear all 
s =-1:0.1:100;
alpha = 0.5 ;
Q = alpha*s./(1+alpha*s);
figure()
plot(s,Q,'color','b','linewidth',1)
grid minor
hold on 
line([0,0],[-1,1],'color','r','linewidth',1,'linestyle','--')
hold on 
line([-20,105],[0,0],'color','r','linewidth',1,'linestyle','--')
hold on 
title('\phi(s)','interpreter','Tex')
xlabel('s','interpreter','Tex')
ylabel('\phi','interpreter','Tex')
