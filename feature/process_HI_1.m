%%��ȡÿ����ص�����һ ������
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
CellX1_capacity=zeros(1,num);
for i=1:num   % �ı�ѭ��
    one=CellX{i,1}.C1dc;
    two=CellX{i,1}.C1ch;

    one_C1dc_tvqT=[one.t one.v one.q one.T]';
    two_C1dc_tvqT=[two.t two.v two.q two.T]';


    CellX{i,1}.C1dc.one_C1dc_tvqT=one_C1dc_tvqT;  % ��ÿ��ѭ���е� ÿһ�β��԰� tvqt �źþ��� 
    CellX{i,1}.C1dc.two_C1dc_tvqT=two_C1dc_tvqT;


   temp=[one_C1dc_tvqT two_C1dc_tvqT ];
   CellX{i,1}.C1_OCV=temp;
   CellX_capacity(i)=CellX{i,1}.C1dc.q(end);
%    CellX1_capacity(i)=CellX{i,1}.C1dc.q(5);
    t      = CellX{i,1}.C1dc.t; %ԭʼ����
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
    CellX{i,1}.C1dc.t=t_new;
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
end
%% ��ȡ����
    for i=1:num
    r        = 9;   %��˹�˲�31,6
    sigma    =1.05;
    CellX{i,1}.C1dc.v=Gaussianfilter(r,sigma,(CellX{i,1}.C1dc.v)');  
    HI(i)=SampEn(CellX{i,1}.C1dc.v);
    end
  %% ����Բ���  
  HI=filloutliers(HI,'previous'); 
  CellX_SOH=Cell_SOH{cellx,1};
  pearson_corr1 = corr(HI', CellX_SOH');
  HI=HI';
  CellX_SOH=CellX_SOH';
  disp('end')
  
  
  
  
  