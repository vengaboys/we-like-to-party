all: $(TARGET)

deploy: ## Deploy for idiots on aarm64 like me
	@nix run github:serokell/deploy-rs -- --remote-build
