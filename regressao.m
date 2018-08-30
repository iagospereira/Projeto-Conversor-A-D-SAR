%% Script para calcular parâmetros de caracterização de transistores a partir
% de simulações.
% Método da Equação Normal para regressão linear

clear all;clc;
load('ids_k_ne.m');

vds = 1;

ids = ids_k_ne;
ids_raiz(:,1) = sqrt(ids(:,2));
flag=0;
for i=1:length(ids_raiz)
    if((ids(i,1) >= 0.9) && (ids(i,1) <= 1.1))
        if(flag == 0)
            u = i-1;
            flag = 1;
        end;
        ids_s(i-u,1) = ids(i,1);
        ids_rs(i-u,1) = ids_raiz(i,1);
    end;
end;

ids_s = [ones(length(ids_s),1) ids_s];
theta = (pinv(ids_s'*ids_s))*ids_s'*ids_rs;

ids = [ones(length(ids),1) ids];

y = theta'*ids(:,1:2)';
% y = theta'*ids_s';

plot(ids(:,2),y);
% plot(ids_s(:,2),y);
hold on;
plot(ids(:,2),ids_raiz);
title(['Raiz(id) x Vgs']);
xlabel(['Vgs (V)']);
ylabel(['id^0^.^5 (A^0^.^5)'])

w = 5;
L = 2;

kn = ((theta(2))^2)*2*L/w
