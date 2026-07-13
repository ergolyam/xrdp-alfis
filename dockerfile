ARG VERSION=v0.9.0

FROM docker.io/rust:1.97.0-alpine3.24 AS builder

ARG VERSION

RUN apk add --no-cache \
    pkgconf \
    fontconfig-dev \
    libcap-utils

WORKDIR /build

RUN wget -O- https://github.com/Revertron/Alfis/archive/refs/tags/${VERSION}.tar.gz | tar xzf - --strip-components=1

ENV RUSTFLAGS="-C target-feature=-crt-static"
RUN cargo build --release && \
    mv ./target/release/alfis /alfis && \
    mv ./alfis.toml /alfis.toml && \
    setcap cap_net_bind_service=+ep /alfis && \
    rm -rf /build


FROM ghcr.io/ergolyam/xrdp-docker:alpine-3.24 AS main

RUN apk add --no-cache \
    libxkbcommon-x11 \
    libxi \
    ttf-dejavu \
    tk

COPY --from=builder /alfis /usr/local/bin/alfis
COPY --from=builder /alfis.toml /usr/share/alfis/alfis.toml

COPY rootfs /
