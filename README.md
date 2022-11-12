# RaptamerFISHColocalizationAnalysis
This tool allows to perform a colocalization analysis on two .tif images representing two different channels, giving as output the indexes of the matching particles (ROIs) in the two images, the number of matches and the number of total ROIs found in the two channels.
Optionally, it allows to filter the particles to exclude big aggregates from the colocalization results.


## <a name="uguide"></a>Users' Guide
To download the tool clone the repository or download the zip folder.
After downloading the code to your local machine, open Matlab and choose the RaptamerFISHColocalizationAnalysis as Current Folder.
Type `ColocalizationClass;` in the command window and press enter to run the tool.

### <a name="howworks"></a>How it works
The algorithm can be applied iteratively to a large number of .tif files stored in a folder. To work properly the files has to be called in the following way:
prefixNUM.tif
<br/>**prefix** is a name without numbers (i.e. the name of the dye used in the specific channel)
<br/>**NUM** is a index that is shared to the two images we want to use for the pairwised colocalization analysis.
Example of a folder:
1) alexa001.tif
2) gfp001.tif 
3) alexa002.tif
4) gfp002.tif 
5) alexa001positive.tif
6) alexa001negative.tif

Choosing this folder will result in 3 pairwise analysis where the tool will compute the colocalization of the particles between files 1 and 2,
then between files 3 and 4 and eventually between files 5 and 6.

#### <a name="steps"></a>The tree steps of analysis
The tool can be divided into the three main steps of binarization, colocalization and size thresholding.
<br/>1-The binarization step consists in the segmentation of the images, in order to detect all the ROIs in the field of view. 
<br/>To achieve this the user has to choose a pixel intensity level for each channel. When working with multiple files, the threshold selection is performed just once for all the images representing the first channel and once for all the images representing the second channel. This means that the threshold is shared by all the images acquired with the same dye. To apply a different threshold just create a new folder with the two .tif files to analyze separately.
<br/>The binarization step can be performed in two ways: by manually setting up a threshold (option Threshold) or by inputing known values for pixel intensity (Levels).
<br/>2-The colocalization step does not require user's inputs.
<br/>3-The size thresholding step is optional and allows the user to divide the colocalized particles into the two groups of small and big particles. This helps to exclude aggregates from the analysis.
<br/>The results are saved in a .txt file that is automatically stored in the folder containing the .tif files.


