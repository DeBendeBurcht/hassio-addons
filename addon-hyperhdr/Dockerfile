ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG DOWNLOAD_URL
ARG BUILD_VERSION
ARG BUILD_ARCH

ENV LANG C.UTF-8

# Dependencies (you already have a good list)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    git cmake build-essential \
    libasound2-dev qtbase5-dev libqt5serialport5-dev libqt5sql5-sqlite libqt5svg5-dev \
    libqt5x11extras5-dev libusb-1.0-0-dev \
    python3-minimal rpm libcec-dev libxcb-image0-dev libxcb-util0-dev libxcb-shm0-dev \
    libglvnd-dev libxcb-render0-dev libxcb-randr0-dev libxrandr-dev libxrender-dev \
    libavahi-core-dev libavahi-compat-libdnssd-dev \
    libjpeg-dev libturbojpeg0-dev libssl-dev zlib1g-dev ca-certificates curl wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY run.sh /
RUN chmod a+x /run.sh

# Install HyperHDR from official .deb
RUN ARCH=$(uname -m) && \
    case ${ARCH} in \
      x86_64)  DEB="amd64" ;; \
      aarch64) DEB="aarch64" ;; \
      armv7l|armv6l) DEB="armhf" ;; \
      *) echo "Unsupported arch: ${ARCH}"; exit 1 ;; \
    esac && \
    wget -q "${DOWNLOAD_URL}/v${BUILD_VERSION}/HyperHDR-${BUILD_VERSION}~bookworm~beta2-${DEB}.deb" \
         -O /tmp/hyperhdr.deb || \
    wget -q "${DOWNLOAD_URL}/v${BUILD_VERSION}/HyperHDR-${BUILD_VERSION}-Linux-${DEB}.deb" \
         -O /tmp/hyperhdr.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends /tmp/hyperhdr.deb && \
    rm /tmp/hyperhdr.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME /config
EXPOSE 8090 8092 19333 19400 19444 19445
RUN echo 'Running webUI on port 8090. Port 19444-19445 exposed for json, protobuffer server (screen-cap)'
CMD [ "/run.sh" ]
