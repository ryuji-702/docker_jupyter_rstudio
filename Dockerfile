FROM ubuntu:18.04
RUN apt-get update -y \
    && apt-get upgrade -y && \
    apt-get install -y curl wget sudo ca-certificates 

ENV SHELL=/bin/bash

RUN curl -sL https://deb.nodesource.com/setup_12.x |bash - \
    && apt-get install -y --no-install-recommends \
    git \
    vim \
    make \
    cmake \
    nodejs \
    python3.8 \
    python3-pip \
    fonts-liberation \
    run-one \
    libxss1 \
    xdg-utils \
    software-properties-common \
    && apt-get autoremove -y \
    && apt-get clean &&\
    rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /usr/local/src/* \
        /tmp/*
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# install python library
COPY requirements.txt .
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt \
    && rm -rf ~/.cache/pip

# install jupyterlab & extentions
RUN pip3 install --upgrade --no-cache-dir setuptools
RUN pip3 install --upgrade --no-cache-dir \
    'jupyterlab==3.0.14' \
    "jupyterlab-kite>=2.0.2" \
    'jupyterlab_code_formatter==1.4.10' \
    'yapf==0.31.0' \
    'ipywidgets==7.6.3' \
    && rm -rf ~/.cache/pip \
    && jupyter labextension install \
      @hokyjack/jupyterlab-monokai-plus \
      @ryantam626/jupyterlab_code_formatter \
    && jupyter serverextension enable --py jupyterlab_code_formatter

# install jupyter-kite
RUN wget https://linux.kite.com/dls/linux/current && \
    chmod 777 current && \
    sed -i 's/"--no-launch"//g' current > /dev/null && \
    ./current --install ./kite-installer
RUN mkdir /home/download
RUN cd /home/download
#install variableinspector
RUN wget https://github.com/lckr/jupyterlab-variableInspector/archive/refs/tags/v3.0.6.tar.gz
RUN pip install v3.0.6.tar.gz

WORKDIR /home/work/
