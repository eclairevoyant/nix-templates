{
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.system;
    in
    {
      formatter.${system} = pkgs.writeShellApplication {
        name = "nimpretty-nixfmt-wrapper";

        runtimeInputs = [
          pkgs.coreutils-full
          pkgs.fd
          pkgs.nim
          pkgs.nixfmt
        ];

        text = ''
          realpath "$@"
          fd "$@" -t f -e nix -x nixfmt '{}'
          fd "$@" -t f -e nim -x nimpretty '{}'
        '';
      };

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
}
