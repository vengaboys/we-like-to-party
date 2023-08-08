{ config, pkgs, ... }:

{
  users.users.martin = {
    isNormalUser  = true;
    home  = "/home/martin";
    description  = "Hic Sunt Dracones";
    extraGroups  = [ "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc/DDmsDE+KUR1xquEBGIoKbPgLwCbL315XMFP2/XSn"];
  };
  users.users.root.openssh.authorizedKeys.keys = config.users.users.martin.openssh.authorizedKeys.keys;
  home-manager.users.martin = (import ./martin);
}
