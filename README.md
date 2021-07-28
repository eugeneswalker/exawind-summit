## Run on Summit

1. Connect to Summit and change directory to $HOME
```
$> ssh summit
$login> cd
```

2. Fetch the ExaWind Singularity image
```
$login:~/> wget https://cache.e4s.io/exawind-summit-2021-07-27.sif
```

3. Clone this repository
```
$login:~/> git clone https://github.com/eugeneswalker/exawind-summit
$login:~/> cd exawind-summit
```

4. Request an interactive session with two GPU nodes
```
$login:~/exawind-summit> ./bsub-summit.sh
Job <1214764> is submitted to default queue <batch>.
<<Waiting for dispatch ...>>
<<Starting on batch3>>
```

5. Set environment variables $RUNDIR and $SIMG. $RUNDIR must be a path that is writeable from the compute nodes.
```
$batch3:~/exawind-summit> export RUNDIR=<path-writeable-from-compute-nodes>
$batch3:~/exawind-summit> export SIMG=$HOME/exawind-summit-2021-07-27.sif
$batch3:~/exawind-summit> ./run-summit.sh
...

==============================================================================
                AMR-Wind (https://github.com/exawind/amr-wind)

  AMR-Wind version :: 033f21a
  AMR-Wind Git SHA :: 033f21a1284cde4829a3ef8c4965f5c44b324038
  AMReX version    :: 21.07-40-g91fa2b7e6ff3

  Exec. time       :: Wed Jul 28 15:10:18 2021
  Build time       :: Jul 26 2021 13:54:15
  C++ compiler     :: GNU 7.4.0

  MPI              :: ON    (Num. ranks = 8)
  GPU              :: ON    (Backend: CUDA)
  OpenMP           :: OFF

  Enabled third-party libraries:
    NetCDF    4.7.4
    HYPRE     2.20.0

           This software is released under the BSD 3-clause license.
 See https://github.com/Exawind/amr-wind/blob/development/LICENSE for details.
------------------------------------------------------------------------------

Initializing CUDA...
CUDA initialized with 1 GPU per MPI rank; 8 GPU(s) used in total
MPI initialized with 8 MPI processes
MPI initialized with thread support level 0
AMReX (21.07-40-g91fa2b7e6ff3) initialized
Initializing AMR-Wind ...
Initializing boundary conditions for velocity_mueff
...
```

## Run on UO Cyclops

... TBC
