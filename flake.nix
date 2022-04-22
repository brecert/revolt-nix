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

        inherit (pkgs) lib fetchFromGitHub mkYarnPackage;
      in
      {
        packages = {
          delta =
            rustPlatform.buildRustPackage rec {
              pname = "delta";
              version = "7757769f797cc1795161119de3286719045235dd";

              OPENSSL_LIB_DIR = "${lib.getLib pkgs.openssl}/lib";
              OPENSSL_INCLUDE_DIR = "${lib.getDev pkgs.openssl}/include";

              buildInputs = with pkgs; [
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

          revite = mkYarnPackage rec {
            pname = "revite";
            version = "4aad0493ae0d0c140bd9e1996c6eb2e48dd20bac";

            src = fetchFromGitHub {
              owner = "revoltchat";
              repo = pname;
              rev = version;
              sha256 = "sha256-j4pHi9GhO0ERVld76VTLYbRCuk7TR3BwoWQJ+KwMC0s=";

              leaveDotGit = true;
              fetchSubmodules = true;
            };

            nativeBuildInputs = with pkgs; [
              makeWrapper
            ];

            buildPhase = ''
              runHook preBuild

              pushd deps/client
              yarn --offline build
              popd

              runHook postBuild
            '';

            # use whatever static server you want to host /dist
            installPhase = ''
              runHook preInstall

              mkdir -p $out
              
              cp -R ./deps/client/dist $out/dist
              # cp -R ./node_modules $out

              runHook postInstall
            '';

            distPhase = "true";
            fixupPhase = ":";
          };

        };
      });
}
