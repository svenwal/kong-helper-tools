# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [3.14] - 2026-04-29

First release after having been extracted from another repo - now being an independent project.

### Added
- Multi-stage Docker build (`downloader` → `runtime` → `test`) to keep build artifacts out of the final image
- [xh](https://github.com/ducaale/xh) 0.22.2 as a drop-in replacement for HTTPie — same `http`/`https` CLI interface, single static musl binary
- `http` and `https` symlinks pointing to `xh` for HTTPie-compatible usage
- [OpenTofu](https://opentofu.org/) 1.9.0 installed directly from the GitHub release zip (replaces the deb install-script approach)
- Smoke-test stage (`--target test`) that verifies every binary on every CI build
- `OPENTOFU_VERSION` and `XH_VERSION` build arguments for easy version pinning
- `README.md` with tool table, usage examples, build instructions, and CI/CD documentation
- GitHub Actions workflow (`ci.yml`) that builds `--target test` on every push and pull request
- GitHub Actions workflow (`build-and-push.yaml`) that builds and pushes a multi-arch image (`linux/amd64`, `linux/arm64`) to Docker Hub on every git tag, and syncs the Docker Hub description from `README.md`

### Changed
- Base image switched from `debian:bookworm-slim` to `alpine:3.21` (~80MB → ~5MB base)
- OpenTofu installation switched from deb shell-script to direct binary download, removing apt repo setup overhead
- Push workflow now explicitly targets `--target runtime` to avoid pushing the test layer

### Removed
- HTTPie (Python-based) — replaced by xh to eliminate the Python runtime dependency (~150MB saved)
