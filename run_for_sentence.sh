#!/bin/bash
set -e


export MATLABPATH=../spm12


echo "RUN FOR DATASET:"
echo "    $1"
echo "    $2"
echo "    $3"

#Executable
matlab -nodisplay -nosplash -nodesktop -r "run_for_sentence('$1', '$2', '$3');exit;"
