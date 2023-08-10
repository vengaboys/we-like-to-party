{ config, pkgs, lib, modulesPath, ... }:
let
  alex_cloudflare_api_key = builtins.readFile config.age.secrets.alex_cloudflare_api_token.path;
in {
  services.caddy = {
    enable = true;
    email = "vengaboys-dev@example.com";

    virtualHosts."mediumrare.ai" = {
        extraConfig = ''
          tls {
            dns cloudflare ${alex_cloudflare_api_key}
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

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
