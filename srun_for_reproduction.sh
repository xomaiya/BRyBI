#!/bin/bash
set -e


TIME="00:00:01"
CPUS="40"
MEM="128G"
PARTITION="htc"
#PARTITION="ais-cpu"

DATASET="/home/work/BRyBI/data/dataset"
RESULTS="."

SUB_DATASETS=(
  "cs/350"
  "csbw/1000"
  "cs/325"
  "csbw/950"
  "cs/250"
  "csbw/700"
  "csbw/600"
  "cs/200"
  "csbw/500"
  "cs/150"
  "original"
  "csbw/300"
  "cs/100"
  "csbw/250"
  "cs/75"
  "cs/40"
  "csbw/100"
  "cs/20"
  "comp"
)


for sub_dataset in "${SUB_DATASETS[@]}"
do
    srun --partition $PARTITION --cpus-per-task $CPUS --mem $MEM --time $TIME -- \
        /home/work/BRyBI/model_refactor/run_for_dataset.sh $DATASET/$sub_dataset $RESULTS/$sub_dataset &
done
