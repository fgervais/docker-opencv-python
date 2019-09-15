# Python, OpenCV and NumPy for the Raspberry PI 4

## Setup binfmt

```
docker run --privileged docker/binfmt:66f9012c56a8316f9244ffd7622d7c21c1f6f28d-amd64
```
If it worked, this should print something:
```
cat /proc/sys/fs/binfmt_misc/qemu-arm
enabled
interpreter /usr/bin/qemu-arm
flags: OCF
offset 0
magic 7f454c4601010100000000000000000002002800
mask ffffffffffffff00fffffffffffffffffeffffff
```

## Create a builder instance

```
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name mybuilder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use mybuilder
```

## Build

```
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --platform linux/arm/v7 -t opencv-4.1.1 --load .
```

At some point you should get
> [+] Building 3061.7s (18/18) FINISHED

## Run

docker run --rm -it --device /dev/video0 francoisgervais/opencv-python:4.1.1 bash
