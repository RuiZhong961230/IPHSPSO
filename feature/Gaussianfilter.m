% 功能：对一维信号的高斯滤波，头尾r/2的信号不进行滤波
% r     :高斯模板的大小推荐奇数
% sigma :标准差
% y     :需要进行高斯滤波的序列
function y_filted = Gaussianfilter(r, sigma, y)
% 生成一维高斯滤波模板
    GaussTemp = ones(1,r*2-1);%初始化模板 中心点两边的个数 r为3时 模板为 1*5
    for i=1 : r*2-1       %生成模板
    GaussTemp(i) = exp(-(i-r).^2/(2*sigma^2))/(sigma*sqrt(2*pi));
    end

    % 高斯滤波
    y_filted = y;
    temp_zero=zeros(1,r-1);
    y=[temp_zero,y,temp_zero];
for i = 1 : length(y_filted) 
    y_filted(i) = y(i:i+2*(r-1))*GaussTemp';
end
