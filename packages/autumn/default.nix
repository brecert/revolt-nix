{ lib
, fetchFromGitHub
, pkg-config
, openssl
, craneLib
}:
craneLib.buildPackage rec {
  pname = "autumn";
  version = "d74bafc66fb09f7ffdf19c471ab2eccf15a0d059";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = "autumn";
    rev = version;
    sha256 = "sha256-4didjo6JvWyQYOTWT0temwfN06B9nPijZhP0iJtEVFw=";
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
