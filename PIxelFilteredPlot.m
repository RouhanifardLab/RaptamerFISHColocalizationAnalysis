for i=1:length(app.allbwFirst)
    bwLabelA=bwlabel(app.allbwFirst{i}); %i instead of 1
    bwLabelG=bwlabel(app.allbwSecond{i});

    [indexesA,AreasA]=ResizeFunction(bwLabelA,app.pixelThreshold);
    [indexesG,AreasG]=ResizeFunction(bwLabelG,app.pixelThreshold);

    AG=app.idxAG{i}; %i


    for j=1:length(indexesA)
        idx=indexesA(j);
        delete=find(app.idxAG{i}(:,1)==idx);

        if ~isempty(delete)
            app.idxAG{i}(delete,:)=[];
        end
    end

    for j=1:length(indexesG)
        idx=indexesG(j);
        delete=find(app.idxAG{i}(:,2)==idx);

        if ~isempty(delete)
            app.idxAG{i}(delete,:)=[];
        end
    end
    
end