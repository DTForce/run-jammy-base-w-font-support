FROM paketobuildpacks/run-jammy-base:0.1.113

ARG RUN_PACKAGES="libfreetype6 fontconfig"

# use the root user to enable privileged actions
USER 0:0

RUN apt update && \
    apt -y install $RUN_PACKAGES && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt -y install ttf-mscorefonts-installer && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# back to standard low-privilege cnb user
USER cnb
