#!/bin/sh
set -e


export MATLABPATH=../NSLtools

matlab -nodisplay -nosplash -nodesktop -r "convert_TIMIT_to_spectras('$1', '$2');exit;"
