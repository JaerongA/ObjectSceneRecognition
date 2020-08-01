%% Get epoch firing rates per stimulus (correct vs. incorrect)


mean_fr.Corr=nan(1,2);
mean_fr.Incorr=nan(1,2);

sem_fr.Corr=nan(1,2);
sem_fr.Incorr=nan(1,2);


mean_fr.Pushing=nan(1,2);
mean_fr.Digging=nan(1,2);

sem_fr.Pushing=nan(1,2);
sem_fr.Digging=nan(1,2);



if     strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')

        
    
[mean_fr.Corr(Icecream) sem_fr.Corr(Icecream)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Corr,:));
[mean_fr.Corr(House) sem_fr.Corr(House)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Corr,:));

[mean_fr.Incorr(Icecream) sem_fr.Incorr(Icecream)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Incorr,:));
[mean_fr.Incorr(House) sem_fr.Incorr(House)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Incorr,:));


%% Get epoch firing rates per response

mean_fr.Pushing = [mean_fr.Corr(Icecream)];
mean_fr.Digging = [mean_fr.Corr(House)];

sem_fr.Pushing = [sem_fr.Corr(Icecream)];
sem_fr.Digging = [sem_fr.Corr(House)];

    
elseif    strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')

    
%     %% Stimulus
%     Zebra = 1;
%     Pebbles = 2; 
%     Owl = 3;
%     Phone = 4;
        
    
[mean_fr.Corr(Icecream) sem_fr.Corr(Icecream)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Corr,:));
[mean_fr.Corr(House) sem_fr.Corr(House)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Corr,:));
[mean_fr.Corr(Owl) sem_fr.Corr(Owl)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus3_Corr,:));
[mean_fr.Corr(Phone) sem_fr.Corr(Phone)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus4_Corr,:));

[mean_fr.Incorr(Icecream) sem_fr.Incorr(Icecream)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Incorr,:));
[mean_fr.Incorr(House) sem_fr.Incorr(House)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Incorr,:));
[mean_fr.Incorr(Owl) sem_fr.Incorr(Owl)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus3_Incorr,:));
[mean_fr.Incorr(Phone) sem_fr.Incorr(Phone)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus4_Incorr,:));

%% Get epoch firing rates per response

mean_fr.Pushing = [mean_fr.Corr(Icecream) mean_fr.Corr(Owl)];
mean_fr.Digging = [mean_fr.Corr(House) mean_fr.Corr(Phone)];

sem_fr.Pushing = [sem_fr.Corr(Icecream) sem_fr.Corr(Owl)];
sem_fr.Digging = [sem_fr.Corr(House) sem_fr.Corr(Phone)];

elseif    strcmp(summary(i_s).Task_name,'OCRS(Modality)')


    %     Modality_session= 1;
    %     txtCategory = {'VT' ; 'Visual'; 'Tactile' };
    %     txtStimulus = {'Owl' ; 'Phone'};
    %     PushStimulus= 1;
    %     DigStimulus= 2;
    
    %% Modality
    VT = 1;
    Visual =2;
    Tactile =3;
    %% Stimulus
    Owl = 1;
    Phone = 2;
    
    
    
[mean_fr.Owl(VT) sem_fr.Owl(VT)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_VT_Corr,:));
[mean_fr.Owl(Visual) sem_fr.Owl(Visual)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Vis_Corr,:));
[mean_fr.Owl(Tactile) sem_fr.Owl(Tactile)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Tact_Corr,:));

[mean_fr.Phone(VT) sem_fr.Phone(VT)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_VT_Corr,:));
[mean_fr.Phone(Visual) sem_fr.Phone(Visual)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Vis_Corr,:));
[mean_fr.Phone(Tactile) sem_fr.Phone(Tactile)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Tact_Corr,:));



%% Get epoch firing rates per response

mean_fr.Pushing = [mean_fr.Owl(VT) mean_fr.Owl(Visual) mean_fr.Owl(Tactile)];
mean_fr.Digging = [mean_fr.Phone(VT) mean_fr.Phone(Visual) mean_fr.Phone(Tactile)];

sem_fr.Pushing = [sem_fr.Owl(VT) sem_fr.Owl(Visual) sem_fr.Owl(Tactile)];
sem_fr.Digging = [sem_fr.Phone(VT) sem_fr.Phone(Visual) sem_fr.Phone(Tactile)];





elseif strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')


    
    %% Stimulus
%     Zebra = 1;
%     Pebbles = 2; 
%     Owl = 3;
%     Phone = 4;
        
    
    
[mean_fr.Corr(Zebra) sem_fr.Corr(Zebra)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Corr,:));
[mean_fr.Corr(Pebbles) sem_fr.Corr(Pebbles)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Corr,:));
[mean_fr.Corr(Owl) sem_fr.Corr(Owl)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus3_Corr,:));
[mean_fr.Corr(Phone) sem_fr.Corr(Phone)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus4_Corr,:));

[mean_fr.Incorr(Zebra) sem_fr.Incorr(Zebra)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus1_Incorr,:));
[mean_fr.Incorr(Pebbles) sem_fr.Incorr(Pebbles)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus2_Incorr,:));
[mean_fr.Incorr(Owl) sem_fr.Incorr(Owl)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus3_Incorr,:));
[mean_fr.Incorr(Phone) sem_fr.Incorr(Phone)]= get_epoch_FR(ts_spk, ts_evt_new(select.Stimulus4_Incorr,:));



%% Get epoch firing rates per response

mean_fr.Pushing = [mean_fr.Corr(Zebra) mean_fr.Corr(Owl)];
mean_fr.Digging = [mean_fr.Corr(Pebbles) mean_fr.Corr(Phone)];

sem_fr.Pushing = [sem_fr.Corr(Zebra) sem_fr.Corr(Owl)];
sem_fr.Digging = [sem_fr.Corr(Pebbles) sem_fr.Corr(Phone)];



end



clear spk
