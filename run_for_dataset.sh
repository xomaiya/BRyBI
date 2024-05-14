#!/bin/bash
set -e


export MATLABPATH=../spm12


echo "RUN FOR DATASET:"
echo "    $1"
echo "    $2"

#Executable
matlab -nodisplay -nosplash -nodesktop -r "run_for_dataset('$1', '$2');exit;"
