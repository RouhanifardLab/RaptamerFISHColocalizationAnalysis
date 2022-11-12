function thresholdFunction(app,label)

switch label
    case 'first'
        category=app.answer{1};
        %selecting the file to threshold
        originDirectory=append(app.dname,'/*.tif');
        [filename,pathname]=uigetfile(originDirectory,append('Select a ',category,' file'));
        image=Tiff(append(pathname,filename),'r');
        image=read(image);
        %deciding the threshold for the first time
        [level,bw]=thresh_tool(image);
        app.levelFirst=level;
        
    case 'second'
        
        category=app.answer{2};
        [filename,pathname]=uigetfile('.tif',append('Select a ',category,' file'));
        image=Tiff(append(pathname,filename),'r');
        image=read(image);
        %deciding the threshold for the first time
        [level,bw]=thresh_tool(image);
        app.levelSecond=level;
end


fprintf(app.fileID,'\r\nLevel for thresholding the %s file: %d',category,level)

end

