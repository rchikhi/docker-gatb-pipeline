FROM debian:wheezy
MAINTAINER Rayan Chikhi, rayan.chikhi@ens-cachan.org

ENV PACKAGES wget r-base-core g++ make bc zlib1g-dev bzip2 python-dev 

# BESST requires the following python modules: scipy, networkx, pysam, mathstats
# (see https://github.com/ksahlin/BESST/blob/master/setup.py)
ENV PACKAGES_BESST python-scipy python-networkx python-pip

ENV TAR_GATB http://gatb-pipeline.gforge.inria.fr/versions/bin/gatb-pipeline-1.122.tar.gz
ENV DIR /tmp/gatb-pipeline

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES}

RUN apt-get install -y --no-install-recommends ${PACKAGES_BESST}

RUN rm -rf /var/lib/apt/lists/*

#... Needed for BESST

RUN pip install -i https://pypi.binstar.org/pypi/simple mathstats
RUN pip install pysam

RUN mkdir ${DIR}

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
    wget ${TAR_GATB} -O - | tar xzf - --directory . --strip-components=1 &&\
    make && \
    mv * /usr/local/bin


ADD Procfile /
ADD run /usr/local/bin/

ENTRYPOINT ["run"]
