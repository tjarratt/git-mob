{
  description = "A git-mob implementation in bash and jq";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        callPackage = pkgs.lib.callPackageWith (pkgs // {
          version =
            if self ? rev
            then self.rev
            else "dirty";
        });

        gitMob = callPackage ./default.nix { };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        apps.default = flake-utils.lib.mkApp { drv = gitMob; };
        packages.default = gitMob;
        devShells.default = pkgs.mkShell {
          packages = [
            gitMob
            pkgs.nixpkgs-fmt
          ];
        };
      });
}
