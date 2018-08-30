% Conversor A/D SAR single-ended
% 11/03/2018
% TCC 2
% Universidade de Brasília
% Autor: Iago Sergio Pinheiro Pereira
% Matrícula: 11/0148959
% versão 0.7
% 
clear all;
clc;

%% Variáveis do modelo
n_bits = 12; % número de bits do conversor
Vref = 1;  % Tensão de referência
Vcm = 1;    % Tensão de modo comum
Voff = 0*(Vref/(2^n_bits)); % Tensão de offset, em função de LSB, na saída
sinal = 2; % Sinal de entrada: 1=rampa, 2=senoide

%% Sinal de entrada
switch sinal
    case 1
        tmax = 1;   % tempo do processo inteiro em segundos
        sp = 10000; % número de amostras
        fs = sp/tmax; %taxa de amostragem
        t = 0:(1/fs):(tmax-(1/fs));
        Vin = t;
    case 2
        tmax = 1;   % tempo do processo inteiro em segundos
        sp = 20000; % número de amostras
        fs = sp/tmax; %taxa de amostragem
        t = 0:(1/fs):(tmax-(1/fs));
        f = fs/30;
        Vin = (Vref/2) + (Vref/2)*cos(2*pi*f*t);
end;

%% Array de capacitores
C = 15e-15;  % Capacitância unitária
C_cte = 3;  % Capacitor da Tecnologia: cmm=1 , cdmm=2 ,ctmm=3
AC = 0.0023;  % Capacitor da tecnologia: cmm=0.004 , cdmm=0.0028 , ctmm =0.0023
C_mismatch = 1; % 0 = sem mismatch, 1 = mismatch gaussiano, 2 = mismatch fixo
C_misfixo = 0.1*C; % mismatch fixo

switch C_mismatch
    case 0  %sem mismatch
        for i=1:n_bits
            C_ar(i) = C*(2^(n_bits-i));
        end;
        C_ar(n_bits+1) = C; %dummy
    case 1  %com mismatch gaussiano
        WL = (C/C_cte)*1e15;   % Área do capacitor
        C_mis_sig = AC/sqrt(WL); % desvio padrão
        for i=1:n_bits
            C_ar(i) = C*(normrnd(1,C_mis_sig))*(2^(n_bits-i));
        end;
        C_ar(n_bits+1) = C*(normrnd(1,C_mis_sig))*(2^(n_bits-i));   %dummy
    case 2  %com mismatch fixo
        for i=1:n_bits
            C_ar(i) = C*(2^(n_bits-i))*(1+C_misfixo);
        end;
        C_ar(n_bits+1) = C*(1+C_misfixo);   %dummy
        
end;
C_total = sum(C_ar);

%% Proceso de Conversão Single Ended Tradicional
for i=1:sp
    bit = zeros(1,n_bits);
% Fase 1: Distribuição de (Vcm-Vin) sobre os capacitores
    Qi = C_total*(Vcm - Vin(i));
% Fase 2: Entrada dos bits no DAC
    for a=1:n_bits
%         Q_total = 0;
        bit(a)=1;
        for b=1:n_bits 
            if bit(b)==1
                Vdac(b) = (C_ar(b)/C_total)*Vref;
            else
                Vdac(b)=0;
            end;
        end;
%         Q_total = (sum(Vdac)*C_total) + Qi;
        Vcomp = Vcm - (sum(Vdac) + Qi/C_total);
        if(Vcomp < 0)
            bit(a)=0;
        end;
    end;
    Vout_b(i,:) = bit;
end;

%% Recomposição do sinal
for i=1:sp
    for a=1:n_bits
        Vout_r(a) = (Vout_b(i,a)*(Vref/(2^a)));
    end;
    Vout(i) = sum(Vout_r) + Voff;
end;

%% Plotando os sinais
figure;
if(sinal==1)
    plot(Vin,Vin,'-b',Vin,Vout,'--ro'); % Plotando rampa
else
    plot(t,Vin,'-b',t,Vout,'--ro'); % Plotando senoide
    xlim([0 0.01]);
end;
legend('Sinal analógico','Sinal digital');
title(['Conversor SAR de ',num2str(n_bits),' bits']);
xlabel('Vin (V)');
ylabel('Vout (V)');

%% Cálculo do DNL e INL (apenas para entrada rampa)
if(sinal==1)    
    figure(2);
    edges = [0:(Vref/(2^n_bits)):Vref];
    h = histogram(Vout,edges);
    counts = h.Values;
    DNL(1)=0;
    for i=2:(2^n_bits)
        DNL(i) = (counts(i)-counts(i-1))/(sp/((2^n_bits)-1));
    end;
%% Cálculo do INL
    INL(1)=DNL(1);
    for i=1:(length(DNL)-1)
        INL(i+1) = INL(i) + DNL(i+1);
    end;
%% Plotando DNL e INL
    figure(2);
    subplot(2,1,1);
    plot(DNL,'--o');
    grid on;
%     ylim([-3 3]);
    title(['DNL - Conversor de ',num2str(n_bits),' bits']);
    xlabel('Níveis');
    ylabel('DNL');
    subplot(2,1,2);
    plot(INL,'--ro');
    grid on;
%     ylim([-3 3]);
    title(['INL - Conversor de ',num2str(n_bits),' bits']);
    xlabel('Níveis');
    ylabel('INL');
end;
%% Análise espectral dos sinais de entrada e saída do conversor
if(sinal==2)
    analise_espectral(Vin,Vout,fs);
end;
