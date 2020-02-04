FROM pveber/bistro-base:jessie

RUN \
  apt-get update && apt-get install -y --fix-missing gcc zlib1g-dev

RUN \
  wget -O ms.tar.gz "http://pbil.univ-lyon1.fr/members/veber/ms.tar.gz" && \
  tar xf ms.tar.gz && rm ms.tar.gz #&&
RUN  cd msdir && \
     gcc -O3 -o ms ms.c streec.c rand1.c -lm && cp ms /usr/bin
