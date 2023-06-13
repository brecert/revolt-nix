{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "autumn";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "autumn";
    rev = version;
    sha256 = "sha256-KoS9Jzc3wVYf1kinjMq+EcjPPCi0Psw00BQhiQOGJIo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Pluggable file server micro-service";
    homepage = "https://github.com/revoltchat/autumn";
    license = licenses.agpl3Plus;
  };
}
