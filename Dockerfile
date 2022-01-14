FROM ubuntu:20.04

RUN apt-get update && apt-get install -y curl locales locales-all apt-utils && rm -rf /var/lib/apt/lists/* \
    && yes | unminimize
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en

RUN set -eux \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update \
    && apt-get install -y \
       fuse wget unzip git \
       python3.8 python3.8-dev python3-pip nodejs yarn\
    && /usr/bin/env python3 -m pip install --upgrade pip \
    && rm -rf /root/.cache/pip \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=testuser
ARG USER_HOME=/home/${USERNAME}
ENV USERNAME=${USERNAME} USER_HOME=${USER_HOME}
ENV PATH="$USER_HOME/bin:${PATH}"

RUN mkdir -p $USER_HOME/bin $USER_HOME/.config/nvim\
    && useradd --home $USER_HOME $USERNAME \
    && chown -R ${USERNAME}.${USERNAME} ${USER_HOME}

COPY nvim-init.lua ${USER_HOME}/.config/nvim/init.lua
WORKDIR ${USER_HOME}

RUN wget https://github.com/neovim/neovim/releases/download/v0.6.1/nvim.appimage \
    && chmod +x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && mv squashfs-root bin/nvim.app \
    && ln -s nvim.app/usr/bin/nvim bin/nvim \
    && nvim --headless -c q  # install packer

COPY entrypoint.sh /

USER ${USERNAME}

CMD '/entrypoint.sh'
