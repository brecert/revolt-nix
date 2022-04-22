{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:
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
}
