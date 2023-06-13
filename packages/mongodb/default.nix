# repackage here because it's unfree software so nix doesn't build by default (from my understanding)
{ lib
, stdenv
, fetchurl
, dpkg
, glibc
, xz
, curl
, openssl_1_1
, gcc-unwrapped 
, autoPatchelfHook
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "mongodb";
  version = "6.0.6";
  
  src = fetchurl {
    url = "https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/6.0/multiverse/binary-amd64/mongodb-org-server_6.0.6_amd64.deb";
    hash = "sha256-HfXBxM2KUO4rvhvYDKZYbobuw5Ib6+UPeDr/1wQSH+E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glibc
    openssl_1_1
    xz
    curl
    gcc-unwrapped
  ];
  
  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mkdir $out/bin
    mv $out/usr/bin/ $out/
  '';
}
