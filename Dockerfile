FROM debian:wheezy
MAINTAINER Rayan Chikhi, rayan.chikhi@ens-cachan.org

ENV PACKAGES wget python r-base-core g++ make bc zlib1g-dev
ENV TAR http://gatb-pipeline.gforge.inria.fr/versions/bin/gatb-pipeline-1.91.tar.gz
ENV DIR /tmp/gatb-pipeline

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir ${DIR}
RUN cd ${DIR} &&\
    wget ${TAR} -O - | tar xzf - --directory . --strip-components=1 &&\
    make && \
    mv * /usr/local/bin

RUN wget http://mirrors.kernel.org/ubuntu/pool/main/e/eglibc/libc6_2.15-0ubuntu10.9_amd64.deb && dpkg -x libc6_2.15-0ubuntu10.9_amd64.deb /root 

ENV LD_LIBRARY_PATH /root/lib/x86_64-linux-gnu/

ADD Procfile /
ADD run /usr/local/bin/

ENTRYPOINT ["run"]
