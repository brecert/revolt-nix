{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, crane }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        craneLib = crane.lib.${system};

        inherit (pkgs) callPackage fetchFromGitHub;
      in
      rec
      {
        packages = {
          delta = callPackage ./packages/delta { inherit craneLib; };
          bonfire = callPackage ./packages/bonfire { inherit craneLib; };
          january = callPackage ./packages/january { inherit craneLib; };
          autumn = callPackage ./packages/autumn { inherit craneLib; };
          # dependencies
          redis = pkgs.redis;
          mongodb = callPackage ./packages/mongodb { };
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
