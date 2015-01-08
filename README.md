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
