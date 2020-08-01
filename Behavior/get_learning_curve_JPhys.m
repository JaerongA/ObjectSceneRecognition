%% By Jaerong 2016/09/27   Get the performance learning curve based on state-space model

% % Smith AC, Wirth A, Suzuki W, Brown EN. Bayesian analysis of interleaved learning and
% % response bias in behavioral experiments. Journal of Neurophysiology, 2007,
% % 97(3): 2516-2524.


dataROOT= 'G:\PRC_POR_ephys\Ephys_data';
saveROOT= 'G:\PRC_POR_ephys\Analysis\Behavior\Learning_curve';

if ~exist(saveROOT);
    mkdir(saveROOT);
end


% %% Output file generation
% cd(saveROOT);
% outputfile=['Latency.csv'];
% fod=fopen(outputfile,'w');
% txt_header = 'RatID, Session, Task_session, Task, Latency, \n';
% fprintf(fod, txt_header);
% fclose(fod);
% % end




%% Category
Familiar= 1;
Novel =2;

StimulusCat = 13;




BackgroundProb=0.5;
MaxResponse=1;
SigE = 0.005; %default variance of learning state process is sqrt(0.005)
UpdaterFlag = 2;  %default allows bias




cd(dataROOT);
listing_rat=dir('r*');nb_rat=size(listing_rat,1);


