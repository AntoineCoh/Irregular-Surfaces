% Ce script extrait les positions des marqueurs sur des cycles complets
% comprenant un cycle entier de chaque côté, puis calcule leurs 
% accélérations. Les cycles complets sont normalisés sur 100 puis
% concaténés pour chaque condition de chaque participant. Toutes les
% données sont regroupées dans le cell array Acc.
%%
clc;
clear;
% -------------------------------------------------------------------------

addpath('.\btk');
nbp=64;                                                                     % Nombre de participants
cond={'Plat' 'Medium' 'High'};
nbe=10;                                                                     % Nombre d'essais
mark={'LFHD' 'RFHD' 'LBHD' 'RBHD' 'C7' 'T10' 'CLAV' 'STRN' 'RBAK' 'LSHO' 'LELB' 'LFIN' 'RSHO' 'RELB' 'RFIN' ...
'LASI' 'RASI' 'LPSI' 'RPSI' 'LTHI' 'LKNE' 'LTIB' 'LANK' 'LHEE' 'LTOE' 'RTHI' 'RKNE' 'RTIB' 'RANK' 'RHEE' 'RTOE'};

% -------------------------------------------------------------------------
Acc=cell(3,nbp);                                                            % 3 Lignes ('Plat' 'Medium' 'High')

for p=2:nbp
    part=sprintf('CTL_%02d',p);
    disp(['Processing participant: ' part]);
    temp=[part '_Plat_01.c3d'];
    if ~exist(temp,'file')
        continue
    end
    for c=1:length(cond)
        ma=[];
        for e=1:nbe
            ess=sprintf('%02d',e);
            file=[part '_' cond{c} '_' ess '.c3d'];
            if ~exist(file,'file')
                continue
            end
            data=btkReadAcquisition(file);
            markers=btkGetMarkers(data);
            events=btkGetEvents(data);
            start=btkGetFirstFrame(data);
            HSl=round(events.Left_Foot_Strike*100-start);                   % Heel strikes
            HSr=round(events.Right_Foot_Strike*100-start);
            HSl(HSl<=0)=1;                                                  % Au cas où HS1 est avant ou coïncide avec la première frame
            HSr(HSr<=0)=1;
            HSmin=[min(HSl);min(HSr)];
            [~,HSind]=min(HSmin);                                           % Côté du premier HS (1 : gauche, 2 : droite)
            nbc=min(length(HSl),length(HSr))-1;                             % Nombre de cycles complets
            for cy=1:nbc                                                    % ⚠ Ici un cycle complet comprend un cycle de chaque jambe
                mm=[];
                for m=1:length(mark)
                    if HSind==1
                        vm=markers.(mark{m})(HSl(cy):HSr(cy+1),1:2);        % Directions X et Y, médiolatérale et anteropostérieure
                    else
                        vm=markers.(mark{m})(HSr(cy):HSl(cy+1),1:2);
                    end
                    if vm(1,1)==0 || vm(end,1)==0
                        vm=zeros(length(vm),2);                             % Position du marqueur à zéro s'il manque une partie du cycle
                    end
                    time=(0:0.01:0.01*(length(vm)-1))';
                    vm_vit=zeros(length(vm),2);
                    vm_acc=zeros(length(vm),2);
                    for i=1:2
                        vm_vit(:,i)=gradient(vm(:,i))./gradient(time);
                        vm_acc(:,i)=gradient(vm_vit(:,i))./gradient(time);
                    end
                    mm=[mm vm_acc];
                end                                                         % Normalisation des cycles
                mn=interp1(linspace(1,size(mm,1),size(mm,1)),mm,linspace(1,size(mm,1),100));
                ma=[ma mn'];                                                % Concaténation
            end
        end
        Acc{c,p}=ma;
        disp(['Condition: ' cond{c}]);
    end
end
save Acc.mat Acc