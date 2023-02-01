#!/bin/bash
# Build Arm64 APK for Android
# Part of CI build process

/bin/bash keys/gen_keys.sh

flutter build apk \
--obfuscate \
--split-debug-info=/tmp/ \
--target-platform=android-arm64 \
--no-tree-shake-icons \
--suppress-analytics \
# --split-per-abi
# Release build is configured to require signing key
# --release \
