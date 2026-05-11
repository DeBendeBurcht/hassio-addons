ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG DOWNLOAD_URL
ARG BUILD_VERSION
ARG BUILD_ARCH

ENV LANG C.UTF-8

# Updated package names from Qt5 to Qt6 for Debian Bookworm
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

# Target the generic Linux-x86_64 tarball from your list. 
# Extract to / instead of /usr because the v22 tarball already contains its own 'usr/' folder.
RUN wget -q "${DOWNLOAD_URL}/v${BUILD_VERSION}/HyperHDR-${BUILD_VERSION}-Linux-$(uname -m).tar.gz" -O - | tar -xvz -C /

VOLUME /config
EXPOSE 8090 8092 19333 19400 19444 19445
RUN echo 'Running webUI on port 8090. Port 19444-19445 exposed for json, protobuffer server (screen-cap)'
CMD [ "/run.sh" ]
