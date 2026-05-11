ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG DOWNLOAD_URL
# Updated to match the beta2 release string
ARG BUILD_VERSION="22.0.0"
ARG BETA_SUFFIX="beta2"
ARG BUILD_ARCH

ENV LANG C.UTF-8

# Dependencies for Debian Bookworm (required for Qt6)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    git cmake build-essential \
    libasound2-dev qt6-base-dev qt6-serialport-dev libqt6sql6-sqlite qt6-svg-dev \
    libusb-1.0-0-dev python3-minimal rpm libcec-dev libxcb-image0-dev libxcb-util0-dev \
    libxcb-shm0-dev libglvnd-dev libxcb-render0-dev libxcb-randr0-dev libxrandr-dev \
    libxrender-dev libavahi-core-dev libavahi-compat-libdnssd-dev \
    libjpeg62-turbo-dev libturbojpeg0-dev libssl-dev zlib1g-dev ca-certificates curl wget dialog apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /
RUN chmod a+x /run.sh

# Logic to match the Bookworm-specific filenames from your list
# Example: HyperHDR-22.0.0~bookworm~beta2-x86_64.tar.gz
RUN ARCH_NAME=$(uname -m); \
    FULL_URL="${DOWNLOAD_URL}/v${BUILD_VERSION}${BETA_SUFFIX}/HyperHDR-${BUILD_VERSION}~bookworm~${BETA_SUFFIX}-${ARCH_NAME}.tar.gz"; \
    echo "Downloading from: ${FULL_URL}"; \
    wget -q "$FULL_URL" -O /tmp/hyperhdr.tar.gz \
    && tar -xvz -f /tmp/hyperhdr.tar.gz -C / \
    && rm /tmp/hyperhdr.tar.gz

VOLUME /config
EXPOSE 8090 8092 19333 19400 19444 19445

RUN echo 'Running webUI on port 8090.'
CMD [ "/run.sh" ]
