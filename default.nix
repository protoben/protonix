{ pkgs ? import <nixpkgs> {}
}:

let
  callPackage = pkgs.lib.callPackageWith pkgs;
  environments = import ./env { inherit pkgs protopkgs; };
  protopkgs = rec {

    protovim = callPackage ./pkgs/protovim {};

    ocarina-bin = callPackage ./pkgs/ocarina/bin.nix {};

  };

in environments // protopkgs
