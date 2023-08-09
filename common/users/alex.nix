{ config, pkgs, ... }:

{
  users.users.alex = {
    isNormalUser = true;
    home = "/home/alex";
    description = "Alex's Space";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXjEARc950hpmlCZmFzpjJJ/8WtrnIZxKO3LkQRQYCK"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.alex.openssh.authorizedKeys.keys;
  home-manager.users.alex = (import ./alex);
}
