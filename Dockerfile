ARG OPENCV_VERSION=4.3.0
ARG NUMPY_VERSION=1.18.4

FROM python:3.8.3-slim-buster AS base

FROM base as build
ARG OPENCV_VERSION
ARG NUMPY_VERSION
RUN apt-get update && apt-get -y install --no-install-recommends \
	build-essential \
	cmake \
	gfortran \
	libjpeg-dev \
	libatlas-base-dev \
	libavcodec-dev \
	libavformat-dev \
	libgtk2.0-dev \
	libgtk-3-dev \
	libswscale-dev \
	libtiff-dev \
	libv4l-dev \
	libx264-dev \
	libxvidcore-dev \
	pkg-config \
	wget
RUN pip wheel numpy==${NUMPY_VERSION}
RUN pip install numpy-*.whl
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz && \
	tar xf ${OPENCV_VERSION}.tar.gz
WORKDIR /opencv-${OPENCV_VERSION}/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=_install \
	-D BUILD_TESTS=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D BUILD_EXAMPLES=OFF .. && \
	make -j16
RUN make install


FROM base
ARG OPENCV_VERSION
RUN apt-get update && apt-get -y install --no-install-recommends \
	libatlas3-base \
	libavcodec58 \
	libavformat58 \
	libgtk-3-0 \
	libswscale5 \
&& rm -rf /var/lib/apt/lists/*
COPY --from=build /numpy-*.whl /
RUN pip install numpy-*.whl
COPY --from=build /opencv-${OPENCV_VERSION}/build/_install/ /usr/local/
RUN ldconfig
