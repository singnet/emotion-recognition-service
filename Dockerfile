FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        python3.6 \
        python3.6-dev \
        python3-pip \
        python-setuptools \
        cmake \
        wget \
        curl \
        libsm6 \
        libxext6 \ 
        libxrender-dev

COPY requirements.txt /tmp

WORKDIR /tmp

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6
RUN python3.6 -m pip install -r requirements.txt

COPY . /emotion-recognition-service

WORKDIR /emotion-recognition-service

RUN ./install.sh

EXPOSE 6205
EXPOSE 6305

RUN python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. service_spec/EmotionService.proto

CMD ["python3.6", "run-snet-service.py","--daemon-config-path-kovan","snet.config.example.kovan.json","--daemon-config-path-mainnet-3","snet.config.example.mainnet-3.json","--daemon-config-path-ropsten","snet.config.example.ropsten.json"]
