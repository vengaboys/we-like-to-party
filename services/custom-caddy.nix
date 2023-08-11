{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, caddy
, testers
, installShellFiles
, plugins ? []
, vendorSha256 ? ""
}:

with lib;

let
  version = "2.7.3";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    hash = "sha256-fQhujBYyl2p3cdqyf+LVebPBGxXn2lKMB/dsvTo5+NM=";
  };
  imports = flip concatMapStrings plugins (pkg: "\t\t\t_ \"${pkg}\"\n");
  main = ''
    		package main

    		import (
    			caddycmd "github.com/caddyserver/caddy/v2/cmd"

    			_ "github.com/caddyserver/caddy/v2/modules/standard"
    ${imports}
    		)

    		func main() {
    			caddycmd.Main()
    		}
    	'';
in
buildGoModule {
  pname = "caddy";
  inherit version;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    rev = "v${version}";
    hash = "sha256-KezKMpx3M7rdKXEWf5XUSXqY5SEimACkv3OB/4XccCE=";
  };

  vendorHash = "sha256-mTHEM+0yakKiy4ZFi+2qakjSlKFyRkbjeXOXdvx+9lA=";

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

	overrideModAttrs = (_: {
		preBuild    = "echo '${main}' > cmd/caddy/main.go";
		postInstall = "cp go.sum go.mod $out/ && ls $out/";
	});

	postPatch = ''
		echo '${main}' > cmd/caddy/main.go
		cat cmd/caddy/main.go
	'';

	postConfigure = ''
		cp vendor/go.sum ./
		cp vendor/go.mod ./
	'';


  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

    installShellCompletion --cmd caddy \
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) caddy;
    version = testers.testVersion {
      command = "${caddy}/bin/caddy version";
      package = caddy;
    };
  };

  meta = with lib; {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    license = licenses.asl20;
    maintainers = with maintainers; [ Br1ght0ne emilylange techknowlogick ];
  };
}
