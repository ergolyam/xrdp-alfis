# xrdp-alfis
This project provides a **tiny image that boots straight into an XRDP + IceWM session** and then immediately launches the **Alfis** graphical interface in a maximised window.
It is a ready-made remote desktop for running an [Alfis](https://github.com/Revertron/Alfis) node, built on top of [`xrdp-docker`](https://github.com/ergolyam/xrdp-docker).

Alfis (Alternative Free Identity System) combines a peer-to-peer domain database with a DNS resolver and a graphical interface for creating and managing domains.

## Usage

- Pull image:
    ```bash
    docker pull ghcr.io/ergolyam/xrdp-alfis:latest
    ```

- Run container:
    ```bash
    docker run -p 3389:3389 \
        -p 4244:4244 \
        -e USER=demo -e PASSWD=secret \
        -v $PWD/data:/data \
        ghcr.io/ergolyam/xrdp-alfis:latest
    ```
    - Mounting `/data` keeps the Alfis configuration, blockchain database and keys across restarts.
    - Publishing `4244/tcp` allows other Alfis nodes to connect to your node. Alfis can still make outgoing peer connections if this port is not published.

- Run with ssl keys:
    ```bash
    openssl req -x509 -newkey rsa:2048 -nodes -keyout /path/to/key.pem -out /path/to/cert.pem -days 365
    ```
    ```bash
    docker run -p 3389:3389 \
        -p 4244:4244 \
        -e USER=demo -e PASSWD=secret \
        -v $PWD/data:/data \
        -v /path/to/key.pem:/key.pem:ro \
        -v /path/to/cert.pem:/cert.pem:ro \
        ghcr.io/ergolyam/xrdp-alfis:latest
    ```

- Now connect to **`localhost:3389`** with any RDP client (username **demo**, password **secret**). You will land in the Alfis interface; when Alfis exits, the RDP session ends.

## Environment Variables

This image supports all base variables documented in [`xrdp-docker`](https://github.com/ergolyam/xrdp-docker?tab=readme-ov-file#environment-variables).

There are no additional image-specific environment variables. Alfis itself is configured through `/data/alfis.toml`.

## Persistent Data

On the first start, the default Alfis configuration is copied to `/data/alfis.toml`. Alfis then uses `/data` as its working directory, so mounting this directory preserves:

- the configuration in `/data/alfis.toml`
- the synchronized blockchain database in `/data/blockchain.db`
- generated or imported key files saved under `/data`

The container updates ownership of `/data` for the RDP user on every start.

## DNS Access

By default, the Alfis DNS resolver listens only on `127.0.0.3:53` inside the container and is not available to the host or other machines.

To expose it, stop the container and change the following setting in `/data/alfis.toml`:

```toml
[dns]
listen = "0.0.0.0:53"
```

Then add `-p 53:53/tcp -p 53:53/udp` to your `docker run` command to publish both DNS protocols.

Make sure port 53 is not already used on the Docker host before publishing it.

## Features

- **No VNC hop**: uses `xrdp` + `xorgxrdp`; clients see a native RDP server on port 3389.
- **Alfis GUI over RDP**: create and manage alternative domains without installing a desktop application locally.
- **Persistent node state**: mount `/data` to keep the configuration, synchronized blockchain and keys across runs.
- **Light and dark themes**: set `DARK_MODE=true` when creating the initial configuration to keep the default Alfis dark theme.
- **Optional keyboard layout switcher**: set `XKBMAP_LAYOUT=ru`; by default `Super + Space` toggles between `us` and `ru`.
