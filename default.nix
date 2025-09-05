{
  haskellPackages,
  lib,
}: let
  inherit (lib.fileset) toSource unions fileFilter;
  root = ./.;

  haskellFileFilter = fileFilter (file: builtins.any file.hasExt ["hs"]);
in
  haskellPackages.developPackage {
    root = toSource {
      inherit root;
      fileset = unions [
        (haskellFileFilter (root + /app))
        (haskellFileFilter (root + /lib))
        (haskellFileFilter (root + /test))
        (root + /todo.cabal)
      ];
    };
  }
