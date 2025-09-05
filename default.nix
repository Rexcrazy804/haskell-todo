{
  pins ? import ./npins,
  pkgs ? import pins.nixpkgs {},
}:
pkgs.lib.fix (self: let
  inherit (pkgs) haskellPackages;
  inherit (pkgs.lib) attrValues;
in {
  packages = {
    todo = haskellPackages.developPackage {
      root = ./.;
    };
    default = self.packages.todo;
  };

  devShells.default = pkgs.mkShell {
    inputsFrom = [self.packages.default];
    packages = attrValues {
      inherit (pkgs) haskell-language-server fourmolu;
      inherit (haskellPackages) cabal-fmt cabal-install;
    };
  };
})
