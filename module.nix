autoeq:
{ config
, lib
, ...
}:
let
  cfg = config.services.easyeffects;
  l = builtins // lib;

  inherit (l) mkOption mkIf escapeShellArg mapAttrs' elem filterAttrs;
  inherit (l.types) listOf enum;

  mkGraphicEQ = import ./graphiceq.nix { inherit lib; };

  allPresets = mkGraphicEQ "${autoeq}/results";
  selectedPresets = filterAttrs (n: _: elem n cfg.presets) allPresets;

  mkEasyFile = name: target: {
    name = "easyeffects/output/${escapeShellArg name}.json";
    value = { inherit target; };
  };
in {
  options.services.easyeffects = {
    presets = mkOption {
      type = listOf (enum (builtins.attrNames allPresets));
      default = [];
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile = mapAttrs' mkEasyFile selectedPresets;
  };
}
