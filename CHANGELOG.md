# Changelog

# [3.15.0.8] - 2026-09-03

### Updates

* Updated kongctl to 1.15.0
* Updated deck to 1.66.0
* Updated yq to 4.53.6
* Updated tofu to 1.12.6

# [3.15.0.7] - 2026-09-01

### Updates

* Updated kongctl to 1.14.0
* Updated kongctl to 1.65.3

# [3.15.0.6] - 2026-08-22

### Updates

* Updated kongctl to 1.13.0
* Updated kongctl to 1.65.2

# [3.15.0.5] - 2026-08-13

### Updates

* Updated kongctl to 1.12.0

# [3.15.0.4] - 2026-08-12

### Updates

* Updated kongctl to latest pre-release

# [3.15.0.3] - 2026-08-03

### Updates

* Updated kongctl to 1.10.0

# [3.15.0.2] - 2026-08-03

### Updates

* Updated decK to 1.65.1
* Updated kongctl to 1.9.0
* Updated xh to 0.26.2
* Updated tofu to 1.12.5

# [3.15.0.1] - 2026-07-24

### Updates

* Updated kongctl to 1.8.0


# [3.15] - 2026-07-17

### Added

* Added OpenSSL

### Updates

* Updated kongctl to 1.5.0

## [AI GW 2.0 Pre-release] - 2026-07-16

### Added

* Added kongctl (prerelease-aigw-2)

### Updates

* Updated deck to 1.64.0
* Updated yq to 4.53.3
* Updated OpenTofu to 1.12.4
* Updated xh to 0.26.1

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
