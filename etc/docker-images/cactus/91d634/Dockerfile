FROM pveber/bistro-base:stretch

RUN \
  apt-get update && apt-get install -y g++ wget python 

RUN ln -s /usr/lib/python2.7/plat-*/_sysconfigdata_nd.py /usr/lib/python2.7/

RUN \
  git clone git://github.com/glennhickey/progressiveCactus.git && \
  cd progressiveCactus && \
  git pull && \
  git submodule update --init

RUN apt-get install -y python-dev

RUN \
  apt-get install -y gcc-5 g++-5 && \
  rm /usr/bin/gcc /usr/bin/g++ && \
  ln -s /usr/bin/gcc-5 /usr/bin/gcc && \
  ln -s /usr/bin/g++-5 /usr/bin/g++

RUN \
  cd progressiveCactus && \
  make

