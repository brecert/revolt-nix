{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, fenix, naersk }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (fenix.packages.${system}.minimal) cargo rustc;

        pkgs = nixpkgs.legacyPackages.${system};
        naersk-lib = naersk.lib.${system}.override { inherit cargo rustc; };
        rustPlatform = pkgs.makeRustPlatform { inherit cargo rustc; };

        inherit (pkgs) lib callPackage writeShellScript;
      in
      rec
      {
        packages = {
          january = callPackage ./january { inherit pkgs; };
          revite = callPackage ./revite { inherit pkgs; };
          delta = callPackage ./delta { inherit pkgs rustPlatform; };
        };

        apps = {
          # todo: make this nicer
          revite = {
            type = "app";
            program = "${writeShellScript "revite" ''
              ${pkgs.darkhttpd}/bin/darkhttpd "${packages.revite}/dist" "$@"
            ''}";
          };
        };
      });
}
