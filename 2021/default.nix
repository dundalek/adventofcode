with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "advent-env";
  buildInputs = [
    luajit
  ];
}
