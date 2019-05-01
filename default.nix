{ pkgs ? import <nixpkgs> {}
}:

let callPackage = pkgs.lib.callPackageWith pkgs;

in rec {

  evcxr = callPackage ./pkgs/evcxr {};

}
