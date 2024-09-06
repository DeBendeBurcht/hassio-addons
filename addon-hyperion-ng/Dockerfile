ARG BUILD_FROM

FROM ${BUILD_FROM}
ARG BUILD_VERSION=PR-1763
ARG GITHUB_TOKEN
ARG DOWNLOAD_URL=https://api.github.com/repos/hyperion-project/hyperion.ng/actions/artifacts/10539641052/zip
ARG BUILD_ARCH

ENV LANG C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
		libqt5widgets5 \
		libqt5serialport5 \
		libqt5sql5-sqlite \
		libqt5x11extras5 \
		libavahi-core7 \
		libavahi-compat-libdnssd1 \
		libusb-1.0-0 \
		libjpeg-dev \
		libssl1.1 \
		zlib1g \
		libcec6 \
		wget \
		v4l-utils \
	&& rm -rf /var/lib/apt/lists/*
COPY run.sh /
RUN chmod a+x /run.sh

# Authenticate and download the artifact
RUN wget --header="Authorization: token ${GITHUB_TOKEN}" \
    -q "${DOWNLOAD_URL}" -O /tmp/hyperion_artifact.zip && \
    unzip /tmp/hyperion_artifact.zip -d /usr

VOLUME /config
EXPOSE 8090 8092 19333 19400 19444 19445
CMD [ "/run.sh" ]
