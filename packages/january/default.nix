{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:

craneLib.buildPackage rec {
  pname = "january";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "january";
    rev = version;
    sha256 = "sha256-l3PRA+1rk12TDrFpxD9bGhcw6L4f6yWYqodamcVafsk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Image proxy and embed generator";
    homepage = "https://github.com/revoltchat/january";
    license = licenses.agpl3Plus;
  };
}
