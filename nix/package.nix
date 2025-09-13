{
  mkDerivation,
  base,
  directory,
  filepath,
  lib,
  xdg-basedir,
}: let
  inherit (lib.fileset) toSource unions fileFilter;
  hsfilter = fileFilter (file: lib.any file.hasExt ["hs"]);
  root = ../.;

  src = toSource {
    inherit root;
    fileset = unions [
      (hsfilter (root + /app))
      (hsfilter (root + /lib))
      (hsfilter (root + /test))
      (root + /todo.cabal)
      (root + /CHANGELOG.md)
      (root + /UNLICENSE)
    ];
  };
in
  mkDerivation {
    inherit src;
    pname = "todo";
    version = "0.1.0.0";
    isLibrary = true;
    isExecutable = true;
    libraryHaskellDepends = [base directory filepath xdg-basedir];
    executableHaskellDepends = [base];
    testHaskellDepends = [base];
    homepage = "https://github.com/Rexcrazy804";
    description = "A simple todo cmdline app";
    license = lib.licenses.unlicense;
    mainProgram = "todo";
  }
