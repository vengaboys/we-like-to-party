all: $(TARGET)

deploy: all
	@nix run github:serokell/deploy-rs -- --remote-build