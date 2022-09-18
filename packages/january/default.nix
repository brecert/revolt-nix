{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "january";
  version = "d8a94105f0abf81017f0882056b3e03018b4450b";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "january";
    rev = version;
    sha256 = "sha256-TJM2iqvLuOOnAQts7tcT1fXW1Ydi/Uu4UDX9uxh690g=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Image proxy and embed generator";
    homepage = "https://github.com/revoltchat/january";
    license = licenses.agpl3Plus;
  };
}
