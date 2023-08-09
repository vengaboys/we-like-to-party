{ pkgs, ... }:

{
  imports = [ ../../home-manager ];

  home.packages = with pkgs; [ speedtest-cli ];
}
