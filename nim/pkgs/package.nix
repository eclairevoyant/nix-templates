{
  lib,
  buildNimPackage,
  pandoc,
}:
let
  fs = lib.fileset;
in
buildNimPackage (finalAttrs: rec {
  pname = "FIXME";
  version = "0.0.1";

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      (fs.fileFilter (
        file:
        builtins.any file.hasExt [
          "md"
          "nim"
        ]
      ) ../src)
    ];
  };

  nativeBuildInputs = [
    pandoc
  ];

  hardeningEnable = [ "pie" ];

  postBuild = ''
    pandoc -s -o ${finalAttrs.pname}.1 doc/${pname}.man1.md
  '';

  postInstall = ''
    install -Dm644 ${finalAttrs.pname}.1 -t "$out/share/man/man1/"
  '';

  meta = {
    description = "FIXME";
    homepage = "https://github.com/eclairevoyant/${pname}";
    license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = pname;
    platforms = lib.platforms.linux;
  };
})
