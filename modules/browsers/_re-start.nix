# ./modules/browsers/_re-start.nix
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  zip,
  # "firefox" (the plain page plus a manifest.json) or "chrome" (an unpacked
  # extension for Chromium browsers)
  browser ? "firefox",
  # Settings that always win over what the settings menu saved, e.g. links
  settings ? {},
}:
buildNpmPackage {
  pname = "re-start-${browser}";
  # No tags upstream: 1.6.2 (public/manifest.json) plus the fix for refact0r/re-start#22
  version = "1.6.2-unstable-2026-09-01";
  src = fetchFromGitHub {
    owner = "refact0r";
    repo = "re-start";
    rev = "700fbc103a63754fba4ad363d99316830a179e41";
    hash = "sha256-lmmZdcrVAtTGQgW4nS6AJiwus5TS2dZndHtxcwEU/ig=";
  };
  npmDepsHash = "sha256-UmGub7lBbQj0xwvaP2JWp4+CD5wWe1lgDQVVumpatlk=";
  npmBuildScript = "build:${browser}";
  # The chrome build zips itself for the Web Store; jq is for the key below
  nativeBuildInputs = lib.optionals (browser == "chrome") [zip jq];
  env.nixSettings = builtins.toJSON settings;
  # re-start merges localStorage over its defaults; Nix's go on top of both
  postPatch = ''
    store=src/lib/stores/settings-store.svelte.js
    substituteInPlace $store \
      --replace-fail '{ ...defaultSettings, ...parsed }' '{ ...defaultSettings, ...parsed, ...nixSettings }' \
      --replace-fail '{ ...defaultSettings, ...detected }' '{ ...defaultSettings, ...detected, ...nixSettings }'
    { printf 'const nixSettings = %s\n' "$nixSettings"; cat $store; } > $store.new
    mv $store.new $store
  '';
  installPhase = ''
    runHook preInstall
    rm -f dist/${browser}/*.zip
    cp -r dist/${browser} $out
    runHook postInstall
  '';
  # An unpacked extension's id comes from its path, which changes with every
  # build, and its settings go with the id; a key pins the id instead
  # (bacdbccjbdiggdkmaejnjekjecpphnng). Only the public half, made for this
  postInstall = lib.optionalString (browser == "chrome") ''
    key=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkZV8Bg9rq0qqahkuEQRvUSXdt2PFg0OQ6PlW4skSI6ZaVcQhkADSlB5OervClP6mmu6esHJ6eG9JtzuxE3dY0bvMnV5HFgDhszgzIo8LRyLECBocRV/iisnblfu/aJduimo6krx9ZvN5BqXIxshLxn5phbRMXTyk/WHzMAj1h4bS9AhM6h4OOxWooDf49Cu8HhsuhClwkn7RXY3xDMVKQgdGdj/SIRKbsBB+GvNaWTTjwAHxkql8j78M2GJ5WQHUWDiO6cMeKurfkWuck9pzYfGfTdEnJP7f73b17ylzNCI6BiGKfk/kKXz8KkMQGPSMLK5U/zeWfU8yOitOycb6QQIDAQAB
    jq --arg key "$key" '.key = $key' $out/manifest.json > manifest.json
    mv manifest.json $out/manifest.json
  '';
}
