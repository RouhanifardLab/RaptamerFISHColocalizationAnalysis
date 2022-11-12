function [idx_delete,Areas]=ResizeFunction(bwlabelImage,maximum)
%need to run this function for every bw image I have 
%INPUTS:
%bwlabelImage is the bwlabel() output (so every ROI is defined by a different number in the matrix)
%maximum is the maximum area in pixel we want to keep
%OUTPUTS:
%idx_delete = indexes of particles that are bigger than maximum, so to discard 
%c = column indexes of all the particles 
%r = row indexes of all the particles
%Areas = areas of all the particles
warning('off')
range_to_keep=[0,maximum];


%%
% [center,radii]=imfindcircles(bwlabelImage,range_to_delete,'EdgeThreshold',0,'Sensitivity',0.8);
% center=floor(center); %same of [r,c]
% 
% % figure
% % imshow(~bwlabelImage);
% % text(center(:,1),center(:,2),'*','Color','red');
% % str=sprintf('ROIs that will be deleted, maintaining ROIs in range:[%d,%d]',range_to_keep(1),range_to_keep(2));
% % title(str)
% % 
% % fprintf('\nNumber of deleted ROIs:%d\n',length(center))
% 
% deleteRoiImage=zeros(size(bwlabelImage));
% indexesBlack=sub2ind(size(bwlabelImage),center(:,2),center(:,1));
% 
% idx_Delete=bwlabelImage(indexesBlack); %same of R_delete


%%
%another possibility is to calculate the area of each ROI by summing all the
%pixels belonging to each ROI and calculate the radius as R=sqrt(A/pi)

[uv,~,idx] = unique(bwlabelImage);
Areas = accumarray(idx(:),1);
Areas = Areas(2:end,1);
idx_delete=find(Areas>range_to_keep(2));
%n  = histc(bwlabelImage,uv);

%fprintf('\nNumber of deleted ROIs after pixel thresholding: %d\n',length(idx_delete))

end

