FROM ubuntu:jammy

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    git-lfs \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION="4.3"
ARG GODOT_RELEASE="stable"

RUN curl -L https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE}_linux.x86_64.zip > godot.zip
RUN curl -L https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE}_export_templates.tpz > templates.tpz

RUN unzip godot.zip
RUN unzip templates.tpz

RUN mkdir -vp ~/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE}
RUN mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE}
RUN mv Godot_v${GODOT_VERSION}-${GODOT_RELEASE}_linux.x86_64 /usr/local/bin/godot


RUN rm -R templates/
RUN rm templates.tpz godot.zip