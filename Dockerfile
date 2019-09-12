# 3.7.3-slim-stretch
FROM python@sha256:006abfb055c5395e1fd5fce9d342155c8c7cf44e3ef0a3e208cb6c8f46c0fc81 AS base

FROM base as build
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
RUN pip wheel numpy==1.17.2
RUN pip install numpy-*.whl
RUN wget https://github.com/opencv/opencv/archive/4.1.1.tar.gz && \
	tar xf 4.1.1.tar.gz
WORKDIR /opencv-4.1.1/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=_install \
	-D ENABLE_NEON=ON \
	-D ENABLE_VFPV3=ON \
	-D BUILD_TESTS=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D BUILD_EXAMPLES=OFF .. && \
	make -j16
RUN make install


FROM base
RUN apt-get update && apt-get -y install --no-install-recommends \
	libatlas3-base \
	libavcodec57 \
	libavformat57 \
	libgtk-3-0 \
	libswscale4 \
&& rm -rf /var/lib/apt/lists/*
COPY --from=build /numpy-*.whl /
RUN pip install numpy-*.whl
COPY --from=build /opencv-4.1.1/build/_install/ /usr/local/
RUN ldconfig
