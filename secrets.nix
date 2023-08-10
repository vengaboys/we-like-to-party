let
  chris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUR/dExxJt7KpoYoqSpEb1unetXjI47yQpS5cFH51hM";
  martin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc/DDmsDE+KUR1xquEBGIoKbPgLwCbL315XMFP2/XSn";
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXjEARc950hpmlCZmFzpjJJ/8WtrnIZxKO3LkQRQYCK";

  users = [ chris martin alex ];

  kimDeployer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID/hujpdZEq6dC53eYfJgOIKOKWKrfjBGv7Hl754js/i";
in
{
  "secrets/kim-private-key.age".publicKeys = users;
  "secrets/alex_cloudflare_api_token.age".publicKeys = [kimDeployer alex];
}
