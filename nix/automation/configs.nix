{ inputs
, cell
}:
let
  inherit (inputs) nixpkgs std;
  l = nixpkgs.lib // builtins;
in
{
  cocogitto = std.std.lib.mkNixago {
    configData = {
      branch_whitelist = [ "master" ];
      changelog = {
        authors = [
          {
            username = "jmgilman";
            signature = "Joshua Gilman";
          }
        ];
        path = "CHANGELOG.md";
        template = "remote";
        remote = "github.com";
        repository = "playground";
        owner = "jmgilman";
      };
    };
    output = "cog.toml";
    format = "toml";
    hook.mode = "copy";
    commands = [{ package = nixpkgs.cocogitto; }];
  };
  conform = std.std.nixago.conform {
    configData = {
      commit = {
        header = { length = 89; };
        conventional = {
          types = [
            "build"
            "chore"
            "ci"
            "docs"
            "feat"
            "fix"
            "perf"
            "refactor"
            "style"
            "test"
          ];
        };
      };
    };
  };
  lefthook = std.std.nixago.lefthook {
    configData = {
      commit-msg = {
        commands = {
          conform = {
            run = "${nixpkgs.conform}/bin/conform enforce --commit-msg-file {1}";
          };
        };
      };
      pre-commit = {
        commands = {
          treefmt = {
            run = "${nixpkgs.treefmt}/bin/treefmt {staged_files}";
          };
        };
      };
    };
  };
  prettier = std.std.lib.mkNixago
    {
      configData = {
        printWidth = 80;
        proseWrap = "always";
      };
      output = ".prettierrc";
      format = "json";
      packages = [ nixpkgs.nodePackages.prettier ];
    };
  treefmt = std.std.nixago.treefmt
    {
      configData = {
        formatter = {
          nix = {
            command = "nixpkgs-fmt";
            includes = [ "*.nix" ];
          };
          prettier = {
            command = "prettier";
            options = [ "--write" ];
            includes = [
              "*.md"
            ];
          };
        };
      };
      packages = [ nixpkgs.nixpkgs-fmt ];
    };
}
