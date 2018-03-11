%% Script para calcular parâmetros de caracterização de transistores a partir
% de simulações.
% Método da Equação Normal para regressão linear

% Vgs =1.2

clear all;clc;
load('C:\Users\Iago\Documents\UnB\ENE\TCC\TCC 2\Caracterização\Carac_transistores grandes\ne\ids_lambda_ne.m');

ids = ids_lambda_ne;

% Condições de teste
vgs = 1;
w_l = 5/2;
kn = 166.80e-6;
vtn = 0.633;

flag=0;
for i=1:length(ids)
    if(ids(i,1) >= 1)
        if(flag == 0)
            u = i-1;
            flag = 1;
        end;
        ids_s(i-u,1) = ids(i,1);
        ids_rs(i-u,1) = ids(i,2);
    end;
end;

ids_s = [ones(length(ids_s),1) ids_s];
theta = (pinv(ids_s'*ids_s))*ids_s'*ids_rs;

ids = [ones(length(ids),1) ids];
y = theta'*ids(:,1:2)';

plot(ids(:,2),y);
hold on;
plot(ids(:,2),ids(:,3));
title(['ids x Vds']);
xlabel(['Vds (V)']);
ylabel(['ids (A)'])



lambda = theta(2)*2*(1/w_l)*(1/kn)*(1/((vgs-vtn)^2))
