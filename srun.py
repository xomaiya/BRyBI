#!/usr/bin/env python
import subprocess
import time
from datetime import datetime
from pathlib import Path
from subprocess import Popen

TIME = "3-00:00:00"
CPUS = "1"
PARTITION = "normal"

DATASET="../data/dataset/interrupted_speech/0.75/500"
RESULTS="../data/results_interrupted_speech_75_500"


logs_subfolder = f'{datetime.now():%Y-%m-%d_%T}'
logs_folder = Path("../data/logs") / logs_subfolder
logs_folder.mkdir(parents=True)
print('Folder with logs: ', logs_folder)

sentences = set(sentence.name for sentence in Path(DATASET).glob('**/*.mat'))
for sentence in sentences:
    Popen(
        [
            'sbatch',
            '--partition', PARTITION,
            '--cpus-per-task', CPUS,
            '--time', TIME,
            '--output', f'{logs_folder}/%j.stdout',
            '--error', f'{logs_folder}/%j.stderr',
            '--wrap',
            f'./run_for_sentence.sh {DATASET} {RESULTS} {sentence}',
        ],
        stdout=subprocess.DEVNULL,
        # stderr=subprocess.DEVNULL,
        # start_new_session=True,
    )
    time.sleep(1)
