{
  pkgs ? import <nixpkgs> {},
  beamPackages ? pkgs.beamPackages,
  esbuild ? pkgs.esbuild,
}: let
  pname = "hackernews_clone";
  src = ./.;
  version = "0.0.1";
  mixFodDeps = beamPackages.fetchMixDeps {
    inherit src version;
    pname = "mix-deps-${pname}";
    sha256 = "sha256-yPgjPe9zpEcyqtE017bXzon96GCI0tnhhlSGcfiZoXw=";
  };
in
  beamPackages.mixRelease {
    inherit src pname version mixFodDeps;
    buildInputs = [esbuild];
    postBuild = ''
      mix do deps.loadpaths --no-deps-check, phx.digest
      mix phx.digest --no-deps-check
    '';
  }
