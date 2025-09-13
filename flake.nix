{
  description = "A flake for haskell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.systems.url = "github:nix-systems/default";

  outputs = inputs: let
    inherit (inputs) self nixpkgs;
    inherit (nixpkgs.lib) genAttrs;

    systems = import inputs.systems;
    pkgsFor = system: inputs.nixpkgs.legacyPackages.${system};
    eachSystem = fn: genAttrs systems (system: fn (pkgsFor system));
  in {
    packages = eachSystem (pkgs: {
      todo = pkgs.haskellPackages.callPackage ./nix/package.nix {};
      default = self.packages.${pkgs.system}.todo;
    });

    devShells = eachSystem (pkgs: {
      default = pkgs.callPackage ./nix/shell.nix {inherit self;};
    });
  };
}
