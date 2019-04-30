{ pkgs ? import <nixpkgs> {}
}:

let callPackage = pkgs.lib.callPackageWith pkgs;

rec {

  evcxr = callPackage ./pkgs/evcxr {};

}
