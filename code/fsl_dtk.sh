#!/bin/bash

#this function change the bvec from fsl style to dtk style.
function change_dtk()
{
   n=1
   m=$(awk 'NR==1{print NF}' $1)
   while (( n<=m ))
     do
	cut -f$n -d ' ' $1 | tr '\n' ' ' ;echo
	(( n++ ))
     done	
}


# this function is fsl preprocess,and need a 4D file data.nii.gz
# and bvec file:bvec and bval file: bval
function fsl_pre()
{
   eddy_correct data data_eddy 0
   fslroi data_eddy nodif 0 1;
   bet nodif nodif_brain -m -f 0.1;
    	
   fslmaths data_eddy.nii.gz -mas nodif_brain_mask.nii.gz data_eddy.nii.gz


   dtifit -k data_eddy.nii.gz -o dti -m nodif_brain_mask -r bvec -b bval;
   fslswapdim data_eddy.nii.gz x -y z xdata_eddy.nii.gz;

   fslchfiletype ANALYZE xdata_eddy.nii.gz  xdata_eddy;
   fslchfiletype NIFTI dti_S0.nii.gz S0.nii;
   fslchfiletype NIFTI dti_FA.nii.gz  FA.nii;	
}



#this function need a bvec that produce by change_dtk
function dtk_pro()
{
    #reconstrucion
    dti_recon data_eddy.nii.gz   dti -gm "bvec_dtk"   -b 1000 -b0 auto -iop 1 0 0 0 1 0  -p 3 -sn 1 -ot nii 
    #track
    dti_tracker dti track_tmp.trk -at 45 -iy  -m dti_fa.nii 0.1 1   -it nii -rseed 8
    #spline
    spline_filter track_tmp.trk 1 dti.trk
}



			                 
               		mkdir DTI_DATA
	        
		        cd DTI_DATA

                        # prepare for bvec(for fsl)
                        paste -d '' ../DTI1/*.bvec ../DTI2/*.bvec >bvec_tmp
                        paste -d '' ../DTI3/*.bvec bvec_tmp >bvec
			rm bvec_tmp
  			
			# prepare for bval(for fsl)
                        paste -d '' ../DTI1/*.bval ../DTI2/*.bval >bval_tmp
                        paste -d '' ../DTI3/*.bval bval_tmp >bval
			rm bval_tmp
                       
                        #prepare for data for fsl
		        fslmerge -t data ../DTI1/*.nii ../DTI2/*.nii ../DTI3/*.nii
		       
                        #fsl preprocess
                        fsl_pre;    

                        # make a folder ,and move all file related to fsl in the the new folder
			mkdir fsl
			mv * fsl/

			#make a folder for dtk ,and prepare for bvec and data
			mkdir dtk
			cp  fsl/bvec dtk/
			change_dtk dtk/bvec >dtk/bvec_dtk
			cp fsl/data_eddy.nii.gz dtk/
			
                        cd dtk

			#dtk process
                        dtk_pro;
			
			echo $i		
		

