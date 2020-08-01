function PETH =  Draw_PETH(ts_evt, ref_evt, ts_spk, nb_bins, bin_size, marker_color, draw_mode)

%% INPUTS

%% ts_evt    :

%% ref_evt   :

%reference event

%% ts_spk :
% a vector of timestamps, like spike for exemple

%% nb_bins
% an integer, an even number, nb_bins/2 on the left, nb_bins/2 on the right

%% bin_size :
% a real nb in second

PETHsize=(floor(nb_bins/2)*bin_size);

[nb_trial nb_evt] =size(ts_evt);

nb_spk=size(ts_spk,1);

x_spk_train=[];y_spk_train=[];
y_histo=zeros(nb_trial,nb_bins);



%% Event
Trial= 1; Stimulus=2; Correctness=3; Response=4;

ChoiceLatency= 5; StimulusOnset=6; Choice=7;

for trial_run=1:nb_trial
    
    
    x_spk_train=[];y_spk_train=[];i_spk=1;
    
    % Define the time windows we were are analysing for this trial
    ts_c=ts_evt(trial_run,ref_evt);
    PETHstart= ts_c-PETHsize;    % bin start
    %             bin_end= ts_c+half_PETHsize;    % bin end
    PETHend= ts_c+(PETHsize);    % bin end
    
    % each time we read the spk train from the begining.
    % we know the boundaries of the PETH for each trial
    % [ref_evt - half_PETHsize , ref_evt + half_PETHsize]
    % we read the spk_train until we enter the interval of interest
    
    i_spk = find((ts_spk > PETHstart),1);
    if ~isempty(i_spk)
        
        while (ts_spk(i_spk)<PETHend) && (i_spk< nb_spk)
            Spk_start=ts_spk(i_spk)-PETHstart;
            i_histo=floor(Spk_start/bin_size)+1;
            y_histo(trial_run,i_histo)=y_histo(trial_run,i_histo)+1;
            Spk_start=Spk_start - PETHsize;
            x_spk_train(end+1)=Spk_start;
            i_spk=i_spk+1;
        end
    else
        continue
    end
    
    if draw_mode
        
        y_spk_train=(ones(1,length(x_spk_train)).*(nb_trial-(trial_run-0.5)));
        
        % o version
        %             plot(x_spk_train,y_spk_train,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','k','LineStyle','none','MarkerSize',1.5); hold on;
        
        %         % tick version
        for nb_spk=1:length(x_spk_train)
            lineh =  line([x_spk_train(nb_spk) x_spk_train(nb_spk)],[(nb_trial-(trial_run)) (nb_trial-(trial_run))+1],'color','k');
            set(lineh,'linewidth',1.5);
        end
        hold on;
        
        if ref_evt == StimulusOnset
            
            evt_ts=ts_evt(trial_run,StimulusOnset)-PETHstart;
            
            
        elseif  ref_evt == Choice
            
            evt_ts=ts_evt(trial_run,Choice)-PETHstart;
            
        end
        
        evt_ts=evt_ts - PETHsize;
        
        %% Event marking
        % dot
        %         plot(evt_ts, (nb_trial-(trial_run-0.5)),'Marker','o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none');
        %         evt_ts=ts_evt(trial_run,StimulusOnset)-PETHstart;
        %         evt_ts=evt_ts - PETHsize;
        %         plot(evt_ts, (nb_trial-(trial_run-0.5)),'Marker','o','MarkerSize',4,'MarkerFaceColor',marker_color(1),'MarkerEdgeColor','none');
        %         plot(evt_ts, (nb_trial-(trial_run-0.5)),'Marker','o','MarkerSize',4,'MarkerEdgeColor','none');
        
        
        
        if ref_evt == StimulusOnset
            
            lineh=  line([evt_ts evt_ts],[(sum(nb_trial) -(trial_run)) (sum(nb_trial) -(trial_run))+1],'color',[0.4 0.4 0.4]);
            
        elseif  ref_evt == Choice
            
            lineh=  line([evt_ts evt_ts],[(sum(nb_trial) -(trial_run)) (sum(nb_trial) -(trial_run))+1],'color','r');
            
        end
        
        set(lineh,'linewidth',2);
    else
    end
    
    x_spk_train = [];y_spk_train=[];
    
end

PETH=y_histo;

