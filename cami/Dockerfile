#FROM debian:wheezy
FROM cami/interface
MAINTAINER Rayan Chikhi, rayan.chikhi@ens-cachan.org

# add interface definition
COPY dockermount.conf /dckr/etc/
COPY list-spec.sh /dckr/etc/tasks.d/--list-spec
COPY print_version.sh /dckr/etc/tasks.d/--version

# Folder optionally containing all data uploaded by the user
ENV DCKR_USERREF $DCKR_MNT/userref

# This variable MUST specify the absolute path, inside the container, of a file containing the absolute paths of gzipped FASTQ files.
ENV CONT_FASTQ_FILE_LISTING $DCKR_MNT/input/sample.fq.gz.list

# This variable MUST specify the absolute path, inside the container, of a file containing the absolute paths of gzipped FASTQ files
ENV CONT_PAIRED_FASTQ_FILE_LISTING $DCKR_MNT/input/sample.interleaved.fq.gz.list

# This variable specifies the absolute path of where the FASTA file containing the contigs can be found
ENV CONT_CONTIGS_FILE $DCKR_MNT/input/contigs.fna

# Note: cmake is needed by DiscoSNP++
ENV PACKAGES wget r-base-core g++ make bc zlib1g-dev bzip2 python-dev cmake

# BESST requires the following python modules: scipy, networkx, pysam, mathstats
# (see https://github.com/ksahlin/BESST/blob/master/setup.py)
ENV PACKAGES_BESST python-scipy python-networkx python-pip

ENV TAR_GATB_PIPELINE_VERSION 1.99
ENV TAR_GATB_PIPELINE http://gatb-pipeline.gforge.inria.fr/versions/bin/gatb-pipeline-$TAR_GATB_PIPELINE_VERSION.tar.gz

ENV TAR_GATB_TOOLS_DISCOSNP http://gatb-tools.gforge.inria.fr/versions/src/DiscoSNP++-2.1.4-Source.tar.gz

ENV TAR_QUAST http://sourceforge.net/projects/quast/files/quast-2.3.tar.gz 

# Note: can't use /tmp in DIR below with cami/interface, since /tmp is declared as VOLUME 
#       (for externally mounted volumes from native host or other containers)
ENV DIR /mytmp/gatb-pipeline

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES}

RUN apt-get install -y --no-install-recommends ${PACKAGES_BESST}

RUN rm -rf /var/lib/apt/lists/*

#... Needed for BESST

RUN pip install -i https://pypi.binstar.org/pypi/simple mathstats
RUN pip install pysam

RUN mkdir -p ${DIR}

#... Install BWA (the older version 0.6.2 may also be installed with apt-get)

ENV TAR_BWA http://sourceforge.net/projects/bio-bwa/files/bwa-0.7.10.tar.bz2

RUN cd ${DIR} && \
    wget ${TAR_BWA} -O - | tar -xj && \
    cd bwa-0.7.10 && \
    make && \
    cp bwa .. && \
    cd .. && \
    rm -rf bwa-0.7.10 && \
    echo '*** BWA compiled ***'


#... Install GATB-Pipeline

RUN cd ${DIR} &&\
    wget ${TAR_GATB_PIPELINE} -O - | tar xzf - --directory . --strip-components=1 &&\
    make && \
    mv * /usr/local/bin

#... Install GATB-Tools DiscoSNP++

RUN cd ${DIR} &&\
    wget ${TAR_GATB_TOOLS_DISCOSNP} -O - | tar xzf - --directory . --strip-components=1 &&\
    ./compile_discoSnp++.sh && \
    mv build/tools/kissnp2/kissnp2 /usr/local/bin && \
    mv build/tools/kissreads/kissreads /usr/local/bin && \
    rm -rf *

#... Install Quast

RUN cd ${DIR} &&\
    wget ${TAR_QUAST} -O - | tar xzf - && \
    mv quast-* /usr/local/bin

COPY test /dckr/etc/tasks.d/test
COPY default /dckr/etc/tasks.d/default
COPY Low_Complexity_Test_Dataset                   /dckr/etc/tasks.d/Low_Complexity_Test_Dataset
COPY Low_Complexity_Test_Dataset_merged            /dckr/etc/tasks.d/Low_Complexity_Test_Dataset_merged
COPY Low_Complexity_Test_Dataset_merged_corrected  /dckr/etc/tasks.d/Low_Complexity_Test_Dataset_merged_corrected
COPY Medium_Complexity_Test_Dataset                /dckr/etc/tasks.d/Medium_Complexity_Test_Dataset
COPY High_Complexity_Test_Dataset                  /dckr/etc/tasks.d/High_Complexity_Test_Dataset

