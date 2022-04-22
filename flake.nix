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

        inherit (pkgs) lib fetchFromGitHub;
      in
      {
        packages = {
          delta =
            rustPlatform.buildRustPackage rec {
              pname = "delta";
              version = "7757769f797cc1795161119de3286719045235dd";

              release = false;

              OPENSSL_LIB_DIR = "${lib.getLib pkgs.openssl}/lib";
              OPENSSL_INCLUDE_DIR = "${lib.getDev pkgs.openssl}/include";

              buildInputs = with pkgs; [
                # rustPlatform.cargoSetupHook
                pkg-config
                openssl
              ];

              src = fetchFromGitHub {
                owner = "revoltchat";
                repo = pname;
                rev = version;
                sha256 = "sha256-3tVoLRlgTolJw3lSwqKJA+5uNzSy2xnvBi3zeyVBjOo=";
              };

              postInstall = ''
                rm $out/bin/dummy
                mv $out/bin/revolt $out/bin/${pname}
              '';

              cargoSha256 = "sha256-9u17rXiQ+qbTR4piiuS5Kzx4F0SCR2z3iEYGIIaNvjY=";
            };
        };
      });
}
