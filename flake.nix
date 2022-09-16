{
  inputs.n2c.url = "github:nlewo/nix2container";
  inputs.std.url = "github:jmgilman/std/oci";
  inputs.nixpkgs.url = "nixpkgs";
  outputs = { std, ... } @ inputs:
    std.growOn
      {
        inherit inputs;
        cellsFrom = ./nix;
        cellBlocks = [
          (std.blockTypes.devshells "devshells")
          (std.blockTypes.nixago "configs")
        ];
      }
      {
        devShells = std.harvest inputs.self [ "automation" "devshells" ];
      };
}
