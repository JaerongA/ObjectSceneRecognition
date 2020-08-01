% figure();
% % plot(x(1:200),y(1:200))
% % plot(x(1:200),y(1:200))

clear all;
pos= dlmread('Pos.p.ascii',',',24,0);
[r_pos,c_pos]=size(pos); t=pos(:,1)./1000000;x=pos(:,2);y=pos(:,3);a=pos(:,4);pos=[];ipos=1;

i1=~logical(x);i2=~logical(y); x(i1&i2)=[];y(i1&i2)=[];a(i1&i2)=[];t(i1|i2)=[];r_pos=length(t);
%% This emtyies all zeros in the matrix
t(or(find(x<=0),find(y<=0)))=[];
a(or(find(x<=0),find(y<=0)))=[];
x(find(x<=0))=[];
y(find(y<=0))=[];

% x(or(find(x<=150),find(y<=50)))=[];
% y(or(find(x>=400),find(y>=500)))=[];
%
%
% % y(or(find(y<=50),find(y>=500)))=[];
% % y(find(y<=0))=[];



fs=500;
figure();
ylim([50 500]);
xlim([150 400]);
set(gca,'YDir','reverse');
% for pos_run=1:length(x)
hold on;

for pos_run=1:11000
    
    plot(x(pos_run),y(pos_run),'r*');
    hold on;
    pause(1/fs);
    disp(pos_run);
end



