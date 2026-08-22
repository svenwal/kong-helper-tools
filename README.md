# Kong Helper Tools

[![GitHub](https://img.shields.io/badge/GitHub-svenwal%2Fkong--helper--tools-blue?logo=github&style=for-the-badge)](https://github.com/svenwal/kong-helper-tools)
[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-kong--helper--tools-2496ED?logo=docker&style=for-the-badge)](https://hub.docker.com/r/svenwal/kong-helper-tools)
[![CI](https://img.shields.io/github/actions/workflow/status/svenwal/kong-helper-tools/ci.yml?style=for-the-badge&label=CI%20Tests&logo=github-actions&logoColor=white)](https://github.com/svenwal/kong-helper-tools/actions/workflows/ci.yml)

A Docker image that bundles the tools most commonly needed for automating, configuring, and managing [Kong Gateway](https://konghq.com/products/kong-gateway). Use it as a base image in CI/CD pipelines, as an automation sidecar, or as an interactive shell for gateway operations.

---

## Included Tools

| Tool | Version | Purpose |
|------|---------|---------|
| [decK](https://github.com/kong/deck) | 1.65.2 | Declarative configuration management for Kong Gateway (sync, diff, validate configs) |
| [kongctl](https://github.com/kong/kongctl) | 1.13.0| Kong control-plane CLI for AI Gateway workflows |
| [yq](https://github.com/mikefarah/yq) | 4.53.3 | YAML/JSON processor — manipulate Kong config files |
| [jq](https://stedolan.github.io/jq/) | apk | JSON query and transformation |
| [xh](https://github.com/ducaale/xh) | 0.26.2 | HTTPie-compatible HTTP client (`http`/`https` commands); single static binary — no Python runtime |
| [OpenTofu](https://opentofu.org/) | 1.12.5 | Open-source Terraform-compatible IaC — provision Kong resources |

---

## Platforms

The image is built for both **`linux/amd64`** and **`linux/arm64`** (Apple Silicon / Graviton).

---

## Usage

### Pull the image

```bash
docker pull svenwal/kong-helper-tools:latest
```

### Interactive shell

```bash
docker run --rm -it svenwal/kong-helper-tools bash
```

### Use in a CI/CD pipeline

```yaml
# GitHub Actions example
jobs:
  sync-kong:
    runs-on: ubuntu-latest
    container: svenwal/kong-helper-tools:latest
    steps:
      - uses: actions/checkout@v4
      - name: Sync Kong config
        env:
          DECK_KONG_ADDR: https://kong-admin.example.com
          DECK_HEADERS: "Kong-Admin-Token:${{ secrets.KONG_TOKEN }}"
        run: deck sync -s kong.yaml
```

### Use as a base image

```dockerfile
FROM svenwal/kong-helper-tools:latest

COPY ./kong-configs /configs
CMD ["deck", "sync", "-s", "/configs/kong.yaml"]
```

---

## Building Locally

```bash
docker build -t kong-helper-tools .
```

### Build arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `DECK_VERSION` | `1.64.0` | decK version to install |
| `KONGCTL_VERSION` | `1.8.0` | kongctl version to install |
| `YQ_VERSION` | `4.53.3` | yq version to install |
| `OPENTOFU_VERSION` | `1.12.4` | OpenTofu version to install |
| `XH_VERSION` | `0.26.1` | xh version to install |

Override during build:

```bash
docker build \
  --build-arg DECK_VERSION=1.60.0 \
  --build-arg OPENTOFU_VERSION=1.10.0 \
  -t kong-helper-tools .
```

---

## CI/CD Workflows

| Workflow | Trigger | Action |
|----------|---------|--------|
| **CI** | Every push / PR | Builds `--target test` stage, which runs a smoke test verifying every binary starts correctly |
| **Docker Hub** | Git tag push | Builds multi-arch image and pushes `latest` + tag to Docker Hub; also updates the Docker Hub description from this README |

To publish a new release, push a git tag:

```bash
git tag 3.15
git push origin 3.15
```

---

## Version

Current version: 3.15

---

## License

Maintained by Sven Walther
