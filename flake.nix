{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-analyzer-src.follows = "";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, fenix, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # both for mongo lol
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "openssl-1.1.1u"
            ];
          };
        };
        craneLib = crane.lib.${system}.overrideToolchain fenix.packages.${system}.stable.toolchain;
        inherit (pkgs) callPackage fetchFromGitHub;
      in
      rec
      {
        packages = {
          delta = callPackage ./packages/delta { inherit craneLib; };
          bonfire = callPackage ./packages/bonfire { inherit craneLib; };
          january = callPackage ./packages/january { inherit craneLib; };
          autumn = callPackage ./packages/autumn { inherit craneLib; };
          
          # # dependencies
          redis = pkgs.redis;
          mongodb = callPackage ./packages/mongodb { };
          
          # tools
          mprocs = pkgs.mprocs;
        };

        apps = {
          redis = flake-utils.lib.mkApp { drv = packages.redis; exePath = "/bin/redis-server"; };
          mongodb = flake-utils.lib.mkApp { drv = packages.mongodb; exePath = "/bin/mongod"; };
        };

        devShell = pkgs.mkShell {
          packages = builtins.attrValues packages;
        };
      }
    );
}
