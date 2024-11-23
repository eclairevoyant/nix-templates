{ inputs, ... }:
{
  imports = [ inputs.fp.flakeModules.easyOverlay ];

  perSystem =
    { final, self', ... }:
    {
      devShells.default = final.mkShell {
        inputsFrom = [ self'.packages.default ];
        packages = [ final.nimble ];
      };

      overlayAttrs = {
        MYNAME = self'.packages.default;
      };

      packages.default = final.callPackage ./package.nix { };
    };
}
