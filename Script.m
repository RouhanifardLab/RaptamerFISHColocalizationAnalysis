%Script
idx=MyColoc('alexa002.tif','gfp002.tif');

%Command Window output:
%Name of the 2 analized files.
%Colocalized indexes found in the 2 images, the first column refers to the
%first file name given as input to the MyColoc function and the second column
%refers to the second file name.
%After the list of indexes you find:
%1. The number of colocalized row
%2. The number of ROIs in the first image 
%3. The number of ROIs in the second image
%Therefore if the number of ROIs in the first image (ROI1) is bigger than
%the number of ROIs in the second image (ROI2) --> ROI1>ROI2, the number of
%colocalized ROIs (N) has to be compared with ROI2 to understand the % of
%colocalization./
%EX:
%Number of colocalized ROIs: 109
%Number of ROIs in the first file:314
%Number of ROIs in the second file:610
%--> N=109, ROI1=314, ROI2=610  ROI1<ROI2
%--> %colocalization=(N/ROI1)*100=(109/314)*100=34.7%
