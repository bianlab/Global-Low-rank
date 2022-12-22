function  [NL_mat]   =  Global_matching(im, par)
%GLOBAL_MATCHING Matching of patches with global similarity.
%   NL_mat = Global_matching(im,par) returns the indexes of the patches with similarity
PatchSize     =   par.win;  % size of the patch
HalfSize      =   floor(PatchSize/2);
SortNumber    =   par.nblk; % total number of similar patches
SelectRatio   =   1;        
channels      =   size(im, 3); % number of image channels
im            =   imresize(imresize(im,par.scale),[size(im,1), size(im,2)]); % remove tiny interference
ImNorm        =   (im-min(min(im)))./(max(max(im))-min(min(im)));
% extract the edge map 
[EdgeMaps_xp, EdgeMaps_xn, EdgeMaps_yp, EdgeMaps_yn] = Directional_EdgeDetector(ImNorm, par.threshold); 
EdgeMaps_xp   =   single(EdgeMaps_xp);
EdgeMaps_xn   =   single(EdgeMaps_xn);
EdgeMaps_yp   =   single(EdgeMaps_yp);
EdgeMaps_yn   =   single(EdgeMaps_yn);
EdgeMap = EdgeMaps_xp + EdgeMaps_xn + EdgeMaps_yp + EdgeMaps_yn;
Rows          =   size(EdgeMap, 1);
Cols          =   size(EdgeMap, 2);
RowsMatch     =   Rows-PatchSize+1;  
ColsMatch     =   Cols-PatchSize+1;  
% extract key patch according to the corners of Edgemap
CornersMap    =   detectHarrisFeatures(EdgeMap(HalfSize+1:Rows-HalfSize+1,HalfSize+1:Rows-HalfSize+1));
CornersMap    =   selectUniform(CornersMap, round(SelectRatio*CornersMap.Count), size(EdgeMap));
NumBlocks     =   CornersMap.Count; % number of the corners
yy            =   round(CornersMap.Location(:,1)); % index of column grid
xx            =   round(CornersMap.Location(:,2)); % index of row grid
TempPatchTensor_xpositive = zeros(PatchSize, PatchSize, channels, NumBlocks, 'single');
TempPatchTensor_xnegative = zeros(PatchSize, PatchSize, channels, NumBlocks, 'single');
TempPatchTensor_ypositive = zeros(PatchSize, PatchSize, channels, NumBlocks, 'single');
TempPatchTensor_ynegative = zeros(PatchSize, PatchSize, channels, NumBlocks, 'single');
for Num = 1: NumBlocks  % all key patch
    TempPatchTensor_xpositive(:,:,:,Num) = EdgeMaps_xp(xx(Num):xx(Num)+PatchSize-1, yy(Num):yy(Num)+PatchSize-1, :);
    TempPatchTensor_xnegative(:,:,:,Num) = EdgeMaps_xn(xx(Num):xx(Num)+PatchSize-1, yy(Num):yy(Num)+PatchSize-1, :);
    TempPatchTensor_ypositive(:,:,:,Num) = EdgeMaps_yp(xx(Num):xx(Num)+PatchSize-1, yy(Num):yy(Num)+PatchSize-1, :);
    TempPatchTensor_ynegative(:,:,:,Num) = EdgeMaps_yn(xx(Num):xx(Num)+PatchSize-1, yy(Num):yy(Num)+PatchSize-1, :);
end
% parallel patch matching with the 'Conv2d' layer
vl_setupnn;
HeatMap1      =   vl_nnconv( EdgeMaps_xp, TempPatchTensor_xpositive, []); 
HeatMap2      =   vl_nnconv( EdgeMaps_xn, TempPatchTensor_xnegative, []);
HeatMap3      =   vl_nnconv( EdgeMaps_yp, TempPatchTensor_ypositive, []);  
HeatMap4      =   vl_nnconv( EdgeMaps_yn, TempPatchTensor_ynegative, []);
HeatMap       =   HeatMap1 + HeatMap2 + HeatMap3 + HeatMap4; 
HeatMap       =   reshape(HeatMap, [RowsMatch*ColsMatch, NumBlocks]);
[~, Order]    =   sort(HeatMap, 1, 'descend');  % sort distance in descending order
NL_mat        =   Order(1:SortNumber, :);  % indexes of the most similar para.patchnum patches of neighbors
self_arr      =   (yy-1).*RowsMatch+xx;
self_arr      =   self_arr';  % guarantee the first line of NL_mat is the index of examplar
end