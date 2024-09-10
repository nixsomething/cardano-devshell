{
  inputs = {
    cardano-parts.url = "github:input-output-hk/cardano-parts";
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.cardano-parts.flakeModules.pkgs
      ];
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devshells.default = {
          packages = [
            inputs.cardano-parts.packages."${system}".cardano-address
            inputs.cardano-parts.packages."${system}".cardano-cli
            inputs.cardano-parts.packages."${system}".cardano-wallet
          ];
        };
      };
    };
}
