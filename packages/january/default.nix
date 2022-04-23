{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, rustPlatform ? pkgs.rustPlatform  
}:
rustPlatform.buildRustPackage rec {
  pname = "january";
  version = "04830ca82c6310033ca21d6615f4fe9894d12fe7";

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
    sha256 = "sha256-f5K9w3g7BW26ndyXrrn9tqu7D8SoU1g1VdpZEbikgCE=";
  };

  cargoSha256 = "sha256-mxH7pZwWmDaM50Cy+xh/j59tqne5VUwGlM4vS9ujdDw=";
}
