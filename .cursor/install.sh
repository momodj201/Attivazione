#!/usr/bin/env bash
# Idempotent setup for the AppuntamentiApp Cloud Agent environment.
#
# AppuntamentiApp is a SwiftUI/iOS application. SwiftUI, Combine and UIKit are
# Apple-platform only and cannot be built or run on Linux, so a full build/run
# of the app requires macOS + Xcode + the iOS Simulator. On this Linux agent we
# install the open-source Swift toolchain, which provides the compiler and
# Foundation. That lets the platform-independent code (the data models and pure
# business logic) be compiled and exercised for validation.
set -euo pipefail

SWIFT_VERSION="6.1.2"
SWIFT_DIR="/opt/swift"
SWIFT_URL="https://download.swift.org/swift-${SWIFT_VERSION}-release/ubuntu2404/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE-ubuntu24.04.tar.gz"

echo "==> Installing Swift runtime dependencies"
if ! dpkg -s libcurl4-openssl-dev >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends \
    binutils libc6-dev libcurl4-openssl-dev libedit2 libgcc-13-dev \
    libpython3-dev libstdc++-13-dev libxml2-dev libz3-dev pkg-config \
    tzdata zlib1g-dev libncurses-dev
else
  echo "    dependencies already present, skipping apt-get"
fi

echo "==> Installing Swift ${SWIFT_VERSION} toolchain"
if [ ! -x "${SWIFT_DIR}/usr/bin/swift" ]; then
  tmp="$(mktemp -d)"
  curl -fsSL -o "${tmp}/swift.tar.gz" "${SWIFT_URL}"
  sudo mkdir -p "${SWIFT_DIR}"
  sudo tar xzf "${tmp}/swift.tar.gz" -C "${SWIFT_DIR}" --strip-components=1
  rm -rf "${tmp}"
else
  echo "    Swift already installed at ${SWIFT_DIR}, skipping download"
fi

echo "==> Exposing swift/swiftc on PATH (via /usr/local/bin symlinks)"
sudo ln -sf "${SWIFT_DIR}/usr/bin/swift" /usr/local/bin/swift
sudo ln -sf "${SWIFT_DIR}/usr/bin/swiftc" /usr/local/bin/swiftc

echo "==> Swift toolchain ready:"
swift --version
