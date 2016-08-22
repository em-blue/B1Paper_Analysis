# B<sub>1</sub> Paper Analysis

B<sub>1</sub> Paper Analysis is the repository for the data analysis of my B<sub>1</sub> method comparison PhD paper.

MINC is a file format used for medical imaging purposes that was developed at the McConnell Brain Imaging Centre in Montreal.

## Requirements

* MATLAB_R2015b or later

* Python 3.5

* Perl 5

* [MINC Toolkit 1.9.11](http://bic-mni.github.io)
   
     * For more information about the MINC Toolkit, visit the [software website](http://www.bic.mni.mcgill.ca/ServicesSoftware/MINC)
and [wiki](https://en.wikibooks.org/wiki/MINC).

* [BEaST segmentation library](http://bic-mni.github.io/#data-files-and-models)

* [bic-mni-models anatomical template library](http://bic-mni.github.io/#data-files-and-models)

* [FSL (BET)](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
    * Installing FSL requires Python 2.7, use a virtual environment tool such as conda 
      e.g. `conda create --name py27 python=2.7`
      then `source activate py27`

* [NeuroImaging Analysis Kit (NIAK)](https://www.nitrc.org/projects/niak/)

## Installation

All MINC files should be MINC2 format. To verify, `mincinfo -minc_version file.mnc` should return: `Version: 2 (HDF5)`

To convert a single file from MINC1 to MINC2:

`mincconvert -2 oldMinc1File.mnc newMinc2File.mnc`

The repo also contains a Python3 script that will convert all files in the specifies directory from MINC1 to MINC2.

**WARNING** Backup your original files first. All MINC files will be overwritten with MINC2 versions of the files.

The script is `convert_dir_minc1_to_minc2.py` and can be called with `python convert_dir_minc1_to_minc2(dirPath)`.

## Tests

This section was temporarily left empty.

## Usage

This section was temporarily left empty.

## To-Do

Here's a list of the work I will be doing in the near future:

* Add b1_bic_tse.mnc processing to VFA mapping section.

* Process whole-brain VFA T<sub>1</sub> maps with both EPI and AFI B<sub>1</sub> maps

* Add check for MINC2 file formats, probably in a test but maybe in functions as well.

* Compare stock scanner GRE sequence T<sub>1</sub> with VFA opt spoil T<sub>1</sub>

* Write script for IR instead of the mainB1T1qMT script manipulations

    * Also, maybe remove T1 checks since it pauses the processing, or at least add option to remove it?

## About me

**Mathieu Boudreau** is a PhD Candidate at McGill University in the Department of Biomedical Engineering.
He holds a BSc in Physics from the Universite de Moncton ('09), and a MSc in Physics from the University 
of Western Ontario ('11).