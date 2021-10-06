## ExaWind Containerized Examples for OLCF Summit

**Table of Contents**
1. Running the Dual-node Amr-Wind GPU Example on OLCF Summit
2. Running the Single-node Nalu-Wind CPU Example on OLCF Summit
3. Building the Docker image
4. Building the Singularity image

### 1. Running the Dual-node Amr-Wind GPU Example on OLCF Summit

1. Clone this repo
```
[<user>@login4.summit ~] git clone https://github.com/eugeneswalker/exawind-summit
[<user>@login4.summit ~] cd exawind-summit
```

2. Decide where you want output files to go. Choose a path on a filesystem writable from compute nodes
```
[<user>@login4.summit exawind-summit] export RUNDIR=$MEMBERWORK/gen010/exawind-run
```

3. Run the example

* Interactive
```
[<user>@login4.summit exawind-summit] bsub -Is -P <PROJECT_ID>  -W 2:00 -nnodes 2 -alloc_flags gpudefault /bin/bash
bash-4.4$ ./run-amrwind-summit.sh
...
```

* Non-interactive
```
[<user>@login4.summit exawind-summit] head -2 run-amrwind-summit.lsf
#!/bin/bash
#BSUB -P GEN010  <-- EDIT THIS LINE, USE YOUR PROJECT CODE

[<user>@login4.summit exawind-summit] bsub run-amrwind-summit.lsf
```

### 2. Running the Single-node Nalu-Wind CPU Example on OLCF Summit

1. Clone this repo
```
[<user>@login4.summit ~] git clone https://github.com/eugeneswalker/exawind-summit
[<user>@login4.summit ~] cd exawind-summit
```

2. Decide where you want output files to go. Choose a path on a filesystem writable from compute nodes
```
[<user>@login4.summit exawind-summit] export RUNDIR=$MEMBERWORK/gen010/exawind-run
```

3. Run the example

* Interactive
```
[<user>@login4.summit exawind-summit] bsub -Is -P <PROJECT_ID>  -W 2:00 -nnodes 1 /bin/bash
bash-4.4$ ./run-naluwind-summit.sh
...
```

### 3. Building the Docker image

1. Clone this repo
```
$> git clone https://github.com/eugeneswalker/exawind-summit
$> cd exawind-summit
```

2. Run the Docker build script
```
$exawind-summit> ./build-docker.sh
```

### 4. Build the Singularity image
1. Clone this repo
```
$> git clone https://github.com/eugeneswalker/exawind-summit
$> cd exawind-summit
```

2. Run the Singularity build script
```
$exawind-summit> ./build-singularity.sh
```
