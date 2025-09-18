install:
	brew install colima

start: prepare
	colima start

prepare:
	mkdir -p ~/.colima/default; cp ~/.config/colima/colima.yaml ~/.colima/default/colima.yaml
