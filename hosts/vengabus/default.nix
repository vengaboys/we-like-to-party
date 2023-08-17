{ config, pkgs, ... }:

{
  imports = [./hardware-configuration.nix];
	nix.settings.sandbox = false;

  boot = {
    loader.systemd-boot.enable = false;
    loader = {
      efi = { efiSysMountPoint = "/boot/efi"; };
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        devices = [
          "/dev/disk/by-id/ata-Micron_1100_MTFDDAK512TBN_18301DC68C94"
          "/dev/disk/by-id/ata-Micron_1100_MTFDDAK512TBN_18301DC69CA3"
        ];
        copyKernels = true;
      };
    };
    supportedFilesystems = [ "zfs" ];
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  environment = { systemPackages = with pkgs; [ vim ]; };

  networking = {
    hostName = "vengabus";
    hostId = "12345678";
    useDHCP = false;
    interfaces."enp6s0".ipv4.addresses = [{
      address = "159.69.59.124";
      prefixLength = 26;
    }];
    interfaces."enp6s0".ipv6.addresses = [{
      address = "2a01:4f8:231:ae3::1";
      prefixLength = 64;
    }];
    defaultGateway = "159.69.59.65";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp6s0";
    };
    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
      "8.8.8.8"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = { PermitRootLogin = "prohibit-password"; };
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}
