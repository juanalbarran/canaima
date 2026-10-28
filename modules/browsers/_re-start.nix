# ./modules/browsers/_re-start.nix
{
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "re-start";
  # No tags upstream: 1.6.2 (public/manifest.json) plus the fix for refact0r/re-start#22
  version = "1.6.2-unstable-2026-09-01";
  src = fetchFromGitHub {
    owner = "refact0r";
    repo = "re-start";
    rev = "700fbc103a63754fba4ad363d99316830a179e41";
    hash = "sha256-lmmZdcrVAtTGQgW4nS6AJiwus5TS2dZndHtxcwEU/ig=";
  };
  npmDepsHash = "sha256-UmGub7lBbQj0xwvaP2JWp4+CD5wWe1lgDQVVumpatlk=";
  # The Firefox build is the plain page plus a manifest.json nobody reads here
  installPhase = ''
    runHook preInstall
    cp -r dist/firefox $out
    runHook postInstall
  '';
}
