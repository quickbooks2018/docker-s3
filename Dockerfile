FROM python:slim
LABEL org.opencontainers.image.authors="info@cloudgeeks.ca"

# Set user and group
ENV USER='s3'
ENV GROUP='s3'
ENV UID='1000'
ENV GID='1000'

WORKDIR /home/${USER}

# Update and install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update --fix-missing && \
    apt-get install -y supervisor automake autotools-dev g++ git libcurl4-gnutls-dev wget libfuse-dev libssl-dev libxml2-dev make pkg-config

# Clone and run s3fs-fuse
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git /tmp/s3fs-fuse && \
    cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install && ldconfig && /usr/local/bin/s3fs --version

# Remove packages
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y wget automake autotools-dev g++ git make  && \
    apt-get -y autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



RUN groupadd -g $GID $GROUP && \
    useradd -u $UID -g $GROUP -s /bin/sh -m $USER

# Install fuse
RUN apt-get update   && \
    apt install fuse && \
    chown ${USER}.${GROUP} /usr/local/bin/s3fs

# Config fuse
RUN chmod a+r /etc/fuse.conf && \
    perl -i -pe 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf

# Execute
COPY mount.sh /home/${USER}/mount.sh
RUN chmod +x /home/${USER}/mount.sh

# Supervisor
COPY supervisord.log /home/supervisord.log
COPY supervisord.conf /etc/supervisord.conf
RUN chown ${UID}:${GID} /home/supervisord.log

# Switch to user
USER ${UID}:${GID}

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
