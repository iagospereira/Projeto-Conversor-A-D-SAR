function [] = a_espectral(vin,vout,fs)

%clear all;clc;
% Usado para teste
% w = 1000;  %frequência em Hertz
% a = 2;      %amplitude
% fs = 20*w;
% t = 0:(1/fs):0.1;
% vin = a*sin(2*pi*w*t);
% plot(t,vin);
%% Plotando o espectro de Vin
vin_f = fftshift(fft(vin));
[vin_fase,vin_mag] = cart2pol(real(vin_f),imag(vin_f));
f = linspace(-fs/2,fs/2,length(vin_mag));
vin_mag = log10(vin_mag);
figure;
plot(f,vin_mag);
title(['Análise espectral da tensão de entrada']);
xlabel(['Frequência (Hz)']);
ylabel(['Magnitude (dB)']);
grid on;
%% Plotando o espectro de Vout
vout_f = fftshift(fft(vout));
[vout_fase,vout_mag] = cart2pol(real(vout_f),imag(vout_f));
f = linspace(-fs/2,fs/2,length(vout_mag));
vout_mag = log10(vout_mag);
figure;
plot(f,vout_mag);
title(['Análise espectral da tensão de saída']);
xlabel(['Frequência (Hz)']);
ylabel(['Magnitude (dB)']);
grid on;
