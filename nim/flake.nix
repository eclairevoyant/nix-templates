{
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowlistedLicenses = with nixpkgs.lib.licenses; [ cc-by-nc-sa-40 ];
      };
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
      overlays.default = f: _: { FIXME = f.callPackage ./package.nix { }; };
      packages.${system}.default = pkgs.callPackage ./package.nix { };
    };
}
