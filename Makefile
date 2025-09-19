deps:
	@HOMEBREW_NO_AUTO_UPDATE=1 brew install colima
	@brew pin colima

up: deps config
	@colima start

init: up ssh-host ssh-include

config:
	@mkdir -p ~/.colima/default; envsubst < colima.tpl > ~/.colima/default/colima.yaml

ssh-include:
	@if ! grep -q "Include ~/.ssh/config.d/colima" ~/.ssh/config 2>/dev/null; then \
		sed -i '1i Include ~/.ssh/config.d/colima' ~/.ssh/config; \
	fi

ssh-host:
	@echo "Creating SSH config for colima instance..."
	@mkdir -p ~/.ssh/config.d
	@COLIMA_IP=$$(colima status default -e 2>&1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1); \
	if [ -z "$$COLIMA_IP" ]; then \
		echo "Error: Could not determine colima IP address. Is colima running?"; \
		exit 1; \
	fi; \
	echo "Host colima" > ~/.ssh/config.d/colima; \
	echo "  HostName $$COLIMA_IP" >> ~/.ssh/config.d/colima; \
	echo "  IdentityFile ~/.colima/_lima/_config/user" >> ~/.ssh/config.d/colima; \
	echo "  User $$(whoami)" >> ~/.ssh/config.d/colima; \
	echo "  ForwardX11 yes" >> ~/.ssh/config.d/colima; \
	echo "  ForwardX11Trusted yes" >> ~/.ssh/config.d/colima; \
	echo "  ServerAliveInterval 60" >> ~/.ssh/config.d/colima; \
	echo "  ServerAliveCountMax 10" >> ~/.ssh/config.d/colima
	@echo "✓ SSH config created for colima at $$(colima status default -e 2>&1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)"

down:
	@colima stop

clean:
	@colima delete

help:
	@echo "Colima Development Environment"
	@echo ""
	@echo "Targets:"
	@echo "  init        - Full setup (first time use)"
	@echo "  up          - Start colima VM"
	@echo "  down        - Stop colima VM"
	@echo "  clean       - Delete colima VM"
	@echo "  deps        - Install dependencies"
	@echo "  config      - Process configuration template"
	@echo "  ssh-include - Add SSH include to ~/.ssh/config"
	@echo "  ssh-host    - Generate SSH host configuration"
	@echo ""

.PHONY: deps up down clean init config ssh-include ssh-host help
