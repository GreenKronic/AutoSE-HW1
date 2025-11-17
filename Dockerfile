FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt    

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN git clone https://github.com/pjreddie/darknet &&\
    cd darknet && make &&\
    wget https://data.pjreddie.com/files/yolov3.weights
    
ENTRYPOINT ["/entrypoint.sh"]
