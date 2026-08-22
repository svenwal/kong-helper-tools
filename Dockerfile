FROM alpine:3.21 AS downloader

ARG DECK_VERSION=1.65.2
ARG KONGCTL_VERSION=v1.13.0
ARG YQ_VERSION=4.53.3
ARG OPENTOFU_VERSION=1.12.5
ARG XH_VERSION=0.26.2
ARG TARGETPLATFORM

RUN apk add --no-cache curl unzip

# decK
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/arm64") ARCH=arm64 ;; \
      *) ARCH=amd64 ;; \
    esac; \
    curl -fsSL "https://github.com/kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_${ARCH}.tar.gz" | \
    tar -xz -C /usr/local/bin deck && \
    chmod +x /usr/local/bin/deck

# kongctl
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/arm64") ARCH=arm64 ;; \
      *) ARCH=amd64 ;; \
    esac; \
    curl -fsSL "https://github.com/kong/kongctl/releases/download/${KONGCTL_VERSION}/kongctl_linux_${ARCH}.zip" -o /tmp/kongctl.zip && \
    unzip /tmp/kongctl.zip -d /usr/local/bin && \
    rm /tmp/kongctl.zip && \
    chmod +x /usr/local/bin/kongctl

# yq
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/arm64") ARCH=arm64 ;; \
      *) ARCH=amd64 ;; \
    esac; \
    curl -fsSL "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCH}" \
    -o /usr/local/bin/yq && chmod +x /usr/local/bin/yq

# OpenTofu
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/arm64") ARCH=arm64 ;; \
      *) ARCH=amd64 ;; \
    esac; \
    curl -fsSL "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_${ARCH}.zip" \
    -o /tmp/tofu.zip && \
    unzip /tmp/tofu.zip tofu -d /usr/local/bin && \
    rm /tmp/tofu.zip && \
    chmod +x /usr/local/bin/tofu

# xh — HTTPie-compatible HTTP client, single static musl binary
RUN set -ex; \
    case "$TARGETPLATFORM" in \
      "linux/arm64") ARCH=aarch64 ;; \
      *) ARCH=x86_64 ;; \
    esac; \
    curl -fsSL "https://github.com/ducaale/xh/releases/download/v${XH_VERSION}/xh-v${XH_VERSION}-${ARCH}-unknown-linux-musl.tar.gz" \
    -o /tmp/xh.tar.gz && \
    tar -xzf /tmp/xh.tar.gz -C /tmp && \
    mv "/tmp/xh-v${XH_VERSION}-${ARCH}-unknown-linux-musl/xh" /usr/local/bin/xh && \
    chmod +x /usr/local/bin/xh && \
    rm -rf /tmp/xh.tar.gz "/tmp/xh-v${XH_VERSION}-${ARCH}-unknown-linux-musl"


FROM alpine:3.21 AS runtime

LABEL maintainer="Kong Inc."
LABEL description="Kong Gateway Helper Tools Docker Image"
LABEL version="3.14"

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    git \
    dialog \
    ca-certificates \
    openssl

COPY --from=downloader /usr/local/bin/deck    /usr/local/bin/deck
COPY --from=downloader /usr/local/bin/yq      /usr/local/bin/yq
COPY --from=downloader /usr/local/bin/tofu    /usr/local/bin/tofu
COPY --from=downloader /usr/local/bin/xh      /usr/local/bin/xh
COPY --from=downloader /usr/local/bin/kongctl /usr/local/bin/kongctl

# HTTPie-compatible aliases
RUN ln -s xh /usr/local/bin/http && \
    ln -s xh /usr/local/bin/https
CMD ["bash"]


# Smoke-test stage — used by CI (docker build --target test)
FROM runtime AS test

RUN echo "Deck:      " && deck version && echo "----" && \
    echo "Kongctl:   " && kongctl version --full && echo "----" && \
    echo "Yq:        " && yq --version && echo "----" && \
    echo "Tofu:      " && tofu --version && echo "----" && \
    echo "Xh:        " && xh --version && echo "----" && \
    echo "Jq:        " && jq --version && echo "----" && \
    echo "Curl:      " && curl --version && echo "----" && \
    echo "Git:       " && git --version && echo "----" && \
    echo "OpenSSL:   " && openssl version && echo "----"
