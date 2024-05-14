#!/bin/bash
set -e


export MATLABPATH=../spm12

#Executable
matlab -nodisplay -nosplash -nodesktop -r "run('run_dem.m');exit;"
