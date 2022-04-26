{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "bonfire";
  version = "95ab4985cafe98cbd45f208d271fa16a24a2e318";

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
    sha256 = "sha256-EB6YZ6rZVkReQr3pZ3n83gAx9vOPbQ6BCWkRnA9YZPA=";
  };

  cargoSha256 = "sha256-86VmRrWpenlAuzXf3gC1UZ8htnfzlW4QU0Lh46i5rfI=";
}
