function idx=MyColoc(fileNameFirst,fileNameSecond)

    %opening the tif file
    firstCategory=Tiff(fileNameFirst,'r');
    firstCategory=read(firstCategory);
    %deciding the threshold for the first time
    [levelFirstCat,bwFirstCat]=thresh_tool(firstCategory);
    
    %opening the tif file
    secondCategory=Tiff(fileNameSecond,'r');
    secondCategory=read(secondCategory);
    %deciding the threshold for the first time
    [levelSecondCat,bwSecondCat]=thresh_tool(secondCategory);
  

    bwA=bwlabel(bwFirstCat);
    nAlexa = max(max(bwA)); %number of ROI in the alexa FOV

    bwG=bwlabel(bwSecondCat);
    nGfp = max(max(bwG)); %number of ROI in the gfp FOV
    
    % %ROI index - X (col) - Y (row) coord
    % %imageJ and matlab are indexing differently-> matIdx=imjIdx+1
    % A=readmatrix("ResultsAlexa.csv");
    % rc=A(:,6:7)+ones(size(A(:,6:7)));
    % A=[A(:,1),rc];
    % G=readmatrix("ResultsGfp.csv");
    % rc=G(:,6:7)+ones(size(G(:,6:7)));
    % G=[G(:,1),rc];

    intersect=bwFirstCat.*bwSecondCat; %intersected image
    idxInt=find(intersect>0);

    idxIntA=bwA(idxInt);
    idxIntG=bwG(idxInt);
    idx=[idxIntA idxIntG];
    idx=unique(idx,'rows');
    fprintf('\n\nFiles %s and %s',fileNameFirst, fileNameSecond);
    fprintf('\nColocalized indexes:\n%s   %s\n',fileNameFirst,fileNameSecond)
    disp(idx)
    fprintf('Number of colocalized ROIs: %d\n',length(idx))
    fprintf('Number of ROIs in the first file:%d\nNumber of ROIs in the second file:%d\n',nAlexa,nGfp)

    sz=size(intersect);
    [rowInt,colInt]=ind2sub(sz,idxInt);
    
    
    figure
    plotDots(bwA,idx(:,1))
    title(fileNameFirst)
   
    
    figure
    plotDots(bwG,idx(:,2))
    title(fileNameSecond)
   
    
end



