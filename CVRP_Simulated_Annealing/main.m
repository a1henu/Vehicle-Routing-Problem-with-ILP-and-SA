clc;
clear;
close all;

set(gcf,'unit','normalized','position',[0,0.35,1,0.5]);

model = initModel(300, 120, 4, 20);
simulatedAnnealing(model, 500, 1, 0.998);