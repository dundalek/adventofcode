with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "advent-env";
  buildInputs = [
    luajit
    luajitPackages.luarocks
  ];
  shellHook = ''
    export PATH="$HOME/.luarocks/bin:$PATH"
  '';
}
