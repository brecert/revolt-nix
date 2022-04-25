{ pkgs
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, mkYarnPackage ? pkgs.mkYarnPackage
, VITE_API_URL ? "https://api.revolt.chat"
, VITE_THEMES_URL ? "https://themes.revolt.chat"
}:
mkYarnPackage rec {
  pname = "revite";
  version = "4aad0493ae0d0c140bd9e1996c6eb2e48dd20bac";

  src = fetchFromGitHub {
    owner = "revoltchat";
    repo = pname;
    rev = version;
    sha256 = "sha256-j4pHi9GhO0ERVld76VTLYbRCuk7TR3BwoWQJ+KwMC0s=";

    leaveDotGit = true;
    fetchSubmodules = true;
  };

  inherit VITE_API_URL VITE_THEMES_URL;

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pushd deps/client
    yarn --offline build
    popd

    runHook postBuild
  '';

  # use whatever static server you want to host /dist
  installPhase = ''
    runHook preInstall

    mkdir -p $out
      
    cp -R ./deps/client/dist $out/dist
    # cp -R ./node_modules $out

    runHook postInstall
  '';

  distPhase = "true";
  fixupPhase = ":";
}
