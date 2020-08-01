
        if strcmp(summary(i_s).Task_name,'OCRS(TwoOBJ)')
            
            
        RMI  = get_disc_index(mean_fr.Corr(Icecream),mean_fr.Corr(House));
            
        elseif strcmp(summary(i_s).Task_name,'OCRS(FourOBJ)')
        
        RMI.Familiar  = get_disc_index(mean_fr.Corr(Icecream),mean_fr.Corr(House));
        RMI.Novel = get_disc_index(mean_fr.Corr(Owl),mean_fr.Corr(Phone));
        
        
        %% RMI (Rate modulation index between the stimuli that share the same behavioral response)
        
        RMI.Pushing  = get_disc_index(mean_fr.Corr(Icecream),mean_fr.Corr(Owl));
        RMI.Digging = get_disc_index(mean_fr.Corr(House),mean_fr.Corr(Phone));
        RMI.CAT= max(RMI.Pushing, RMI.Digging);   %% Select the higher RMI
        
            
        elseif strcmp(summary(i_s).Task_name,'OCRS(Modality)')
        
        RMI.VT  = get_disc_index(mean_fr.Owl(VT),mean_fr.Phone(VT));
        RMI.Visual = get_disc_index(mean_fr.Owl(Visual),mean_fr.Phone(Visual));
        RMI.Tactile = get_disc_index(mean_fr.Owl(Tactile),mean_fr.Phone(Tactile));
        
        
        elseif  strcmp(summary(i_s).Task_name,'OCRS(SceneOBJ)')
        
        
        RMI.Scene  = get_disc_index(mean_fr.Corr(Zebra),mean_fr.Corr(Pebbles));
        RMI.OBJ = get_disc_index(mean_fr.Corr(Owl),mean_fr.Corr(Phone));
        
        
        %% RMI (Rate modulation index between the stimuli that share the same behavioral response)
        
        RMI.Pushing  = get_disc_index(mean_fr.Corr(Zebra),mean_fr.Corr(Owl));
        RMI.Digging = get_disc_index(mean_fr.Corr(Pebbles),mean_fr.Corr(Phone));
        RMI.CAT= max(RMI.Pushing, RMI.Digging);   %% Select the higher RMI
        
        end
