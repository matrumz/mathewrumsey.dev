ARG PGID=1000
ARG PUID=1000
ARG VARIANT=universal
ARG VERSION=5-linux

#### Base ######################################################################
FROM mcr.microsoft.com/devcontainers/${VARIANT}:${VERSION} AS base

# Manage user and group
ARG PGID
ARG PUID
RUN <<EOT
#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive

# These values are known from inspecting the base image and are not expected to change -- changes would require updating this script
export DEFAULT_UID=1000
export DEFAULT_GID=1000
export DEFAULT_USER="$(id --user --name ${DEFAULT_UID})"
export DEFAULT_GROUP="$(id --group --name ${DEFAULT_GID})"

# Update UID and GID of existing files if alternate IDs provided
## If UID is not default: update UID of existing files
if [ "${PUID}" != "${DEFAULT_UID}" ]; then
    find / -xdev -user ${DEFAULT_UID} -print0 | xargs --null --max-procs $(nproc) --replace={} chown --no-dereference "${PUID}" {}
fi
## If GID is not default: update GID of existing files
if [ "${PGID}" != "${DEFAULT_GID}" ]; then
    find / -xdev -group ${DEFAULT_GID} -print0 | xargs --null --max-procs $(nproc) --replace={} chgrp --no-dereference "${PGID}" {}
fi

# If UID is not default and does not exist: update UID of default user
if [ "${PUID}" != "${DEFAULT_UID}" ] && ! getent passwd "${PUID}"; then
    usermod --uid "${PUID}" "${DEFAULT_USER}"
fi

# If UID is not default and does exist: warn and update UID of default user
if [ "${PUID}" != "${DEFAULT_UID}" ] && getent passwd "${PUID}"; then
    1>&2 echo "WARNING: UID ${PUID} already exists... updating default user with non-unique UID"
    usermod --non-unique --uid "${PUID}" "${DEFAULT_USER}"
fi

# If GID is not default and does not exist: update GID of default user group
if [ "${PGID}" != "${DEFAULT_GID}" ] && ! getent group "${PGID}"; then
    groupmod --gid "${PGID}" "${DEFAULT_GROUP}"
fi

# If GID is not default and does exist: set as users primary group and remove the default user group
if [ "${PGID}" != "${DEFAULT_GID}" ] && getent group "${PGID}"; then
    usermod --gid "${PGID}" "${DEFAULT_USER}"
    groupdel "${DEFAULT_GROUP}"
fi

EOT

# Manage Docker group
ARG DOCKER_GID
RUN <<EOT
#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive

export DEFAULT_DOCKER_GID=$(getent group docker | cut -d: -f3)

# If Docker GID is not default and does not exist: update GID of default docker group
if [ "${DOCKER_GID}" != "${DEFAULT_DOCKER_GID}" ] && ! getent group "${DOCKER_GID}"; then
    groupmod --gid "${DOCKER_GID}" docker
fi

# If Docker GID is not default and does exist: we have a problem
if [ "${DOCKER_GID}" != "${DEFAULT_DOCKER_GID}" ] && getent group "${DOCKER_GID}"; then
    1>&2 echo "ERROR: Docker GID ${DOCKER_GID} already exists... cannot update default docker group"
fi

EOT

#### VSC #######################################################################
FROM base AS vsc
ARG PGID
ARG PUID
RUN <<EOT
#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive

# Install Visual Studio Code (code)
curl --location 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' \
    | tar --extract --gzip --directory /usr/local/bin

# Prepare required directories
mkdir --parents /home/"$(id --user --name ${PUID})"/{.vscode-cli,.vscode-server,.vscode-server-insiders}
chown --recursive ${PUID}:${PGID} /home/"$(id --user --name ${PUID})"/{.vscode-cli,.vscode-server,.vscode-server-insiders}
export VSCODE_CLI_DATA_DIR=/home/"$(id --user --name ${PUID})"/.vscode-cli

EOT
USER ${PUID}:${PGID}
VOLUME [ "/home/codespace/.vscode-cli", "/home/codespace/.vscode-server", "/home/codespace/.vscode-server-insiders" ]
ENTRYPOINT code tunnel --accept-server-license-terms --name ${TUNNEL_NAME:-devcontainer} --log ${TUNNEL_LOG:-warn}
