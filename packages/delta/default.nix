{ lib
, fetchFromGitHub
, pkg-config
, openssl
, git
, craneLib
}:
craneLib.buildPackage rec {
  pname = "delta";
  version = "0afbcc065fff02dafd0788de620ee5d849714712";

  src = fetchFromGitHub {
    owner = "brecert";
    repo = "revolt-backend";
    rev = "0afbcc065fff02dafd0788de620ee5d849714712";
    sha256 = "sha256-ZXauxBnUjR8PnC7HmYY7o6PaR3paPTvwNGFsqzh1vu8=";
    leaveDotGit = true; # git is used for build information
  };

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
