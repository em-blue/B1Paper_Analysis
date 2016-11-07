%% B1T1qMT Comparison
%

% This one is a little bit more complicated to use, due to the fact that
% single-slice mincblur -ing doesn't work for mincversion above 2.1.10, and
% must be applied using MINC1 files. Here's the steps I followed to get
% this script to work.

% 1. rsync -r /Users/mathieuboudreau/Work/Analysis_PhDWork/B1Paper_Analysis/data/remote/ mboudrea@login.bic.mni.mcgill.ca:/data/mril/mril13/mboudrea/temp/B1Paper_Analysis/data
%   -> data/remote/ contains each subject, but only the MINC2 folders b1_whole_brain and t1_whole_brain
% 2. Remotely on  lafite, cd to /data/mril/mril13/mboudrea/temp/B1Paper_Analysis/data
%
% 3. For each subject in data/, execute: python3 convert_dir_minc2_to_minc1.py subject/b1_whole_brain
%                               and      python3 convert_dir_minc2_to_minc1.py subject/t1_whole_brain
%
% 4. Return to B1Paper_Analysis folder.
%
% 5. Run matlab15a
%
% 6. Execute startup.m
%
% 7. Execute blurAllSubjects.m (this script)
%
% 8. Locally, rsync -r /Users/mathieuboudreau/Work/Analysis_PhDWork/B1Paper_Analysis/data/remote/ mboudrea@login.bic.mni.mcgill.ca:/data/mril/mril13/mboudrea/temp/B1Paper_Analysis/data
%
% 9. Then, return to the local session.
%
% 10. Copy the b1_blur and b1_spline in each subject in the data/remote/subject folders to their respective data/subects/ folders
%
% 11. cd to data/
%
% 12. For each subject in data/, execute: python3 convert_dir_minc1_to_minc2.py subject/b1_blur
%                                and      python3 convert_dir_minc1_to_minc2.py subject/b1_spline
%
% 13. Verify that the maps were blurred correctly using register!


%% Clear session
%

clear all
clc
close all

%% Debug flag
%

% If DEBUG=1, b1_blur and b1_spline folders will be removed at the end for all subjects.
DEBUG=0;

%% Data info
%

dataDir = [pwd '/data'];
b1t1FileOptions = {'b1_whole_brain/', 't1/', {'clt_da', 'bs', 'afi', 'epi'}, 'gre'};

maskFile = 't1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc';

%% Setup file information
%

subjectIDs = dirs2cells(dataDir);

s = generateStructB1T1Data(b1t1FileOptions{1}, b1t1FileOptions{2}, b1t1FileOptions{3}, b1t1FileOptions{4});
b1Keys = b1t1FileOptions{3}; % shorthand names of the b1 methods
b1ID = s.b1Files;
t1ID = s.t1Files;
mincExtension = '.mnc';

numB1 = size(b1ID,2); % Number of B1 methods compared, e.g. number of curves to be displayed in the hist plots.
numSubjects = size(subjectIDs,1);

blurDirs = {'b1_blur', 'b1_spline'};

%% Blur maps for each subjects
%

olddir = cd;

for counterSubject = 1:numSubjects
    cd([dataDir '/' subjectIDs{counterSubject}])
    disp(cd)

    % Load study indices for all measurements for this subject
    study_info

    for ii = 1:length(blurDirs)
        if(~isdir(blurDirs{ii}))
            mkdir(blurDirs{ii})
        end
        switch blurDirs{ii}
            case 'b1_blur'
                 for jj = 1:length(b1ID)
%                     Only runs on lafite at the bic, not my laptop. Must
%                     have the following mincinfo -version
%                     program: 2.1.10
%                     libminc: 2.1.10
%                     netcdf : "3.6.3" of Apr 17 2013 00:19:55 $
%                     HDF5   : 1.8.8
                    system(['mincblur -clobber -no_apodize -dimensions 2 -fwhm 2 ' b1ID{jj} ' b1_blur' b1ID{jj}(length(b1t1FileOptions{1}):(end-length(mincExtension)))])
                end
            case 'b1_spline'
                for jj = 1:length(b1ID)
                    system(['spline_smooth -verbose -clobber -distance 60 -lambda 2.5119e-06 -mask ' maskFile ' ' b1ID{jj} ' b1_spline' b1ID{jj}(length(b1t1FileOptions{1}):(end))])
                end
        end
    end

end

%% Cleanup
%
% *** TEMP *** Delete data & folders for now during development. Remove
% later.

if(DEBUG==1)
    for counterSubject = 1:numSubjects
        cd([dataDir '/' subjectIDs{counterSubject}])
        disp(cd)

        for ii = 1:length(blurDirs)
            if(isdir(blurDirs{ii}))
                rmdir(blurDirs{ii},'s')
            end
        end
    end
