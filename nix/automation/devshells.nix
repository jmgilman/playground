{ inputs
, cell
}:
let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;
in
l.mapAttrs (_: std.std.lib.mkShell) {
  default = { ... }: {
    name = "playground devshell";
    imports = [ std.std.devshellProfiles.default ];
    nixago = [
      cell.configs.cocogitto
      cell.configs.conform
      cell.configs.lefthook
      cell.configs.prettier
      cell.configs.treefmt
    ];
    commands = [
      {
        name = "fmt";
        command = "treefmt";
        help = "Formats the book's markdown files";
        category = "Development";
      }
    ];
  };
}
