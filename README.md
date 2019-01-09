# Projeto de um Conversor Analógico-Digital SAR

# Resumo

Este trabalho apresenta o desenvolvimento dos módulos analógicos de um conversor analógico-digital por aproximações sucessivas de 10 bits construído em tecnologia 0.18 um. O trabalho implementa um modelo comportamental do conversor em Matlab e a partir do algoritmo definido, parte-se para o desenvolvimento do circuito analógico do conversor. O circuito é dividido em blocos, entre eles destacam-se os circuitos bootstrapped sample and hold, o comparador e o conversor digital-analógico split capacitor array. Ao final do trabalho, é feita uma análise do desempenho de cada bloco separadamente, além de uma análise do conversor completo.

Neste repositório, encontram-se o código, em Matlab, do modelo de referência do conversor SAR. O intuito em desenvolver um modelo de referência é validar o comportamento esperado, dado um conjunto de entradas conhecidas, na saída do sistema por completo e na saída de cada subsistema do conversor. Para tanto, desenvolveu-se um modelo funcional puramente ideal e genérico do algoritmo do conversor. Vale lembrar que a topologia de SAR implementada nesse projeto é a Single-ended.

# Códigos

ADC_SAR.m -> Implementação de um conversor SAR de topologia Single-Ended

regressao.m -> Código utilizado na caracterização dos parâmetros Vth e Kn dos transistores de tecnologia 0.18um

regressao_lambda -> Código utilizado na caracterização do parâmetro lambda dos transistores de tecnologia 0.18um
