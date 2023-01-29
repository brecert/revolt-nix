{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "autumn";
  version = "1cb06c3644dfda801f39868d4a51fe48e5595096";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "autumn";
    rev = version;
    sha256 = "sha256-howOXplrbtspYbHG1v+onVYl34lwgTDHbeO1rmAUIRw=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Pluggable file server micro-service";
    homepage = "https://github.com/revoltchat/autumn";
    license = licenses.agpl3Plus;
  };
}
