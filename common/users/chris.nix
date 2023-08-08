{ config, pkgs, ... }:

{
  users.users.chris = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" ];
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUR/dExxJt7KpoYoqSpEb1unetXjI47yQpS5cFH51hM"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = config.users.users.chris.openssh.authorizedKeys.keys;
  home-manager.users.chris = (import ./chris);
}
