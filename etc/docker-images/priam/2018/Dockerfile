FROM pveber/ncbi-blast:2.4.0

RUN mkdir -p /PRIAM/bin && mkdir -p /PRIAM/data
RUN (cd /PRIAM/bin && wget http://priam.prabi.fr/utilities/PRIAM_search.jar)
RUN apt-get update && apt-get install -y default-jre
