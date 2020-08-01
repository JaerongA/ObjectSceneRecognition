function Map = Pos2Map(x,y, binX, binY, scale)
Map=[];
lx=length(x);ly=length(y);


if (lx~=ly), disp('error length(x)~=length(y)'); return; end

%If you want to exclude (x=0 | y=0) positions
% i_zero_x=~logical(x);i_zero_y=~logical(y);
% i_zero= i_zero_x | i_zero_y;
% x(i_zero)=[];
% y(i_zero)=[];
% lx=length(x);ly=length(y);

i_sup_x=[];i_sup_y=[];
i_sup_x=find(x>=(binX*scale));
i_sup_y=find(y>=(binY*scale));

if ~isempty(i_sup_x) | ~isempty(i_sup_y)
    disp('input data are too big, increase binX or binY or scale');
    return
end

x=x./scale;
y=y./scale;

Map=nan(binY,binX);

for i=1:lx
    i_x=floor(x(i))+1;
    i_y=floor(y(i))+1;
    Map(i_y,i_x)= nansum([Map(i_y,i_x) 1]);    
end
