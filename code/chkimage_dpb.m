function chkimage_dpb(name)
if (nargin < 1 )
    error(message('stats:corr:TooFewInputs'));
end

V = spm_vol(name);
Atlas = spm_read_vols(V);
orig = V.mat(1:3,4)'*(-1);
maxlim = max(V.dim)+2;
s1 = zeros(V.dim(2),V.dim(3));
s2 = zeros(V.dim(1),V.dim(3));
s3 = zeros(V.dim(1),V.dim(2));

% if(sum(orig-[0 0 0]))
%     s1(1:V.dim(2),1:V.dim(3)) = Atlas(orig(1),:,:);
%     s2(1:V.dim(1),1:V.dim(3)) = Atlas(:,orig(2),:);
%     s3(1:V.dim(1),1:V.dim(2)) = Atlas(:,:,orig(3));
% 
% else
   s1(1:V.dim(2),1:V.dim(3)) = Atlas(floor(V.dim(1)/2),:,:);
    s2(1:V.dim(1),1:V.dim(3)) = Atlas(:,floor(V.dim(2)/2),:);
    s3(1:V.dim(1),1:V.dim(2)) = Atlas(:,:,floor(V.dim(3)/2));
% end

s1(isnan(s1)) =0;
s1(isinf(s1)) =0;
s2(isnan(s2)) =0;
s2(isinf(s2)) =0;
s3(isnan(s3)) =0;
s3(isinf(s3)) =0;

ABCGs1 =getABCgrayimage(s1);
ABCGs2 =getABCgrayimage(s2);
ABCGs3 =getABCgrayimage(s3);
ABCGsall = zeros(maxlim,maxlim*3);
ABCGsall(floor((maxlim/2)-(V.dim(3)/2))+1:floor((maxlim/2)+(V.dim(3)/2)),1:V.dim(2)) = rot90(ABCGs1);
ABCGsall(floor((maxlim/2)-(V.dim(3)/2))+1:floor((maxlim/2)+(V.dim(3)/2)),maxlim+1:maxlim+V.dim(1)) = rot90(ABCGs2);
ABCGsall(floor((maxlim/2)-(V.dim(2)/2))+1:floor((maxlim/2)+(V.dim(2)/2)),2*maxlim+1:2*maxlim+V.dim(1))  = rot90(ABCGs3);
% ABCGsall =getABCgrayimage(ABCGsall);
imwrite(ABCGsall,[name '.png']);
function ABCGvolume =getABCgrayimage(volume)
	Result =volume;
	%Save Maping Image parameters, Auto balance 20070911 revised, 20070914 revised for Statistical map which has negative values	
	%Revise first
	Result(isnan(Result)) =0;
	Result(isinf(Result)) =0;
	%Begin computation, the following two lines are time-consuming up to 4.6 seconds!!!
	%But after replacing AConfig with Result, then their speed rocketed to 0.2 seconds!!!
	%Attention!!! Dawnwei.Song, 20070914
	theMaxVal=max(Result(:));
	theMinVal=min(Result(:));
	if theMaxVal>theMinVal,
		nBins=255;
		%Special processing just for very common images! 20071212
		if (theMaxVal<257) && (theMinVal>=0) && (theMaxVal-theMinVal>100), %not statistic map
			theSum =histc(Result(:), 1:ceil(theMaxVal));		
		else
			theSum =histc(Result(:), theMinVal:(theMaxVal-theMinVal)/254:theMaxVal);		
		end
		theSum =cumsum(theSum);
		theCdf =theSum/theSum(end);
        FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
        if FullMatlabVersion(1)*1000+FullMatlabVersion(2)>=7*1000+3    %YAN Chao-Gan, 101025. Fixed a bug when displaying in MATLAB 2010.
		%if rest_misc('GetMatlabVersion')>=7.3
			idxSatMin =find(theCdf>0.01, 1, 'first');
			idxSatMax =find(theCdf>=0.99, 1, 'first');			
		else
			idxSatMin =find(theCdf>0.01);
			idxSatMin =idxSatMin(1);
			idxSatMax =find(theCdf>=0.99);
			idxSatMax =idxSatMax(1);
		end	
		if idxSatMin==idxSatMax, idxSatMin =1; end	%20070919, For mask file's display
		theSatMin =(idxSatMin-1)/(nBins-1) *(theMaxVal-theMinVal) +theMinVal;
		theSatMax =(idxSatMax-1)/(nBins-1) *(theMaxVal-theMinVal) +theMinVal;	
	elseif theMaxVal==theMinVal,
		theSatMin =theMaxVal;
		theSatMax =theMaxVal;
	else
    end
	ABCGvolume =volume;
	if theSatMin<theSatMax,
		ABCGvolume(find(ABCGvolume<theSatMin)) =theSatMin;
		ABCGvolume(find(ABCGvolume>theSatMax)) =theSatMax;
		ABCGvolume =(ABCGvolume -theSatMin)/(theSatMax - theSatMin);
	elseif theSatMin==theSatMax,
		ABCGvolume(:) =0.01;
	else
		error('ASatMin>ASatMax ???');
	end