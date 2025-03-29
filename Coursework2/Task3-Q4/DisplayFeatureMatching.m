function DisplayFeatureMatching(Image1, Image2, FeatureLocations1, FeatureLocations2, MatchIndex)

BInt = 10;

[I1Height,I1Width,t] = size(Image1);
if t>1
    Image1 = rgb2gray(Image1);
end
[I2Height,I2Width,t] = size(Image2);
if t>1
    Image2 = rgb2gray(Image2);
end
MImgH = max(I1Height,I2Height);
MImgW = I1Width+I2Width+BInt;
GImg = ones(MImgH,MImgW)*255;
Image2Offset = I1Width+BInt;
GImg(1:I1Height,1:I1Width) = Image1;
GImg(1:I2Height,Image2Offset+1:end) = Image2;

[R,C] = size(MatchIndex);
% if R*C>1 && MatchIndex{1}(1,1) > -1
    %%% construct match vectors
        M1 = FeatureLocations1(1:2,MatchIndex(1,:));
        M2 = FeatureLocations2(1:2,MatchIndex(2,:));
    %%% construct match vectors

    [~,NumMatches] = size(M1);
    
    % show(Image1,3), set(3,'name','Putative matches')
    imagesc(GImg);
    colormap gray;
    axis image;
    axis off;
    % hold on;
    OM2 = M2;
    OM2(2,:) = OM2(2,:)+Image2Offset;
    
    for i = 1:NumMatches;
        line([M1(2,i) OM2(2,i)], [M1(1,i) OM2(1,i)],'LineStyle','--', 'color','red');
    end
    for i = 1:NumMatches;
        line([M1(2,i) M1(2,i)], [M1(1,i) M1(1,i)],'LineWidth',2, 'MarkerSize',7, 'Marker','o', 'color','yellow');
    end
    
    for i = 1:NumMatches;
        line([OM2(2,i) OM2(2,i)], [OM2(1,i) OM2(1,i)],'LineWidth',2, 'MarkerSize',9, 'Marker','x', 'color','green');
    end
    % hold off;
    for i = 1:NumMatches;
        line([OM2(2,i) OM2(2,i)], [OM2(1,i) OM2(1,i)],'LineWidth',2, 'MarkerSize',9, 'Marker','x', 'color','green');
    end
    % pause(0.001);
% else
%     display('.');
% end