for Rat_run=2
%     :nb_rat
    target_rat = [dataROOT '\' listing_rat(Rat_run).name];cd(target_rat)
    listing_session=dir('r*');nb_session=size(listing_session,1);
    
    for Session_run=4:nb_session
        
        target_session = [target_rat '\' listing_session(Session_run).name];
        
        str1= findstr(target_session,'-');
        str2= findstr(target_session,'_');
        str3= findstr(target_session,'\');
        
        
        
        RatID= target_rat(end-3:end);
        Session = target_session(str1(1)+1:str1(2)-1);
        Task_session= target_session(str1(2)+1:str2(end)-1);
        Task = target_session(str2(end)+1:end);
        Title= strrep(target_session(str3(end)+1:end), '_','-');
        
        % Session_CAT_STR= {'TwoOBJ','FourOBJ','Modality','SceneOBJ'};
        
        if  strcmp(Task,'OCRS(FourOBJ)')
            cd(target_session); disp(Title);
        else
            continue;
        end
        
        
        clear str*
        
        
        
        cd([target_session '\Behavior'])
        load('Parsedevents.mat');
        
        % %%%%%%%%%%%%%%%%%% ts_evt  Column Header %%%%%%%%%%%%%%%%
        %
        % 1. Trial# 2. Stimulus 3. Correctness 4.Response 5.ChoiceLatency 6. StimulusOnset 7. Choice 8. Trial_S3_1, 9. Trial_S4_1, 10. Trial_S3_end, 11. Trial_S4_end, 12. Trial_Void
        % 13. StimulusCAT
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        ts_evt= add_category_info(ts_evt,Task);
        
        ts_evt = ts_evt(ts_evt(:,StimulusCat)== Novel,:);
        Responses = ts_evt(:,3);  %% Behavioral performance        
        Responses = Responses';
        Responses(isnan(Responses))  = [];  %% Remove NaN
        
        Perf= mean(Responses); disp(sprintf('Performance = %1.2f',Perf));
        
        
        
        I = [Responses; MaxResponse*ones(1,length(Responses))];
        
        SigsqGuess  = SigE^2;
        
        %set the value of mu from the chance of correct
        mu = log(BackgroundProb/(1-BackgroundProb));
        
        %convergence criterion for SIG_EPSILON^2
        CvgceCrit = 1e-8;
        
        %----------------------------------------------------------------------------------
        
        xguess         = 0;
        NumberSteps  = 2000;
        
        %loop through EM algorithm: forward filter, backward filter, then
        %M-step
        
        for i=1:NumberSteps
            
            %Compute the forward (filter algorithm) estimates of the learning state
            %and its variance: x{k|k} and sigsq{k|k}
            [p, x, Session_run, xold, sold] = forwardfilter(I, SigE, xguess, SigsqGuess, mu);
            
            %Compute the backward (smoothing algorithm) estimates of the learning
            %state and its variance: x{k|K} and sigsq{k|K}
            [xnew, signewsq, A]   = backwardfilter(x, xold, Session_run, sold);
            
            if (UpdaterFlag == 1)
                xnew(1) = 0.5*xnew(2);   %updates the initial value of the latent process
                signewsq(1) = SigE^2;
            elseif(UpdaterFlag == 0)
                xnew(1) = 0;             %fixes initial value (no bias at all)
                signewsq(1) = SigE^2;
            elseif(UpdaterFlag == 2)
                xnew(1) = xnew(2);       %x(0) = x(1) means no prior chance probability
                signewsq(1) = signewsq(2);
            end
            
            %Compute the EM estimate of the learning state process variance
            [newsigsq(i)]         = em_bino(I, xnew, signewsq, A, UpdaterFlag);
            
            xnew1save(i) = xnew(1);
            
            %check for convergence
            if(i>1)
                a1 = abs(newsigsq(i) - newsigsq(i-1));
                a2 = abs(xnew1save(i) -xnew1save(i-1));
                if( a1 < CvgceCrit & a2 < CvgceCrit & UpdaterFlag >= 1)
                    fprintf(2, 'EM estimates of learning state process variance and start point converged after %d steps   \n',  i)
                    break
                elseif ( a1 < CvgceCrit & UpdaterFlag == 0)
                    fprintf(2, 'EM estimate of learning state process variance converged after %d steps   \n',  i)
                    break
                end
            end
            
            SigE   = sqrt(newsigsq(i));
            xguess = xnew(1);
            SigsqGuess = signewsq(1);
            
        end
        
        if(i == NumberSteps)
            fprintf(2,'failed to converge after %d steps; convergence criterion was %f \n', i, CvgceCrit)
        end
        
        %-----------------------------------------------------------------------------------
        %integrate and do change of variables to get confidence limits
        
        
        %-----------------------------------------------------------------------------------
        %integrate and do change of variables to get confidence limits
        
        [p05, p95, pmid, pmode, pmatrix] = pdistn(xnew, signewsq, mu, BackgroundProb);
        
        %-------------------------------------------------------------------------------------
        %find the last point where the 90 interval crosses chance
        %for the backward filter (cback)
        
        cback = find(p05 < BackgroundProb);
        
        if(~isempty(cback))
            if(cback(end) < size(I,2) )
                cback = cback(end);
            else
                cback = NaN;
            end
        else
            cback = NaN;
        end
        
        
        cd(saveROOT);
        %
        %
        %
        % %% plotresults;
        %
        %
        %
        % %-------------------------------------------------------------------------------------
        % %plot the figures
        
        
        
        figure(1);  clf;
        
        subplot('Position', [0.4 0.99 0.4 0.2]);
        text(0,0, Title,'fontsize',15);
        axis off;
       
        
        
        %plot learning curve
        subplot(211);
        t=1:size(p,2)-1;
        plot(t, pmode(2:end),'r-','linewidth',2);
        hold on;
        plot(t, p05(2:end),'k:', t, p95(2:end), 'k:');
        if(MaxResponse == 1)
            hold on; [y, x] = find(Responses > 0);
%             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor','k');
%             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 40,'k','filled');
            hold on; [y, x] = find(Responses == 0);
%             h = plot(x,y+0.05,'s'); set(h, 'MarkerFaceColor', [0.75 0.75 0.75]);
%             set(h, 'MarkerEdgeColor', 'k');
            scatter(x, y + 0.05, 40,'k');
            axis([1 t(end)  0 1.05]);
        else
            hold on; plot(t, Responses./MaxResponse,'ko');
            axis([1 t(end)  0 1]);
        end
%         line([1 t(end)], [BackgroundProb  BackgroundProb]);
        h= hline(.5,'b:'); v= vline(cback,'g:', num2str(cback)); set(h,'linewidth',1.5); set(v,'linewidth',1.5);
%         title(['IO(0.95) Learning trial = ' num2str(cback) '   Learning state process variance = ' num2str(SigE^2) ]);
        xlabel('Trial #')
        ylabel('Performance(NovelOBJ)')
        box off;
        
        
        
        
        
        
%         %plot IO certainty
%         subplot(223)
%         plot(t,1 - pmatrix(2:end),'k')
%         line([ 1 t(end)],[0.90 0.90]);
%         line([ 1 t(end)],[0.99 0.99]);
%         line([ 1 t(end)],[0.95 0.95]);
%         axis([1 t(end)  0 1]);
%         grid on;
%         xlabel('Trial Number')
%         ylabel('Certainty')
        
        
        
        %% Trial to Trial
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %This code takes the output from runanalysis.m
        %and computes the within curve probability that
        %one trial is different from another
        %Anne Smith July 2004
        
        %allps is a matrix that contains the final p-value comparisons
        %between trial k and trial j
        
%         allps = [];
%         
%         numbermcs = 10000;   %number of Monte Carlo samples
%         
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %big loop through all the comparisons
%         
%         for trial1 = 1:length(xnew)
%             
%             pvalue = NaN*zeros(1, length(xnew));
%             
%             for trial2 = trial1 + 1: length(xnew)
%                 
%                 shortvec = trial1: trial2-1;
%                 
%                 a1       = eye(size(A,1));
%                 
%                 % Appendix D
%                 for ppp = trial2 - 1: -1: trial1
%                     a1  = mtimes(A(ppp), a1);
%                 end
%                 
%                 a1   = mtimes(a1, signewsq(trial2));
%                 covx = a1(1,1);
%                 
%                 mean1 = [ xnew(trial1) xnew(trial2)];
%                 cov1  = [ signewsq(trial1) covx;  ...
%                     covx signewsq(trial2) ];
%                 
%                 r         = mvnrnd(mean1, cov1, numbermcs);
%                 r1        = r(:,1);
%                 r2        = r(:,2);
%                 
%                 pp1       = exp(r1);
%                 pp2       = exp(r2);
%                 
%                 pvalue(trial2)  = length(find(pp1>pp2))/ numbermcs;
%                 
%             end
%             
%             allps = [allps; pvalue];
%             
%         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%         allps2 = allps;
%         
%         for ii = 1:length(xnew)
%             for jj = ii+1:length(xnew)
%                 allps2(jj,ii) = NaN; %  make the matrix lower triangular
%             end
%         end
%         
%         hold on;
%         % pno = 2;
%         subplot(224);
%         imagesc(allps2,[0 1]); colormap('bone')
%         
%         hold on;
%         co = 1;
%         [i,j] = find(allps2<0.05/co);
%         %plot(i,j,'.r');
%         plot(j,i,'.r');
%         minj = min(j);
%         if(~isempty(minj))
%             title(['Earliest trial signif above estimated start distribution '  num2str(minj(1)) ])
%         else
%             title('No trials above start distribution')
%         end
%         [i,j] = find(allps2<0.025/co);
%         %plot(i,j,'*r');
%         plot(j,i,'*r');
%         
%         [i,j] = find(allps2>0.95);
%         %plot(i,j,'.b');
%         plot(j,i,'.b');
%         [i,j] = find(allps2>0.975);
%         %plot(i,j,'*b');
%         plot(j,i,'*b');
%         axis([0.5 length(xnew)-.5 0.5 length(xnew)-.5]);
%         line([0.5 length(xnew)-.5],[0.5 length(xnew)-.5]);
%         
%         xlabel('Trial Number')
%         ylabel('Trial Number')
%         
        
        
        %% Write to output file
        
        %         cd(saveROOT);
        %         fod=fopen(outputfile,'a');
        %         fprintf(fod,'%s ,%s ,%s ,%s, %1.3f, \n',  RatID, Session, Task_session, Task, Latency);
        %         fclose(fod);
        
        
    end
end
disp('End')
