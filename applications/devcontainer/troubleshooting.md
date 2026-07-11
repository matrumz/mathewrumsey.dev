# Troubleshooting

This page contains common issues and solutions for the Visual Studio Code tunnel devcontainer.

## Tunnel does not start

### Error: `mount: /sys/kernel/security: permission denied.`

This error does not appear on all Docker hosts.

Setting `security_opt: seccomp:unconfined` in the compose file will resolve this issue, however it may cause the error `mount: /sys/kernel/security: cannot mount none read-only.` If this error occurs, remove the `security_opt` setting and run the container in privileged mode.

```yaml
# compose.override.yaml
services:
  <>:
    security_opt:
      - seccomp:unconfined
```

```yaml
# compose.override.yaml
services:
  <>:
    privileged: true
```

To avoid making git changes, you can create a `compose.override.yaml` file next to the root `compose.yaml` (and/or this projects `compose.yaml`). Docker Compose will automatically load this file and apply the settings.

### Error: `error invalid name: Names cannot be longer than 20 characters. Please try a different name.`

As of the time of writing, VSCode tunnels do not support tunnel names longer than 20 characters. If you encounter this error, shorten the tunnel name (`TUNNEL_NAME` envvar).

### Error: `warn error access singleton, retrying: could not create singleton lock file: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }`

This was seen before updating the Dockerfile to pre-create the various `~/.vscode-*` directories, and is due to Compose creating the volumes with the wrong ownership (`root:root`).

Fix this by running the following command, replacing `<service>` with the service name.:
```sh
docker compose exec <service> bash -c 'sudo chown -R $(id -u):$(id -g) ~/.vscode*'
```

## Docker commands do not work inside the tunnel

### Error: `permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: [...] dial unix /var/run/docker.sock: connect: permission denied`

This would be seen when running `docker` commands inside the tunnel as a unprivileged user. To resolve this, ensure the `MATHEWRUMSEY_DEV_HOST__USERS__docker__GID` environment variable in `.env` matches the host's Docker group ID.
