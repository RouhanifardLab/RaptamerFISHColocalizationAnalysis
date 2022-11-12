classdef ColocalizationClass <handle
    
    properties
        fileID
        levelFirst
        levelSecond
        dname
        firstcat_Files
        secondcat_Files
        files
        answer
        bw
        
        allbwFirst
        allbwSecond
        
        pixelThreshold
        
        idxAG       %Indexes of colocalized particles (individuals+aggregates)
        
        idxDeleteAG %Indexes of colocalized aggregates
        idxKeepAG   %Indexes of colocalized individual virions
    end
        
    methods
        
        function app=ColocalizationClass
            
            initialization(app)
            
            
        end
    
        function initialization(app)
                       
            %folder selection (specify where are located all the tif files to analyze)
            app.dname = uigetdir([],'Select the folder with tif files');
            app.files = dir(fullfile(app.dname, '*.tif'));
            
            fileName=append(app.dname,'/',datestr(now,'yyyyddmmm_HHMM'),'_log.txt');
            app.fileID = fopen(fileName,'w');
            
            
            % Display the names
            fprintf(app.fileID,'Available tif files in folder %s:',app.dname);
            fprintf(app.fileID,'\r\n%s',app.files.name);
            fprintf('Working in folder %s. Available tif files:',app.dname);
            fprintf('\r\n%s',app.files.name);
            
            
            
            %if more prefixes are needed then add a prompt for choosing how many 
            prompt = {'Prefix n1:','Prefix n2:'};
            dlgtitle = 'Prefix Names';
            dims = [1 35];
            definput = {'alexa','gfp'};
            app.answer = inputdlg(prompt,dlgtitle,dims,definput);

            %grouping files according to prefix in 2 separate variables
            %called firstcat_Files and secondcat_Files
            groupingFiles(app);
            
            %selection of a black and white thresholding level for alexa (levelFirst)
            %and gfp (levelSecond)
            levelSelectionFunction(app);
            
            %coupling the alexa and gfp files according to their indexes
            %(i.e. alexa001 and gfp001 will be a couple), applying the
            %selected levels to all alexa and all gfp files and
            %colocalizing the ROIs + pixel filtration
            runFunction(app);

            %closing the file and display the text in command window
            fclose(app.fileID);
            type(fileName);
            
        end
        
   
        function groupingFiles(app)
            %grouping all the alexa named files in a variable and all the gfp named ones in another 
            app.firstcat_Files=cell(size(app.files));
            app.secondcat_Files=cell(size(app.files));
            for i=1:length(app.files)
                fileName=app.files(i).name;
                if contains(fileName,app.answer{1})==true 
                    app.firstcat_Files{i}=fileName;
                    else if contains(fileName,app.answer{2})
                        app.secondcat_Files{i}=fileName;
                        end
                end
            end
            app.firstcat_Files  = app.firstcat_Files(~cellfun('isempty', app.firstcat_Files)); %first category (alexa)
            app.secondcat_Files = app.secondcat_Files(~cellfun('isempty', app.secondcat_Files)); %second category (gfp)
        end
        
        
        function levelSelectionFunction(app)
            
            
           answer1 = questdlg('Do you want to threshold or use existing levels?', ...
                             'Menu', ...
                             'Threshold','Levels','Threshold');
            
           switch answer1
                case 'Threshold'

                    thresholdFunction(app,'first')
                    thresholdFunction(app,'second')
                    
                    
                case 'Levels'
                    
                    strFirst=append('Level for ',app.answer{1});
                    strSecond=append('Level for ',app.answer{2});
                    prompt = {strFirst,strSecond};
                    dlgtitle = 'Insert Levels';
                    dims = [1 35];
                    definput = {'1.949856e+03','1.273540e+04'};
                    answerL = inputdlg(prompt,dlgtitle,dims,definput);
                    app.levelFirst=str2num(answerL{1});
                    app.levelSecond=str2num(answerL{2});
                    
            end

        end
        
        function runFunction(app)

           %Pixel filtration
            answeryn = questdlg('Do you want to threshold the size?', ...
                         'Menu', ...
                         'YES','NO','YES');
            switch answeryn
                case 'YES'
                    prompt = {'Max area to keep [pixel]:'};
                    dlgtitle = 'Input';
                    dims = [1 50];
                    definput = {'70'};
                    pixelanswer = inputdlg(prompt,dlgtitle,dims,definput);
                    app.pixelThreshold=str2double(pixelanswer{1});
                    fprintf(app.fileID,'PIXEL THRESHOLDING ON. Max dimension = %d',app.pixelThreshold);
                    
                case 'NO'
                    idxDelAG=[0,0];
                    idxKeeAG=[0,0];
            end
            
            %loop over all the tif files and find the couples firstprefix001 secondprefix001, 
            %firstprefix002+secondprefix002,...,... (i.e. alexa001+gfp001,
            %alexa002+gfp002 etc.
            for i=1:length(app.firstcat_Files)

                fileNameFirst=app.firstcat_Files{i};
                index=regexp(fileNameFirst,'(\d*\.?\d+) *([a-zA-Z]*)','Match');
                index=index{1};

                for j=1:length(app.secondcat_Files)

                    if contains(app.secondcat_Files{j},index)
                       fileNameSecond=app.secondcat_Files{j};
                       break
                    end
                end

                firstCategory=Tiff(append(app.dname,'\',fileNameFirst),'r');
                firstCategory=read(firstCategory);
                
                %applying the defined levels to all alexa and gfp files to
                %binarize them. Therefore since now we are working with just
                %two levels of gray (0 and 1).
                try
                    %threshold for all alexa    
                    bwFirstCat=firstCategory>app.levelFirst;
                    app.allbwFirst{i}=bwFirstCat; %all the bw binarized images
                
                    secondCategory=Tiff(append(app.dname,'\',fileNameSecond),'r');
                    secondCategory=read(secondCategory);
                    
                    %threshold for all gfp
                    bwSecondCat=secondCategory>app.levelSecond; 
                    app.allbwSecond{i}=bwSecondCat; %all the bw binarized images
                catch 
                    error('******No black and white thresholding level selected!!!*******')
                end
                
                
               
                bwA=bwlabel(bwFirstCat);
                nAlexa = max(max(bwA)); %number of ROI in the alexa FOV

                bwG=bwlabel(bwSecondCat);
                nGfp = max(max(bwG)); %number of ROI in the gfp FOV

                intersect=bwFirstCat.*bwSecondCat; %intersected image
                idxInt=find(intersect>0);

                idxIntA=bwA(idxInt);
                idxIntG=bwG(idxInt);
                idx=[idxIntA idxIntG];
                idx=unique(idx,'rows');
                M = idx;
                % Remove non-unique first column values
                [~,x_idx] = unique(M(:,1)); 
                M2 = M(x_idx,:);
                % Then remove non-unique second column values
                [~,y_idx] = unique(M2(:,2));
                M3 = M2(y_idx,:);
                
                idx=M3;
                app.idxAG{i}=idx; %[alexa,gfp] for every experiment i
                
                fprintf(app.fileID,'\r\n\r\nFiles %s and %s',fileNameFirst, fileNameSecond);
                fprintf(app.fileID,'\r\nColocalized indexes:\r\n%s    %s\r\n',app.answer{1},app.answer{2});
                fprintf(app.fileID,'%d       %d\r\n',idx');
                fprintf(app.fileID,'Number of colocalized ROIs: %d\r\n',length(idx));
                fprintf(app.fileID,'Number of ROIs in %s: %d\r\nNumber of ROIs in %s: %d',app.answer{1},nAlexa,app.answer{2},nGfp);
                
                
                sz=size(intersect);
                [rowInt,colInt]=ind2sub(sz,idxInt);
                
                
%IF you want to filter every couple of images separately               
%                 %Pixel filtration
%                 answeryn = questdlg('Do you want to threshold the area?', ...
%                              'Menu', ...
%                              'YES','NO','YES');
%                 switch answeryn
%                     case 'YES'
%                         [idxDelAG,idxKeeAG]=resizeFunction(app,bwA,bwG,idx);
%                         app.idxDeleteAG{i}=idxDelAG;
%                         app.idxKeepAG{i}=idxKeeAG;
%                     case 'NO'
%                         %do nothing
%                 end
                
                if app.pixelThreshold>0    
                    [idxDelAG,idxKeeAG]=resizeFunction(app,bwA,bwG,idx);
                    app.idxDeleteAG{i}=idxDelAG;
                    app.idxKeepAG{i}=idxKeeAG;
                end
                
                figure
                subplot(1,2,1)
                plotDots(bwA,idx(:,1),idxDelAG(:,1),idxKeeAG(:,1))
                title(fileNameFirst)

                subplot(1,2,2)
                plotDots(bwG,idx(:,2),idxDelAG(:,2),idxKeeAG(:,2))
                title(fileNameSecond)
               
            end
        end
        
        
        
        function [idxDeleteAG,idxKeepAG]=resizeFunction(app,bwA,bwG,AG)
            
            [ROIdeleteA,AreasA]=ResizeFunction(bwA,app.pixelThreshold);
            [ROIdeleteG,AreasG]=ResizeFunction(bwG,app.pixelThreshold);
            

            [valA,idx_deleteA]=intersect(AG(:,1),ROIdeleteA);
            [valG,idx_deleteG]=intersect(AG(:,2),ROIdeleteG);

            idx_delete=[idx_deleteA;idx_deleteG];
            idx_delete=unique(idx_delete);
            idxDeleteAG=AG(idx_delete,:);
            AG(idx_delete,:)=[];
            idxKeepAG=AG;

            fprintf(app.fileID,'\r\n\r\nPixel filtration results:');
            fprintf(app.fileID,'Small colocalized particles:\n');
            fprintf(app.fileID,'%d       %d\r\n',idxKeepAG');
            fprintf(app.fileID,'Big colocalized particles (to exclude):\r\n');
            fprintf(app.fileID,'%d       %d\r\n',idxDeleteAG');
            fprintf(app.fileID,'Number of small particles: %d\r\nNumber of big particles: %d\r\n',length(idxKeepAG),length(idxDeleteAG));

        end
        

            
        end
        
    
end
