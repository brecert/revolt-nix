{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "january";
  version = "5d98afccf087cbebf3b7e0ac13f753c688c0a25a";

  OPENSSL_LIB_DIR = "${lib.getLib pkgs.openssl}/lib";
  OPENSSL_INCLUDE_DIR = "${lib.getDev pkgs.openssl}/include";

  buildInputs = with pkgs; [
    pkg-config
    openssl
  ];

  src = fetchFromGitHub {
    owner = "brecert";
    repo = pname;
    rev = version;
    sha256 = "sha256-QSIi8bQLIkZD3DZLHGnBDc0svyL2Sq7ScaFUeEPnFpM=";
  };

  cargoSha256 = "sha256-cu3rw2jIVRd0GdnDTuEbaDt7vx66cuGuzDF4oeOoR/c=";
}
