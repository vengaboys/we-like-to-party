{ config, pkgs, lib, modulesPath, ... }:

{
  age.secrets.cloudflare-api-token = {
    file = ./secrets/cloudflare-api-token.age;
  };

  services.caddy = {
    enable = true;
    # Something likeike this, you'll need to override the package...
    # package = (pkgs.callPackage ./something {
    #   plugins = [ "github.com/caddy-dns/cloudflare" ];
    #   # vendorSha256 = "";
    # });
    email = "vengaboys-dev@example.com";

    virtualHosts."mediumrare.ai" = {
        extraConfig = ''
          tls {
            dns cloudflare ${config.age.secrets.cloudflare-api-token.path}
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
