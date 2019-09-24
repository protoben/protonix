{ pkgs
, protopkgs
}:

rec {

  protoenv = pkgs.buildEnv {
    name = "protoenv";
    paths = (with pkgs.gitAndTools; [
      git
      hub
      tig
    ]) ++ (with pkgs; [
      tldr
      w3m
      file
      lsof
    ]);
  };

  desktop-env = pkgs.buildEnv {
    name = "desktop-env";
    paths = with pkgs; [
      firefox-bin
      mplayer
      mupdf
      termite
    ];
  };

  /* Development */

  haskell-dev = pkgs.buildEnv {
    name = "haskell-dev";
    paths = [
      (pkgs.haskellPackages.ghcWithHoogle (ps: with ps; [
        cabal-install
        stack
        djinn
      ]))
    ];
  };

  /* Usage example:
   * $ nix-shell -E '(import <protonix> {}).haskell-dev-with (ps: [ ps.sockets ])'
   */
  haskell-dev-with = f: pkgs.mkShell {
    name = "haskell-dev-with";
    buildInputs = [(pkgs.haskellPackages.ghcWithHoogle
      (ps: with ps; [
        cabal-install
        stack
        djinn
      ] ++ f ps)
    )];
  };

  rust-dev = pkgs.buildEnv {
    name = "rust-dev";
    paths = with pkgs; [
      rustup
      evcxr
    ];
  };

}
