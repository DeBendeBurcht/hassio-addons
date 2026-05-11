ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG DOWNLOAD_URL
ARG BUILD_VERSION
ARG BUILD_ARCH

ENV LANG C.UTF-8

# Updated package names for Qt6 as required by v22 on Bookworm
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends git cmake build-essential \
    libasound2-dev qt6-base-dev qt6-serialport-dev libqt6sql6-sqlite qt6-svg-dev \
    libusb-1.0-0-dev python3-minimal rpm libcec-dev libxcb-image0-dev libxcb-util0-dev \
    libxcb-shm0-dev libglvnd-dev libxcb-render0-dev libxcb-randr0-dev libxrandr-dev \
    libxrender-dev libavahi-core-dev libavahi-compat-libdnssd-dev \
    libjpeg-dev libturbojpeg0-dev libssl-dev zlib1g-dev ca-certificates curl wget dialog apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /
RUN chmod a+x /run.sh

# The fix: Explicitly use "22.0.0beta2" for the filename to match the asset list
# while keeping "v22.0.0.0beta2" for the folder path.
RUN wget -q "${DOWNLOAD_URL}/v${BUILD_VERSION}/HyperHDR-22.0.0beta2-Linux-$(uname -m).tar.gz" -O - | tar -xvz -C /usr

VOLUME /config
EXPOSE 8090 8092 19333 19400 19444 19445
RUN echo 'Running webUI on port 8090. Port 19444-19445 exposed for json, protobuffer server (screen-cap)'
CMD [ "/run.sh" ]
