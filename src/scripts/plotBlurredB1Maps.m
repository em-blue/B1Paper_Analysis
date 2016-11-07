%% plotBlurredB1Maps
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

maskFile = 'brain_mask_es_2x2x5.mnc';

subjectIDs = dirs2cells(dataDir);
numSubjects = size(subjectIDs,1);

%%
%

oldDir = cd;

for counterSubject = 1:numSubjects
    cd([dataDir '/' subjectIDs{counterSubject}])

    [~, b1{1}]=niak_read_minc('b1_whole_brain/b1_clt_tse.mnc');
    [~, b1{2}]=niak_read_minc('b1_whole_brain/b1_clt_afi.mnc');
    [~, b1{3}]=niak_read_minc('b1_whole_brain/b1_clt_gre_bs_cr_fermi.mnc');
    [~, b1{4}]=niak_read_minc('b1_whole_brain/b1_epseg_da.mnc');


    [~, blur{1}]=niak_read_minc('b1_gauss/b1_clt_tse.mnc');
    [~, blur{2}]=niak_read_minc('b1_gauss/b1_clt_afi.mnc');
    [~, blur{3}]=niak_read_minc('b1_gauss/b1_clt_gre_bs_cr_fermi.mnc');
    [~, blur{4}]=niak_read_minc('b1_gauss/b1_epseg_da.mnc');

    [~,mask]=niak_read_minc(maskFile);
    
    mask = logical(mask);
    
    for ii = 1:length(b1)
        figure(counterSubject*100 + ii),imagesc(cat(1, imrotate(b1{ii}.*mask,-90) , imrotate(blur{ii}.*mask,-90))), caxis([0.7 1.2]), colormap(jet),  axis image
    end
end

cd(oldDir)