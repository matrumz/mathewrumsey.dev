# Project Guidelines

## Docker Compose

- Run `docker compose` commands from the repository root using default compose discovery.
- Do not specify compose files explicitly.
- If using `up` or `down` lifecycle commands, target specific services to avoid impacting unrelated containers.

## Architecture

This repository manages a self-hosted server stack on a single host. It uses:

- **Docker Compose** for container orchestration — the root `compose.yaml` includes per-app compose files from `applications/<name>/`.
- **Terraform** with the **Cloudflare provider** for DNS, Zero Trust Access policies, and related infrastructure. State is stored in a Cloudflare R2 backend.
- Each application directory contains its own `compose.yaml` (+ optional `compose.override.yaml`) and Terraform files (`main.tf`, `variables.tf`, `outputs.tf`).

## Conventions

- Environment variables are prefixed with `MATHEWRUMSEY_DEV_` and use double-underscore separators for nesting (e.g. `MATHEWRUMSEY_DEV_SECTION__KEY`). See `example.env` for the full list.
- Secrets live in `secrets/` subdirectories within each application and must never be committed with real values.
- Versioned container configuration goes in `container-data/`; runtime-generated data goes in `.container-data/` (git-ignored).
- Compose files use `x-ref` YAML anchors for reusable values (domain, host paths, image tags).

## Applications

### File Browser

- User import files are yaml files structured as a list of objects representing users as defined by https://raw.githubusercontent.com/filebrowser/filebrowser/refs/heads/master/users/users.go
- Passwords must be bcrypt hashes, not plain text. Generate hashes with `docker run --rm filebrowser/filebrowser hash "<password>"`
