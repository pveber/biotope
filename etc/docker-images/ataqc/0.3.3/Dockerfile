FROM pveber/bistro-base:stretch

RUN \
  apt-get update && \
  apt-get install -y python-pip zlib1g-dev samtools bedtools picard-tools \
                     libgsl-dev default-libmysqlclient-dev libssl-dev \
                     libpng-dev

RUN wget https://raw.githubusercontent.com/pveber/compbio-scripts/master/kent-tree-install/330/kent-tree-install.sh -O - | bash -s /usr

RUN pip install numpy
RUN pip install pybedtools pysam metaseq jinja2

RUN \
  wget https://github.com/smithlabcode/preseq/releases/download/v2.0.2/preseq_v2.0.2.tar.bz2 && \
  tar xfj preseq_v2.0.2.tar.bz2 && \
  cd preseq_v2.0.2 && \
  make && \
  make install PREFIX=/usr

RUN \
  git clone https://github.com/pveber/ataqc && \
  cd ataqc && \
  chmod a+x run_ataqc.py && \
  cp run_ataqc.py /usr/bin

RUN \
  wget https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2 && \
  tar xfj samtools-1.2.tar.bz2 && \
  cd samtools-1.2 && \
  make && \
  make install

ENV PICARDROOT /usr/share/java
