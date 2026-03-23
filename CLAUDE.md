# proXiao — ZMK Corne Keyboard Config

## What is this
ZMK firmware configuration for a custom Corne (3x6+3) split keyboard called **proXiao**, built on **Seeeduino XIAO BLE** (nRF52840).

## Project structure
```
build.yaml              — GitHub Actions build matrix (left + right shields)
config/
  west.yml              — ZMK manifest (pulls zmk from github)
  proXiao.conf          — Global firmware config (BT, power, sleep)
  proXiao.keymap        — Keymap definition (4 layers: DEF, numbers, NAV, SYMBOLS)
  proXiao.json          — Physical layout for keymap editor
  boards/shields/proXiao/
    proXiao.dtsi         — Hardware: matrix transform, kscan, GPIO pins
    proXiao_left.overlay — Left half pin mapping
    proXiao_right.overlay— Right half pin mapping
    proXiao_left.conf    — Left half config (empty)
    proXiao_right.conf   — Right half config (empty)
    proXiao.zmk.yml      — Shield metadata
    Kconfig.*            — Kconfig definitions
```

## Build
Firmware builds via GitHub Actions on push. See `build.yaml` for the matrix.
Board: `seeeduino_xiao_ble`, shields: `proXiao_left` / `proXiao_right`.

## Keymap layers
- **0 (DEF)**: QWERTY with layer-taps on D (→numbers) and F (→symbols)
- **1 (numbers)**: Numpad right side, BT controls left side
- **2 (NAV)**: Arrow keys, word/line jumps, volume, F20/F21
- **3 (SYMBOLS)**: Brackets, operators, special characters

## Key conventions
- Keymap syntax is ZMK devicetree (`.keymap` files)
- `&lt` = layer-tap, `&mt` = mod-tap, `&mo` = momentary layer
- `quick_tap_ms = 220` on lt/mt behaviors
- Custom `tap-dance` for Right Alt / Alt+Space toggle
