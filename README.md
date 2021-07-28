## Run on Summit

```
$login> ./bsub-summit.sh
Job <1214764> is submitted to default queue <batch>.
<<Waiting for dispatch ...>>
<<Starting on batch3>>

$batch> git clone https://github.com/eugeneswalker/exawind-summit
$batch> cd exawind-summit
$batch> export RUNDIR=<writable-path-for-post-processing-data>
$batch> export SIMG=<path-to-exawind-summit-2021-07-27.sif>
$batch> ./run-summit.sh
...
```

## Run on UO Cyclops

... TBC
