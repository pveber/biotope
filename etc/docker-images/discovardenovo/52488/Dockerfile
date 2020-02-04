FROM pveber/bistro-base:jessie

RUN apt-get update && apt-get install -y libjemalloc-dev zlib1g-dev
RUN wget ftp://ftp.broadinstitute.org/pub/crd/DiscovarDeNovo/latest_source_code/discovardenovo-52488.tar.gz && \
    tar xvfz discovardenovo-52488.tar.gz && \
    cd discovardenovo-52488 && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf discovardenovo-52488*
