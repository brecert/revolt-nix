{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage {
  pname = "bonfire";
  version = "0afbcc065fff02dafd0788de620ee5d849714712";

  src = fetchFromGitHub {
    owner = "brecert";
    repo = "revolt-backend";
    rev = "0afbcc065fff02dafd0788de620ee5d849714712";
    sha256 = "sha256-ZXauxBnUjR8PnC7HmYY7o6PaR3paPTvwNGFsqzh1vu8=";
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
