{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ghc-wasm-meta.url = "gitlab:haskell-wasm/ghc-wasm-meta?host=gitlab.haskell.org";
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ghc-wasm-meta
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              permittedInsecurePackages = [ "openssl-1.1.1w" ];
            };
          };
        in {
          devShells.default = pkgs.mkShell {
            packages =
              [ pkgs.hello
                pkgs.http-server
                pkgs.just
                pkgs.fd
                ghc-wasm-meta.packages.${system}.default
                pkgs.pkgsStatic.haskellPackages.cabal-gild
              ];
            shellHook = ''
              ${pkgs.hello}/bin/hello
            '';
          };
        }
      );
}
