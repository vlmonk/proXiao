KEYMAP     := config/proXiao.keymap
LAYOUT     := config/proXiao.json
YAML       := keymap.yaml
SVG        := keymap.svg
VOLUME     := /Volumes/XIAO-SENSE

.PHONY: all clean build left right flash-left flash-right

all: $(SVG)

build:
	./build.sh build

left:
	./build.sh left

right:
	./build.sh right

flash-left: firmware/left.uf2
	@echo "Waiting for bootloader volume $(VOLUME)..."
	@while [ ! -d "$(VOLUME)" ]; do sleep 0.5; done
	cat firmware/left.uf2 > $(VOLUME)/left.uf2
	@echo "Left half flashed."

flash-right: firmware/right.uf2
	@echo "Waiting for bootloader volume $(VOLUME)..."
	@while [ ! -d "$(VOLUME)" ]; do sleep 0.5; done
	cat firmware/right.uf2 > $(VOLUME)/right.uf2
	@echo "Right half flashed."

$(YAML): $(KEYMAP)
	keymap parse -z $< > $@

$(SVG): $(YAML) $(LAYOUT)
	keymap draw -j $(LAYOUT) $< > $@

clean:
	rm -f $(YAML) $(SVG)
	./build.sh clean
