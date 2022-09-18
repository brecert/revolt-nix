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
}:
stdenv.mkDerivation {
  name = "mongodb-5.0.6";
  
  src = fetchurl {
    url = "https://repo.mongodb.org/apt/ubuntu/dists/focal/mongodb-org/5.0/multiverse/binary-amd64/mongodb-org-server_5.0.6_amd64.deb";
    hash = "sha256-Rk43PNQN8p2/3XDDjWOzJmzBjs39CR06kLrTtr+5ngo=";
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
