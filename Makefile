KEYMAP     := config/proXiao.keymap
LAYOUT     := config/proXiao.json
YAML       := keymap.yaml
SVG        := keymap.svg

.PHONY: all clean

all: $(SVG)

$(YAML): $(KEYMAP)
	keymap parse -z $< > $@

$(SVG): $(YAML) $(LAYOUT)
	keymap draw -j $(LAYOUT) $< > $@

clean:
	rm -f $(YAML) $(SVG)
