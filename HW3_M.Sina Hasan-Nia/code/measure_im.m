function [epi,SNR] = measure_im(org, den)
%% EPI
den1 = den;
H = fspecial('laplacian',0.2) ;
deltas=imfilter(org,H);
deltas_m=mean2(deltas);
deltascap=imfilter(den,H);
deltacap_m=mean2(deltascap);
p1=deltas-deltas_m;
p2=deltascap-deltacap_m;
num=sum(sum(p1.*p2));
den=(sum(sum(p1.^2))).*(sum(sum(p2.^2)));
epi= mean(num./sqrt(den));
%%%% SNR
SNR = 10 * log10(sum(org .^ 2, "all") / sum((org - den1) .^2, "all"));
disp(['EPI error = ' num2str(epi)]);
disp(['SNR = ' num2str(SNR)]);

