function disc_index= get_disc_index(A,B)


%% By Jaerong 2012/12/07
%% Get discrimination index bewteen two values

disc_index= abs(A-B)./(A+B);

end

