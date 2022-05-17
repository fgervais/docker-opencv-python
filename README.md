# Python, OpenCV and NumPy for the Raspberry PI 4

## Setup binfmt

```
docker run --privileged --rm tonistiigi/binfmt:qemu-v6.2.0 --install all
```
If it worked, this should print something:
```
docker run --privileged --rm tonistiigi/binfmt:qemu-v6.2.0

{
  "supported": [
    "linux/amd64",
    "linux/arm64",
    "linux/riscv64",
    "linux/ppc64le",
    "linux/s390x",
    "linux/386",
    "linux/mips64le",
    "linux/mips64",
    "linux/arm/v7",
    "linux/arm/v6"
  ],
  "emulators": [
    "qemu-aarch64",
    "qemu-arm",
    "qemu-mips64",
    "qemu-mips64el",
    "qemu-ppc64le",
    "qemu-riscv64",
    "qemu-s390x"
  ]
}
```

## Create a builder instance

```
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx create --name mybuilder
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx use mybuilder
```

## Build

```
DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --platform linux/arm/v7 -t ${PWD##*/}:4.3.0-py310 --load .
```

At some point you should get
> [+] Building 4138.3s (19/19) FINISHED

## Run

docker run --rm -it --device /dev/video0 francoisgervais/opencv-python:4.3.0-py310 bash
