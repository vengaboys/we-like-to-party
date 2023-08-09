{
  description = "we like to party, deploy-rs style";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, home-manager, agenix, ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            agenix.nixosModules.age

            ({ config, ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
            ./common

          ] ++ extraModules;
        };

    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [ deploy-rs.packages.x86_64-linux.deploy-rs agenix.packages.x86_64-linux.agenix ];
      };

      nixosConfigurations = { vengabus = mkSystem [ ./hosts/vengabus ]; };

      deploy = {
        nodes.vengabus = {
          hostname = "159.69.59.124";
          sshUser = "root";
          fastConnection = true;

          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.vengabus;
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
