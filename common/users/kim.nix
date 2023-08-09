{ config, pkgs, ... }:

{
  users.users.kim = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/hujpdZEq6dC53eYfJgOIKOKWKrfjBGv7Hl754js/i"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.kim.openssh.authorizedKeys.keys;
}