end

% Return to original folder
cd(olddir)


% system(['mincblur -no_apodize -dim 2 -fwhm 10 b1_whole_brain/b1_clt_tse.mnc b1_blur/b1_clt_tse' ]);
% system(['mincblur -no_apodize -dim 2 -fwhm 10 b1_whole_brain/b1_clt_afi.mnc b1_blur/b1_clt_afi' ]);
% system(['mincblur -no_apodize -dim 2 -fwhm 10 b1_whole_brain/b1_clt_gre_bs_cr_fermi.mnc b1_blur/b1_clt_gre_bs_cr_fermi' ]);
% system(['mincblur -no_apodize -dim 2 -fwhm 10 b1_whole_brain/b1_epseg_da.mnc b1_blur/b1_epseg_da' ]);
% 
% 
% % Spline
% 
% system(['spline_smooth -verbose -distance 60 -lambda 2.5119e-06 -mask t1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc b1_whole_brain/b1_clt_tse.mnc b1_spline/b1_clt_tse_spline.mnc'])
% system(['spline_smooth -verbose -distance 60 -lambda 2.5119e-06 -mask t1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc b1_whole_brain/b1_clt_afi.mnc b1_spline/b1_clt_afi_spline.mnc'])
% system(['spline_smooth -verbose -distance 60 -lambda 2.5119e-06 -mask t1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc b1_whole_brain/b1_clt_gre_bs_cr_fermi.mnc b1_spline/b1_clt_gre_bs_cr_fermi_spline.mnc'])
% system(['spline_smooth -verbose -distance 60 -lambda 2.5119e-06 -mask t1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc b1_whole_brain/b1_epseg_da.mnc b1_spline/b1_epseg_da_spline.mnc'])
% 
% %%
% %
% 
% [~, blur{1}]=niak_read_minc('b1_blur/b1_clt_tse_blur.mnc');
% [~, blur{2}]=niak_read_minc('b1_blur/b1_clt_afi_blur.mnc');
% [~, blur{3}]=niak_read_minc('b1_blur/b1_clt_gre_bs_cr_fermi_blur.mnc');
% [~, blur{4}]=niak_read_minc('b1_blur/b1_epseg_da_blur.mnc');
% 
% [~, spline{1}]=niak_read_minc('b1_spline/b1_clt_tse_spline.mnc');
% [~, spline{2}]=niak_read_minc('b1_spline/b1_clt_afi_spline.mnc');
% [~, spline{3}]=niak_read_minc('b1_spline/b1_clt_gre_bs_cr_fermi_spline.mnc');
% [~, spline{4}]=niak_read_minc('b1_spline/b1_epseg_da_spline.mnc');
% 
% [~,mask]=niak_read_minc('t1_whole_brain/t1_clt_vfa_spoil_b1_clt_tse_mask.mnc');
% 
% 
% for ii=1:4
%     figure(),imagesc(blur{ii}.*mask),caxis([0.7 1.2])
%     figure(),imagesc(spline{ii}.*mask),caxis([0.7 1.2])
% end
% 
% %% Fit T1 maps
% %
% 
% mkdir t1_blur
% mkdir t1_spline
% 
% % VFA Optimum Spoil Blur
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_blur/b1_clt_afi_blur.mnc', 't1_blur/t1_clt_vfa_spoil_b1_clt_afi_blur', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_blur/b1_clt_tse_blur.mnc', 't1_blur/t1_clt_vfa_spoil_b1_clt_tse_blur', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_blur/b1_epseg_da_blur.mnc', 't1_blur/t1_clt_vfa_spoil_b1_epseg_da_blur', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_blur/b1_clt_gre_bs_cr_fermi_blur.mnc', 't1_blur/t1_clt_vfa_spoil_b1_clt_bs_blur', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% % VFA Optimum Spoil Spline
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_spline/b1_clt_afi_spline.mnc', 't1_spline/t1_clt_vfa_spoil_b1_clt_afi_spline', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_spline/b1_clt_tse_spline.mnc', 't1_spline/t1_clt_vfa_spoil_b1_clt_tse_spline', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_spline/b1_epseg_da_spline.mnc', 't1_spline/t1_clt_vfa_spoil_b1_epseg_da_spline', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
% !rm VFA_3.mnc
% !rm VFA_20.mnc
% fitDataVFA_es (subjectID, clt_vfa_spoilID, 'b1_spline/b1_clt_gre_bs_cr_fermi_spline.mnc', 't1_spline/t1_clt_vfa_spoil_b1_clt_bs_spline', [subjectID, '_', num2str(structID), '_mri_reg_resamp_es.mnc']) 
% 
