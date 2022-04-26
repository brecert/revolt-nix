{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "8a10d2b866592aa13a099f0d5f1970f262407826";

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
    sha256 = "sha256-KwjJoCmeEvGCMLfP5KU2e7ixTuMTWbgkpwPkgXnthUc=";
  };

  postInstall = ''
    mv $out/bin/revolt $out/bin/${pname}
  '';

  doCheck = false;
  dontStrip = true;

  cargoSha256 = "sha256-+ClMlDiKud9Cfiyf3jNnfDbaCXC2/+tH2CoMKGNSHgw=";
}
