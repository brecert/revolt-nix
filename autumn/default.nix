{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "autumn";
  version = "5bb15dbb5ca4b6cd167a92c4f264bdc09c76f0fd";

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
    sha256 = "sha256-syE582nEZG+HsOqeOqPOrc+zQUNsSYU4jjndb4cbjQ8=";
  };

  cargoSha256 = "sha256-+/15HyPW2MnSYJuYBRmOKjgg3XH9poce3XEEcb4UKiA=";
}