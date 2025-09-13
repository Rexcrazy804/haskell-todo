{
  description = "A flake for haskell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    inherit (nixpkgs.lib) getAttrs mapAttrs;

    pkgsFor = getAttrs (import systems) nixpkgs.legacyPackages;
    eachSystem = fn: mapAttrs fn pkgsFor;
  in {
    packages = eachSystem (system: pkgs: {
      todo = pkgs.haskellPackages.callPackage ./nix/package.nix {};
      default = self.packages.${system}.todo;
    });

    devShells = eachSystem (_: pkgs: {
      default = pkgs.callPackage ./nix/shell.nix {inherit self;};
    });
  };
}
