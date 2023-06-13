{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "bonfire";
  version = "20230611-5";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "backend";
    rev = version;
    sha256 = "sha256-+Hqlfayvrp4iTXdBkuyAS6PsuxcIBzAFzNr+7/jUyrE=";
    leaveDotGit = true; # git is not used for information, but we keep it for parity with delta
  };

  cargoExtraArgs = "--package revolt-bonfire";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "WebSocket Events Server for Revolt";
    homepage = "https://revolt.chat/";
    license = licenses.agpl3Plus;
  };
}
