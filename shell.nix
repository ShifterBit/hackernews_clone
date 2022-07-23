{
  pkgs ? import <nixpkgs> {},
  mkShellNoCC ? pkgs.mkShellNoCC,
}:
mkShellNoCC {
  buildInputs = with pkgs; [elixir erlang inotify-tools sqlite];
  shellHook = '' 
    export RELEASE_COOKIE=$(mix phx.gen.secret)
  '';
}
