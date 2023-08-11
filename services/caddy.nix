{ config, pkgs, lib, modulesPath, ... }:

{
  age.secrets."caddy-environment-file" = {
    file = ./secrets/caddy-environment-file.age;
  };

  services.caddy = {
    enable = true;

     package = (pkgs.callPackage ./custom-caddy.nix {
       plugins = [ "github.com/caddy-dns/cloudflare" ];
       vendorSha256 = "sha256-xjwB0Nb0MQw1vd43iJGRgXqJEOC7LK26XoZko9OFvJY=";
     });
    email = "vengaboys-dev@example.com";

    virtualHosts."mediumrare.ai" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.ALEX_CLOUDFLARE_API_TOKEN}
          }
          reverse_proxy localhost:4000
          encode gzip
          header / {
            X-Content-Type-Options "nosniff"
            X-Frame-Options "sameorigin"
            Referrer-Policy "no-referrer-when-downgrade"
            X-XSS-Protection "1; mode=block"
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          }
        '';
    };
  };

  systemd.services.caddy = {
      serviceConfig = {
      # Required to use ports < 1024
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
      EnvironmentFile = config.age.secrets."caddy-environment-file".path;
      TimeoutStartSec = "5m";
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
