{
  self,
  lib,
  mkShellNoCC,
  pkgs,
  system,
  haskellPackages,
  haskell-language-server,
  fourmolu,
  cabal2nix,
}:
mkShellNoCC {
  shellHook = ''
    export KURU_TODO=$(pwd)/todo.dat
  '';
  inputsFrom = map (lib.getAttr "env") [self.packages.${system}.default];
  packages = [
    haskell-language-server
    fourmolu
    cabal2nix
    haskellPackages.cabal-fmt
    haskellPackages.cabal-install
  ];
}
