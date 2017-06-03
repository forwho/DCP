% 参数名：bval，degree,翻转x y z，low_fa,high_fa,seed,
% 需要安装dtk,但不需要设定路径
function dtk_code(degree,invert,low_fa,high_fa,seed,swap)

blank=32;
location=mfilename('fullpath');
%dti_tracker
degree=num2str(degree);
fa_low=num2str(low_fa);
fa_high=num2str(high_fa);
seed=num2str(seed);
[pathstr,name,ext] = fileparts(location);
swap=num2str(swap);
if strcmp(swap,'no swap') % the command dose not contain swap
    system(strcat(pathstr,'\dti_tracker dti dti_', degree,'_',fa_low,'_',seed,'.trk -at ',blank,degree, ' -i',invert,blank,' -m dti_fa.nii ',blank,fa_low, blank,fa_high ,'  -it nii -rseed',blank, seed));
else  % the command contains a swap 
    %strcat(pathstr,'\dti_tracker dti dti_', degree,'_',fa_low,'_',seed,'.trk -at ',blank,degree, ' -i',invert,blank ,'-',swap,' -m dti_fa.nii ',blank,fa_low, blank,fa_high ,'  -it nii -rseed',blank, seed)
    system(strcat(pathstr,'\dti_tracker dti dti_', degree,'_',fa_low,'_',seed,'.trk -at ',blank,degree, ' -i',invert,blank ,'-',swap,' -m dti_fa.nii ',blank,fa_low, blank,fa_high ,'  -it nii -rseed',blank, seed));
end

end