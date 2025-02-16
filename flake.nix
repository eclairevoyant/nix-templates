{
  description = "simple nix templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        templates = {
          nim = {
            path = ./nim;
            description = "minimal nim template";
          };
          nixos = {
            path = ./nixos;
            description = "minimal nixos template";
          };
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.writeShellApplication {
            name = "nixfmt-wrapper";

            runtimeInputs = [
              pkgs.coreutils-full
              pkgs.fd
              pkgs.nixfmt-rfc-style
            ];

            text = ''
              realpath "$@"
              fd "$@" -t f -e nix -x nixfmt '{}'
            '';
          };
        };
    };
}
