{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ndg = {
      url = "github:feel-co/ndg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ndg, ... }:
    {
      nixosConfigurations.test = nixpkgs.lib.nixosSystem {
        modules = [
          (
            { modulesPath, ... }:
            {
              imports = [ "${modulesPath}/profiles/minimal.nix" ];

              boot.loader.grub.enable = false;
              fileSystems."/".device = "nodev";
              nixpkgs = {
                hostPlatform = "x86_64-linux";
                overlays = [ ndg.overlays.default ];
              };
              system.stateVersion = "24.05";

              users = {
                mutableUsers = false;
                users.test = {
                  password = "meow";
                  isNormalUser = true;
                  group = "wheel";
                  createHome = true;
                };
              };

              # custom config here
            }
          )
        ];
      };
    };
}
