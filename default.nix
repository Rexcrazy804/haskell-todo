{
  haskellPackages,
  lib,
}: let
  inherit (lib.fileset) toSource unions fileFilter;
  root = ./.;

  haskellFileFilter = fileFilter (file: builtins.any file.hasExt ["hs"]);
  src = toSource {
    inherit root;
    fileset = unions [
      (haskellFileFilter (root + /app))
      (haskellFileFilter (root + /lib))
      (haskellFileFilter (root + /test))
      (root + /todo.cabal)
      (root + /CHANGELOG.md)
      (root + /UNLICENSE)
    ];
  };
in
  haskellPackages.callCabal2nix "todo" src {}
