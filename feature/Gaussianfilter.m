% ���ܣ���һά�źŵĸ�˹�˲���ͷβr/2���źŲ������˲�
% r     :��˹ģ��Ĵ�С�Ƽ�����
% sigma :��׼��
% y     :��Ҫ���и�˹�˲�������
function y_filted = Gaussianfilter(r, sigma, y)
% ����һά��˹�˲�ģ��
    GaussTemp = ones(1,r*2-1);%��ʼ��ģ�� ���ĵ����ߵĸ��� rΪ3ʱ ģ��Ϊ 1*5
    for i=1 : r*2-1       %����ģ��
    GaussTemp(i) = exp(-(i-r).^2/(2*sigma^2))/(sigma*sqrt(2*pi));
    end

    % ��˹�˲�
    y_filted = y;
    temp_zero=zeros(1,r-1);
    y=[temp_zero,y,temp_zero];
for i = 1 : length(y_filted) 
    y_filted(i) = y(i:i+2*(r-1))*GaussTemp';
end
