{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    forester = {
      url = "git+https://tangled.org/jonmsterling.com/ocaml-forester/?ref=main";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      forester
    }:
    flake-utils.lib.eachSystem nixpkgs.lib.systems.flakeExposed (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        {
          packages.default = pkgs.haskellPackages.callPackage ./default.nix {};
          packages.forester = forester.packages.${system}.forester;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              haskellPackages.cabal2nix
            ];
          };
        }
    );
}
