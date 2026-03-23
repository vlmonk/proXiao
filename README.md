# zmk-proXiao

ZMK config for proXiao shields. proXiao is a bluetooth controller for [Corne](https://github.com/foostan/crkbd)/[Jorne](https://github.com/joric/jorne) keyboard.

By switching between branches in this repository, you can choose the configuration for your keyboard. For a Corne or other compatible 6-column keyboard, you should select the "6-col" branch.

You can change the device name in `config/proXiao.conf`:
```
CONFIG_ZMK_KEYBOARD_NAME="proXiao"
```

## Keymap visualization

Generate an SVG of the current keymap using [keymap-drawer](https://github.com/caksoylar/keymap-drawer):

```bash
pip install keymap-drawer
make
```

This will parse `config/proXiao.keymap` and produce `keymap.svg` with all layers visualized.
