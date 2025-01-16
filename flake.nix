{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;

    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    packages = forAllSystems (system: import ./pkgs/top-level {inherit inputs system;});
  };
}
