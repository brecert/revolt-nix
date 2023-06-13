{ lib
, fetchFromGitHub
, pkg-config
, openssl
, git
, craneLib
}:
craneLib.buildPackage rec {
  pname = "delta";
  version = "20230611-5";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "backend";
    rev = version;
    sha256 = "sha256-+Hqlfayvrp4iTXdBkuyAS6PsuxcIBzAFzNr+7/jUyrE=";
    leaveDotGit = true; # git is used for build information
  };

  GIT_ORIGIN_URL = "https://github.com/revoltchat/backend.git";

  cargoExtraArgs = "--package revolt-delta";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Rest API Server for Revolt";
    homepage = "https://revolt.chat/";
    license = licenses.agpl3Plus;
  };
}
