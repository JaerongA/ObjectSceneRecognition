function Create_ParsedSpikes_Position(TT_folder,session_folder,counterbalanced)


binX=72; binY=48;
scale=10;

cd(TT_folder);
listing_cluster= dir('*cluster*'); [r_cluster c_cluster]= size(listing_cluster);  %%  # clusters in the TT folder



for i= 1:r_cluster
    cd(TT_folder)
    sprintf('%s', listing_cluster(i).name)
    cluster= dlmread(listing_cluster(i).name,',', 13,0);
    
    x_spk=cluster(:,16);y_spk=cluster(:,17);t_spk=cluster(:,18)./1000000; ispk=1;
    
    %     i1=~logical(x_spk);i2=~logical(y_spk);
    %     x_spk(i1&i2)=[];y_spk(i1&i2)=[]; t_spk(i1|i2)=[];    % We empty all zeros
    
    t_spk(or(find(x_spk<=0),find(y_spk<=0)))=[];     %% We remove all zeros or negative integers
    x_spk(find(x_spk<=0))=[];
    y_spk(find(y_spk<=0))=[];
    
    
    [r_t_spk,c_t_spk]=size(t_spk);
    
    
    if ~isempty(t_spk)
    
    cd([session_folder '\ExtractedEvents']);
    listing_mat= dir('trial*.mat'); [r_trial, c_trial]= size(listing_mat);  %% # of trials in that session
    obj_spk= zeros(r_cluster,2); corr_spk=zeros(r_cluster,2); trial_spk= zeros(r_cluster, r_trial); side_spk= zeros(r_cluster,2); %amb_spk= zeros(r_cluster,5);
    trial_corr_spk=nan(r_trial,1); trial_void_spk=nan(r_trial,1); trial_side_spk=nan(r_trial,1); trial_object_spk=nan(r_trial,1); total_trial_number_spk=r_trial;
    
    
    
    sensor4_detected=0;
    for i1=1:r_trial
        
                switch length(sprintf('%d',i1))
                    case 1
                        filename= ['trial00' num2str(i1) '.mat'];
                    case 2
                        filename= ['trial0' num2str(i1) '.mat'];
                    case 3
                        filename= ['trial' num2str(i1) '.mat'];
                end
        % This way, we can correctly sort trials in ascending order
        load (filename);
        if ~trial_void
            %% This part is very similar to the part used to parse the position data in Create_ParsedSpikes(session_folder,session,valid_clusters,task_code)
            if (~isempty(start)) && (~isempty(disc_touch))
                sensor4_detected=0;
                if (length(sensor4)>1) start=sensor4(1);  sensor4_detected=1; end
                while ((t_spk(ispk)<start) && (ispk<(r_t_spk-1))) ispk=ispk+1; end
                
                trial_corr_spk(i1)=correctness; trial_void_spk(i1)=0; trial_object_spk(i1)=object; total_trial_number_spk=r_trial;
                %% Here we will process the outbound journey data from start
                %% (sensor1 break) to TouchScreen
                while ((t_spk(ispk)<=disc_touch) && ispk<(r_t_spk-1))
                    obj_spk(ispk,object+1)=1;
                    corr_spk(ispk,correctness+1)=1;
                    trial_spk(ispk,i)=1;
                    % for debugging msg=sprintf('i=%d ispk=%d',i,ispk);disp(msg);
                    
                    if ~counterbalanced
                        side1=0;side2=1;
                    else
                        side1=1;side2=0;
                    end
                    
                    if  ~object  && correctness, side_spk(ispk,1)=1; trial_side_spk(i1)=side1; end
                    if  ~object  && ~correctness, side_spk(ispk,2)=1; trial_side_spk(i1)=side2; end
                    if  object  && correctness, side_spk(ispk,2)=1; trial_side_spk(i1)=side2; end
                    if  object  && ~correctness, side_spk(ispk,1)=1; trial_side_spk(i1)=side1; end
                    ispk=ispk+1;
                end
                
            end
        else
            trial_void_spk(i1)=1;
        end
        
        
    end
    
    SpkCountMap = nan(48,72,r_trial);
    disp('Start Building Spike Count Map for each trial');
    
    
    
    for i2=1:r_trial
        ii = logical(trial_spk(:,i2));
        if(sum(ii))

            
            map = Pos2Map(x_spk(ii),y_spk(ii),binX,binY,scale);
            SpkCountMap(1:48,1:72,i2) = map;
        end
        ii=[];
    end
    
    %     Setting the name of the .mat file to be generated
    listing_cluster(i).name
    session_name= session_folder(18:24);
    mat_name= [session_name '_' listing_cluster(i).name '.mat'];
    
    
    cd([session_folder '\ParsedSpk']);
    disp('....Parsing of Spike Data Done');
    save(mat_name,'t_spk','x_spk','y_spk','obj_spk','corr_spk','trial_spk','side_spk','SpkCountMap',...
        'trial_corr_spk','trial_void_spk','trial_side_spk', 'trial_object_spk','total_trial_number_spk');
    
    else
        disp('Spikes were out of the maze')
    end
end










