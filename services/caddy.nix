{ config, pkgs, lib, modulesPath, ... }:

let
  caddyDir = "/var/lib/caddy";
  mediumrareDomain = "mediumrare.ai";
in
{
  services.caddy = {
    enable = true;
    email = "vengaboys-dev@example.com";
    config = ''
    {
      storage file_system {
        root ${caddyDir}
      }
    }
    ${mediumrareDomain} {
      reverse_proxy localhost:4000
      encode gzip zstd
      header / {
        X-Content-Type-Options "nosniff"
        X-Frame-Options "sameorigin"
        Referrer-Policy "no-referrer-when-downgrade"
        X-XSS-Protection "1; mode=block"
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
      }
    }
    www.${mediumrareDomain} {
      redir https://${mediumrareDomain}{uri}
    }
    '';
    adapter = "caddyfile";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
