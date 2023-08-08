{ config, lib, pkgs, ... }: {
  imports = [
     ./users
  ];
}

# Put generalised common defaults across nodes in here