# TODO: generate in ci without needing to have huge autoeq repo as input
{
  description = "home-manager module providing autoeq presets for easyeffects";

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    autoeq = {
      url = "github:jaakkopasanen/AutoEq";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs-lib) lib;
  in {
    hmModules.autoeq-nix = import ./module.nix inputs.autoeq;

    lib = import ./lib;

    # output for testing/evaling using `nix eval .#presets.graphiceq`
    # could be used for ci
    presets = {
      grapiceq = let
        mkGraphicEQ = import ./graphiceq.nix { inherit (inputs.nixpkgs-lib) lib; };
        allpresets = mkGraphicEQ "${inputs.autoeq}/results";
        mypreset = lib.filterAttrs (n: v: builtins.elem n ["TFZ Queen"]) allpresets;
      in mypreset;
    };
  };
}
