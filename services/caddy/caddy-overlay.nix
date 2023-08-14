self: super: {
  caddy = super.caddy.override {
    plugins = [ self.caddy-dns/cloudflare ];
  };
}
