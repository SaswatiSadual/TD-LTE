clear all
close all
clc

addpath ./SCME-2006-08-30/
scmpar = scmparset;
linkpar = linkparset;
antpar = antparset;

scmpar.NumBsElements = 4;
scmpar.NumMsElements = 2;

[h tau] = scm(scmpar,linkpar,antpar);
N_AT_BS = scmpar.NumBsElements;
N_AT_MS = scmpar.NumMsElements;
N_D = size(h,3);
N_Sample = size(h,4);

f_c = scmpar.CenterFrequency;
BandWidth = 20e6;
N_SC = 1024;
f_SC = ((1:N_SC) - 0.5 - N_SC/2)*BandWidth/N_SC + f_c;

for i = 1:N_AT_MS
    for j = 1:N_AT_BS
        for k = 1:N_Sample
            H1(i,j,:,k) = exp(2*pi*1i*f_SC'*tau)*squeeze(h(i,j,:,k));
        end
    end
end

[h tau] = scm(scmpar,linkpar,antpar);

for i = 1:N_AT_MS
    for j = 1:N_AT_BS
        for k = 1:N_Sample
            h_tmp = zeros(N_SC,N_Sample);
            h_tmp(round(tau*BandWidth)+1,:) = h(i,j,:,:);
            H_tmp(i,j,:,:) = fft(h_tmp);
            H_tmp2(i,j,:,k) = exp(2*pi*1i*f_SC'*tau)*squeeze(h(i,j,:,k));
        end
    end
end

p_rank = zeros(N_AT_BS,1);

for i = 1:N_SC
    for j = 1:N_Sample
        H = [H1(:,:,i,j);H2(:,:,i,j)];
        RI = rank(H);
        p_rank(RI) = p_rank(RI) + 1;
    end
end
p_rank = p_rank/N_SC/N_Sample;