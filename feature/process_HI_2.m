%%��ȡÿ����ص������� ���ʱ��
clc;clear;
load('Oxford_Battery_Degradation_Dataset_1.mat');
load Cell_SOH.mat
cellx=8; %��ѡ����
%%������ȡ
CellX=['Cell',num2str(cellx)];
CellX=eval(CellX);    
num_name=fieldnames(CellX);
num = length(num_name);
CellX=struct2cell(CellX); 
CellX_capacity=zeros(1,num);
for i=1:num   % �ı�ѭ��
%     one=CellX{i,1}.C1dc;
%     two=CellX{i,1}.C1ch;
%     three=CellX{i,1}.OCVdc;
%     four=CellX{i,1}.OCVch;
%     one_C1dc_tvqT=[one.t one.v one.q one.T]';
%     two_C1ch_tvqT=[two.t two.v two.q two.T]';
%     three_OCVdc_tvqT=[three.t three.v three.q three.T]';
%     four_OCVch_tvqT=[four.t four.v four.q four.T]';
% 
%     CellX{i,1}.C1dc.one_C1dc_tvqT=one_C1dc_tvqT;  % ��ÿ��ѭ���е� ÿһ�β��԰� tvqt �źþ��� 
%     CellX{i,1}.C1ch.two_C1ch_tvqT=two_C1dc_tvqT;
%     CellX{i,1}.OCVdc.three_C1dc_tvqT=three_OCVdc_tvqT;
%     CellX{i,1}.OCVch.four_C1dc_tvqT=four_OCVch_tvqT;
% 
%     temp=[one_C1dc_tvqT two_C1dc_tvqT three_OCVdc_tvqT four_OCVch_tvqT];
%     CellX{i,1}.C1_OCV=temp;
%    CellX_capacity(i)=CellX{i,1}.C1dc.q(end);
   
    t      = CellX{i,1}.C1ch.t; %ԭʼ����
    temp   = floor(t);
    ri     = mod(temp,365);
    temp   = rem(t,1)*24;
    hour   = floor(temp);
    temp   = rem(temp,1)*60;
    minute = floor(temp);
    temp   = rem(temp,1)*60;
    second = temp;
    t_temp = ri*86400+hour*3600+minute*60+second;
    t_new  = diff(t_temp);
    t_new  =[0;t_new];
    t_new  = cumsum(t_new);
    CellX{i,1}.C1ch.t=t_new;
    
    t      = CellX{i,1}.OCVch.t; %ԭʼ����
    temp   = floor(t);
    ri     = mod(temp,365);
    temp   = rem(t,1)*24;
    hour   = floor(temp);
    temp   = rem(temp,1)*60;
    minute = floor(temp);
    temp   = rem(temp,1)*60;
    second = temp;
    t_temp = ri*86400+hour*3600+minute*60+second;
    t_new  = diff(t_temp);
    t_new  =[0;t_new];
    t_new  = cumsum(t_new);
    CellX{i,1}.OCVch.t=t_new;
end
%% ��ȡ����
    for i=1:num
           C1ch_t=max(CellX{i,1}.C1ch.t);
           
           HI(i)=C1ch_t;
    end
HI=filloutliers(HI,'linear');
%   r        =5;  
%  sigma    = 0.9;
%  HI=Gaussianfilter(r,sigma,HI);
% m=6;y_aver=HI;%����ƽ���˲�,m��1�Ǵ���
% for i=m+1:length(HI)-m
%     temp=HI(:,i-m:i+m);sum=0;
%     for j=1:length(temp)%ð������
%         sum=sum+temp(j);
%     end
%     y_aver(i)=sum/(2*m+1);
%     temp=[];sum=0;
% end
% HI=y_aver;
HI=filloutliers(HI,'linear');
  %% ����Բ���  
 
  CellX_SOH=Cell_SOH{cellx,1};
  pearson_corr1 = corr(HI', CellX_SOH');
  HI=HI';
  CellX_SOH=CellX_SOH';
  disp('end')
  
  
  
  
  