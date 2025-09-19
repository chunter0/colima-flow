install:
	@HOMEBREW_NO_AUTO_UPDATE=1 brew install colima
	@brew pin colima

start: install prepare
	@colima start

prepare:
	@mkdir -p ~/.colima/default; envsubst < colima.tpl > ~/.colima/default/colima.yaml
