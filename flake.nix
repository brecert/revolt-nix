{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # todo:
  # mkShellApp { name, script, ENV.. } 

  outputs = inputs@{ self, nixpkgs, flake-utils, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (fenix.packages.${system}.minimal) cargo rustc;

        pkgs = import nixpkgs { inherit system overlay; };
        rustPlatform = pkgs.makeRustPlatform { inherit cargo rustc; };

        inherit (pkgs) lib stdenv callPackage writeShellScript;

        packages = {
          mongodb = callPackage ./packages/mongodb { inherit pkgs; };
          redis = pkgs.redis;

          # todo: mkClient, mkServer, mkAutumn, mkJanuary
          january = callPackage ./packages/january { inherit pkgs; };
          autumn = callPackage ./packages/autumn { inherit pkgs; };
          revite = callPackage ./packages/revite { inherit pkgs; VITE_API_URL = "https://local.revolt.chat:8000"; VITE_THEMES_URL = "https://themes.revolt.chat"; };
          delta = callPackage ./packages/delta { inherit pkgs rustPlatform; };
        };

        overlay = final: prev: packages;
      in
      rec
      {
        inherit packages overlay;

        apps = {
          revite = {
            type = "app";
            program = toString (writeShellScript "revite" ''
              ${pkgs.darkhttpd}/bin/darkhttpd "${packages.revite}/dist" "$@"
            '');
          };

          redis = flake-utils.lib.mkApp { drv = packages.redis; exePath = "/bin/redis-server"; };
          mongodb = flake-utils.lib.mkApp { drv = packages.mongodb; exePath = "/bin/mongod"; };
        };

        nixosModules = {
          autumn = import ./modules/autumn;
        };
      });
}
