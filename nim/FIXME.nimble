version       = "0.0.1"
author        = "éclairevoyant"
description   = "FIXME"
license       = "CC-by-nc-sa-4.0"
srcDir        = "src"
bin           = @["FIXME"]

requires "nim >= 2.2.0"

task release, "Release build":
  exec "nimble build -d:release --opt:speed"
#  exec "pandoc -s -o FIXME.1 doc/FIXME.man1.md"
