%Histograms

fileNameFirst='gfp002.tif';
fileNameSecond='gfp002negative_novirus.tif';
thresholdLevel=12741; %gfp

% fileNameFirst='alexa002.tif';
% fileNameSecond='alexa002negative_novirus.tif';
% thresholdLevel=1.99856e+03; %alexa



%opening the tif file
image1=Tiff(fileNameFirst,'r');
image1=read(image1);

image2=Tiff(fileNameSecond,'r');
image2=read(image2);

bwimage1=image1>thresholdLevel;
bwimage2=image2>thresholdLevel;

bwLab1=bwlabel(bwimage1);
bwLab2=bwlabel(bwimage2);

[uv,~,idx] = unique(bwLab1);
Areas1 = accumarray(idx(:),1);
Areas1 = Areas1(2:end,1);


[uv,~,idx] = unique(bwLab2);
Areas2 = accumarray(idx(:),1);
Areas2 = Areas2(2:end,1);

max1=max(Areas1);
max2=max(Areas2);
max1=max(max1,max2)+100;

figure

subplot(1,2,1)
histogram(Areas1,'BinWidth',50);
xlabel('particle size [pixel]')
ylabel('count')
title('N+1C')
xlim([0,max1])
subplot(1,2,2)
histogram(Areas2,'BinWidth',50);
xlabel('particle size [pixel]')
ylabel('count')
title('N-')
xlim([0,max1])

[h1Counts,h1Pixels]=histcounts(Areas1,'BinWidth',1);
h1Counts=h1Counts';h1Pixels=h1Pixels';
[h2Counts,h2Edges]=histcounts(Areas2,'BinWidth',1);
h2Counts=h2Counts';h2Pixels=h2Pixels';


