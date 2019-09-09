{ pkgs ? import <nixpkgs> {}
}:

let
  callPackage = pkgs.lib.callPackageWith pkgs;
  environments = import ./env { inherit pkgs protopkgs; };
  protopkgs = rec {

    protovim = callPackage ./pkgs/protovim {};

  };

in environments // protopkgs
