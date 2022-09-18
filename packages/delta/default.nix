{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "delta";
  version = "6d549a35b8be0fc0983aa09a561953f43868d8c4";

  src = fetchFromGitHub {
    owner = "brecert";
    repo = "revolt-backend";
    rev = "6d549a35b8be0fc0983aa09a561953f43868d8c4";
    sha256 = "sha256-wgftIgNqNixGfbQIyPIjxy0Ul+2TjLhllA/F+79U5VI=";
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
