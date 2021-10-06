## Amr-Wind Containerized GPU Examples for OLCF Summit

**Table of Contents**
1. Running the Dual-node GPU Example on OLCF Summit
2. Building the Docker image
3. Building the Singularity image

### 1. Running the Dual-Node GPU Example on OLCF Summit

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
[<user>@login4.summit exawind-summit] bsub -Is -P GEN010  -W 2:00 -nnodes 2 -alloc_flags gpudefault /bin/bash
[<user>@login4.summit exawind-summit] ./run-amrwind-summit.sh
...
```

* Non-interactive
```
[<user>@login4.summit exawind-summit] bsub run-amrwind-summit.lsf
```

### 2. Building the Docker image

1. Clone this repo
```
$> git clone https://github.com/eugeneswalker/exawind-summit
$> cd exawind-summit
```

2. Run the Docker build script
```
$exawind-summit> ./build-docker.sh
```

### 3. Build the Singularity image
1. Clone this repo
```
$> git clone https://github.com/eugeneswalker/exawind-summit
$> cd exawind-summit
```

2. Run the Docker build script
```
$exawind-summit> ./build-singularity.sh
```
