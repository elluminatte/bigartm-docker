FROM ipython/scipystack
MAINTAINER Oleksandr Frei <oleksandr.frei@gmail.com>

RUN apt-get update -y
RUN apt-get install -y cmake libboost-all-dev wget
RUN apt-get install python3-pip -y
RUN pip2 install tqdm
RUN pip3 install tqdm

RUN git clone --branch v0.8.2 --depth=1 https://github.com/bigartm/bigartm.git
WORKDIR bigartm

RUN mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. && make -j && make install

RUN cd 3rdparty/protobuf-3.0.0/python && python2 setup.py build && python2 setup.py install
RUN cd 3rdparty/protobuf-3.0.0/python && python3 setup.py build && python3 setup.py install
RUN cd python && python2 setup.py install
RUN cd python && python3 setup.py install

WORKDIR /usr/lib/python3/dist-packages

RUN apt-get remove -y python-tornado
RUN rm -rf tornado-3.1.1.egg-info && rm -rf tornado

RUN pip2 install tornado --upgrade --ignore-installed
RUN pip3 install tornado --upgrade --ignore-installed

ENV ARTM_SHARED_LIBRARY=/tmp/bigartm/build/lib/libartm.so
