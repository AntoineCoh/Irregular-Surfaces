% Ce script identifie les cycles de marche entiers de chaque essai puis
% extrait les angles articulaires hanche, genou et cheville. Pour chaque
% participant et chaque condition, les angles sont concaténés et regroupés
% dans le cell array 'Kcrp', et les évènements de la marche dans 'events'.
%
%%
clc;
clear;
close all;
% -------------------------------------------------------------------------

addpath('.\btk');
nbp=64;                                                                     % Nombre de participants
cond={'Plat' 'Medium' 'High'};
nbe=10;                                                                     % Nombre d'essais
ang={'LHipAngles' 'LKneeAngles' 'LAnkleAngles' 'LThoraxAngles' 'LSpineAngles' 'LPelvisAngles';...
    'RHipAngles' 'RKneeAngles' 'RAnkleAngles' 'RThoraxAngles' 'RSpineAngles' 'RPelvisAngles'};
% 3 angles pour chaque articulation : Flex/Ext, Add/Abs, Rot

% -------------------------------------------------------------------------
K=cell(6,nbp);
% 6 Lignes : Gauche ('Plat' 'Medium' 'High'), Droite ('Plat' 'Medium' 'High')

for p=2:nbp
    part=sprintf('CTL_%02d',p);
    disp(['Processing participant: ' part]);
    temp=[part '_Plat_01.c3d'];
    if ~exist(temp,'file')
        continue
    end
    for c=1:length(cond)
        for j=1:2                                                           % Jambe g/d
        end
    end
end