function plotDots(bwlabelImage,idx,delete,keep)
% function showing the indexes over the image
% input=bwlabelImage, which is the output of the bwlabel funtion 

mymap=[1,1,1 ; 0,0,0];
imshow(bwlabelImage,'Colormap',mymap)

if sum(delete)>0 && sum(keep)>0
    
    for i=1:length(delete)
        [r,c]=find(bwlabelImage==delete(i));
        str=mat2str(delete(i));
        text(c(1),r(1),str,'FontSize',6,'Color','red')
    end
      
    for i=1:length(keep)
        [r,c]=find(bwlabelImage==keep(i));
        str=mat2str(keep(i));
        text(c(1),r(1),str,'FontSize',6,'Color','blue')
    end
else
    
    for i=1:length(idx)
        [r,c]=find(bwlabelImage==idx(i));
        str=mat2str(idx(i));
        text(c(1),r(1),str,'FontSize',6,'Color','blue')
    end
    
end

end

