#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZMK_DIR="${SCRIPT_DIR}/.zmk"
FIRMWARE_DIR="${SCRIPT_DIR}/firmware"
DOCKER_IMAGE="zmkfirmware/zmk-dev-arm:stable"
BOARD="seeeduino_xiao_ble"
CONFIG_DIR="/workspace/zmk-config/config"

init() {
    mkdir -p "${ZMK_DIR}"

    # Parse ZMK revision from config/west.yml
    local zmk_rev
    zmk_rev=$(grep 'revision:' "${SCRIPT_DIR}/config/west.yml" | awk '{print $2}')

    if [ ! -d "${ZMK_DIR}/zmk" ]; then
        echo "==> Cloning ZMK..."
        git clone https://github.com/zmkfirmware/zmk.git "${ZMK_DIR}/zmk"
    fi

    echo "==> Checking out ZMK revision: ${zmk_rev}"
    git -C "${ZMK_DIR}/zmk" checkout "${zmk_rev}"

    echo "==> Initializing west workspace and fetching modules (first time only, takes a few minutes)..."
    docker run --rm \
        -v "${ZMK_DIR}/zmk:/workspace/zmk" \
        -w /workspace/zmk \
        "${DOCKER_IMAGE}" \
        bash -c "git config --global safe.directory '*' && west init -l app/ 2>/dev/null || true && west update"

    touch "${ZMK_DIR}/.initialized"
    echo "==> Init complete. Subsequent builds will be fast."
}

build_side() {
    local shield="$1"
    local side="$2"

    echo "==> Building ${side}..."
    docker run --rm \
        -v "${ZMK_DIR}/zmk:/workspace/zmk" \
        -v "${SCRIPT_DIR}:/workspace/zmk-config" \
        -w /workspace/zmk \
        "${DOCKER_IMAGE}" \
        west build -p -s app -d "build/${side}" -b "${BOARD}" -- \
            -DSHIELD="${shield}" \
            -DZMK_CONFIG="${CONFIG_DIR}"

    mkdir -p "${FIRMWARE_DIR}"
    cp "${ZMK_DIR}/zmk/build/${side}/zephyr/zmk.uf2" "${FIRMWARE_DIR}/${side}.uf2"
    echo "==> ${FIRMWARE_DIR}/${side}.uf2 ready"
}

usage() {
    cat <<'USAGE'
Usage: ./build.sh [command]

Commands:
  init    — download ZMK and Zephyr modules (first time setup)
  build   — build both halves (runs init if needed)
  left    — build left half only
  right   — build right half only
  clean   — remove build cache and firmware
USAGE
}

case "${1:-build}" in
    init)
        init
        ;;
    build)
        [ -f "${ZMK_DIR}/.initialized" ] || init
        build_side "proXiao_left" "left"
        build_side "proXiao_right" "right"
        echo ""
        echo "==> Done. Firmware:"
        ls -lh "${FIRMWARE_DIR}"/*.uf2
        ;;
    left)
        [ -f "${ZMK_DIR}/.initialized" ] || init
        build_side "proXiao_left" "left"
        ;;
    right)
        [ -f "${ZMK_DIR}/.initialized" ] || init
        build_side "proXiao_right" "right"
        ;;
    clean)
        rm -rf "${ZMK_DIR}" "${FIRMWARE_DIR}"
        echo "==> Cleaned."
        ;;
    *)
        usage
        ;;
esac
