function PETH =  Draw_PETH_all(ts_evt, ref_evt, ts_spk, nb_bins, bin_size, Stimulus_color, draw_mode)

%% INPUTS

%% ts_evt

%% ref_evt   :

%reference event

%% ts_spk :
% a vector of timestamps

%% nb_bins
% an integer, an even number, nb_bins/2 on the left, nb_bins/2 on the right

%% bin_size :
% a real nb in second

%% Event
Trial= 1; Stimulus=2; Correctness=3; Response=4;

ChoiceLatency= 5; StimulusOnset=6; Choice=7;



PETHsize=(floor(nb_bins/2)*bin_size);

% [nb_trial nb_evt] =size(ts_evt);

nb_spk=size(ts_spk,1);
nb_stimulus = length(unique(ts_evt(:,Stimulus)));

[nb_trial nb_evt] =size(ts_evt);

x_spk_train=[];y_spk_train=[];
y_histo=zeros(nb_trial,nb_bins);
event_color= {'r','b'};


% Sort according to the stimulus

% ts_evt= sortrows(ts_evt,Stimulus);


for stimulus_run = 1:nb_stimulus
    
    ts_evt_stimulus = ts_evt(find(ts_evt(:,Stimulus)== stimulus_run),:);
    
    ts_evt_stimulus= sortrows(ts_evt_stimulus,ChoiceLatency);
    
    [nb_trial(stimulus_run) nb_evt] =size(ts_evt_stimulus);
    
    
    for trial_run=1:nb_trial(stimulus_run)
        
        trial_stimulus= ts_evt_stimulus(trial_run, Stimulus);
        
        
        x_spk_train=[];y_spk_train=[];i_spk=1;
        
        % Time window definition.
        ts_c=ts_evt_stimulus(trial_run,ref_evt);
        PETHstart= ts_c-PETHsize;    % bin start
        %             bin_end= ts_c+half_PETHsize;    % bin end
        PETHend= ts_c+(PETHsize);    % bin end
        
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
            
            y_spk_train=(ones(1,length(x_spk_train)).*(nb_trial(stimulus_run)-(trial_run-0.5)));
            
            % o version
            %     plot(x_spk_train,y_spk_train,'Marker','o','MarkerFaceColor','k','MarkerEdgeColor','k','LineStyle','none','MarkerSize',1.5); hold on;
            
            % tick version
            for i_spk=1:length(x_spk_train)
                lineh=  line([x_spk_train(i_spk) x_spk_train(i_spk)],[(sum(nb_trial) -(trial_run)) (sum(nb_trial) -(trial_run))+1],'color',Stimulus_color(trial_stimulus,:));
                set(lineh,'linewidth',1.5);
            end
            hold on;
            
            if ref_evt == StimulusOnset
                
                evt_ts=ts_evt_stimulus(trial_run,Choice)-PETHstart;
                
            elseif  ref_evt == Choice
                
                evt_ts=ts_evt_stimulus(trial_run,StimulusOnset)-PETHstart;
            end
            
            
            evt_ts=evt_ts - PETHsize;
            
            %% Event marking
            % dot
            %         plot(evt_ts, (nb_trial-(trial_run-0.5)),'Marker','o','MarkerSize',4,'MarkerFaceColor','r','MarkerEdgeColor','none');
            % line
            %         lineh=  line([evt_ts evt_ts],[(nb_trial-(trial_run)) (nb_trial-(trial_run))+1],'color','r');
            
            if ref_evt == StimulusOnset
                
                lineh=  line([evt_ts evt_ts],[(sum(nb_trial) -(trial_run)) (sum(nb_trial) -(trial_run))+1],'color',[0.4 0.4 0.4]);
                
            elseif  ref_evt == Choice
                
                lineh=  line([evt_ts evt_ts],[(sum(nb_trial) -(trial_run)) (sum(nb_trial) -(trial_run))+1],'color','r');
                
            end
            
            
            set(lineh,'linewidth',2);
            
            
        else
        end
        
    end
    
    
end
x_spk_train = [];y_spk_train=[];


PETH=y_histo;

