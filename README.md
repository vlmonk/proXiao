# zmk-proXiao

ZMK config for proXiao shields. proXiao is a bluetooth controller for [Corne](https://github.com/foostan/crkbd)/[Jorne](https://github.com/joric/jorne) keyboard.

By switching between branches in this repository, you can choose the configuration for your keyboard. For a Corne or other compatible 6-column keyboard, you should select the "6-col" branch.

You can change the device name in `config/proXiao.conf`:
```
CONFIG_ZMK_KEYBOARD_NAME="proXiao"
```

## Layout

4 layers, 3x6+3 split:

| Layer | Activation | Purpose |
|-------|-----------|---------|
| DEF | default | QWERTY, Ctrl/Esc on left, Ctrl/' on right |
| numbers | hold D | Numpad on right side, BT controls on left |
| NAV | hold MO(2) | Arrows, word/line jumps, volume, layout switch |
| SYMBOLS | hold F or J | Brackets, operators, special characters |

Thumb cluster (left to right): `Cmd`, `Backspace`, `NAV(mo)` / `Enter`, `Space`, `RAlt/Alfred`

Right thumb `RAlt` is a tap-dance: single tap = Right Alt, double tap = Alt+Space (Alfred launcher).

NAV layer thumb keys `F20` / `F21` are used for OS-level input language switching (F20 = EN, F21 = RU).

## Keymap visualization

Generate an SVG of the current keymap using [keymap-drawer](https://github.com/caksoylar/keymap-drawer):

```bash
pip install keymap-drawer
make
```

This will parse `config/proXiao.keymap` and produce `keymap.svg` with all layers visualized.
