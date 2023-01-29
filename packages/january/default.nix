{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "january";
  version = "3aa7989fd24aca76edbcdd556cd22bd9e5c4785c";

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

  meta = with lib; {
    description = "Image proxy and embed generator";
    homepage = "https://github.com/revoltchat/january";
    license = licenses.agpl3Plus;
  };
}
