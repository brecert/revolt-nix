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
          january = callPackage ./packages/january { inherit pkgs; };
          autumn = callPackage ./packages/autumn { inherit pkgs; };
          revite = callPackage ./packages/revite { inherit pkgs; };
          delta = callPackage ./packages/delta { inherit pkgs rustPlatform; };
        };

        apps = {
          revite = {
            type = "app";
            program = toString (writeShellScript "revite" ''
              ${pkgs.darkhttpd}/bin/darkhttpd "${packages.revite}/dist" "$@"
            '');
          };
        };
      });
}
