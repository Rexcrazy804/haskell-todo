{
  pins ? import ./npins,
  pkgs ? import pins.nixpkgs {},
}:
pkgs.lib.fix (self: let
  inherit (pkgs) haskellPackages;
  inherit (pkgs.lib) attrValues map getAttr;
in {
  packages = {
    todo = pkgs.callPackage ./default.nix {};
    default = self.packages.todo;
  };

  devShells.default = pkgs.mkShell {
    shellHook = ''
      export KURU_TODO=$(pwd)/todo.dat
    '';
    inputsFrom = map (getAttr "env") [self.packages.default];
    packages = attrValues {
      inherit (pkgs) haskell-language-server fourmolu;
      inherit (haskellPackages) cabal-fmt cabal-install;
    };
  };
})
