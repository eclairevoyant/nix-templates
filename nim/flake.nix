{
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs' =
        system:
        import nixpkgs {
          inherit system;
          config.allowlistedLicenses = with nixpkgs.lib.licenses; [ cc-by-nc-sa-40 ];
        };
      generateSystems =
        f:
        nixpkgs.lib.attrsets.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
          system: f (pkgs' system)
        );
    in
    {
      formatter = generateSystems (pkgs: {
        default = pkgs.writeShellApplication {
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
      });

      overlays.default = f: _: { FIXME = f.callPackage ./package.nix { }; };

      packages = generateSystems (pkgs: {
        default = pkgs.callPackage ./package.nix { };
      });
    };
}
