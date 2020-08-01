function Fitting_cat = get_category_repetition(Pval_sig)

%% Created by Jaerong 

global Icecream
global House
global Owl
global Phone



Fitting_cat ='Nonspecific';


switch sum(Pval_sig)
    
    case 0
        
        Fitting_cat ='Nofitting';
        
    case 1
        
        if Pval_sig(Icecream) || Pval_sig(House)
            
            Fitting_cat ='SingleOBJ(Familiar)';
            
        elseif  Pval_sig(Owl) || Pval_sig(Phone)
            
            Fitting_cat ='SingleOBJ(Novel)';
            
        end
        
        
    case 2
        
        if Pval_sig(Icecream) && Pval_sig(House)
            
            Fitting_cat ='Familiar';
            
        elseif  Pval_sig(Owl) && Pval_sig(Phone)
            
            Fitting_cat ='Novel';
            
        elseif   Pval_sig(Icecream) && Pval_sig(Owl)
            
            Fitting_cat ='Response';
            
        elseif   Pval_sig(House) && Pval_sig(Phone)
            
            Fitting_cat ='Response';
            
        end
        
end


end
