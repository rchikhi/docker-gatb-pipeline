GATB-Pipeline 
=====

Docker image for the GATB-pipeline assembler

### Sample commands:

You can take example from the following commands to build and run the GATB-pipeline assembler container.

To build the docker image:

    docker build -t gatb/gatb-pipeline .

Then define the following 2 directories:

    export dir1=...  # where your input data are located on the host machine
                     # (this directory will be mounted inside the container 
                     # as /inputs)

    export dir2=...  # where you want to mount the container run directory
                     # on your host machine (for runtime monitoring)

Finally, launch the run:

    docker run -it --rm -v $dir1:/inputs -v $dir2:/tmp/gatb-pipeline gatb/gatb-pipeline SRR531199 /inputs /tmp/gatb-pipeline

where *SRR531199* is the codename of your experiment (see Procfile).

### CAMI version

#### Build command
	docker build  -t cami-gatb-pipeline .

#### Test task
In the following command, a small example embedded in the GATB pipeline tarfile is used. No external input/output data are used. However, input and output interfaces must be bounded (due to the CAMI interface).

	docker run --rm -it \
    	-v /tmp:/dckr/mnt/input \
	    -v /tmp:/dckr/mnt/output \
    	cami-gatb-pipeline test

#### Default task
The default task handles the *Low_Complexity_Test_Dataset* dataset ([see the CAMI datasets here](https://data.cami-challenge.org/participate)).

	docker run --rm -it \
    	-v /path/to/30_genomes:/dckr/mnt/input:ro \
	    -v /path/to/30_genomes_output:/dckr/mnt/output:rw \
    	cami-gatb-pipeline
    	
Note that you can append either the *default* keyword or *Low_Complexity_Test_Dataset* to the above command, the same command is launched.
	
#### Other tasks

*In progress.*
