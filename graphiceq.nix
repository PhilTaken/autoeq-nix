# TODO:
# - generate reduced set of 32 bands for easyeffects config
#   (ifd? external tranformation using python?)

{ lib }:
let
  l = builtins // lib;

  autolib = import ./lib.nix { inherit lib; };

  inherit (l) splitString last removePrefix listToAttrs head toInt imap0 hasInfix;
  inherit (autolib) mkBand mkEqualizer processDir;

  # ----
  getPresetName = file: l.removeSuffix " GraphicEQ.txt" (l.last (l.splitString "/" file));

  mkPresetFromFile = file: let
    content = builtins.readFile file;
    paramLines = splitString "; " (removePrefix "GraphicEQ: " content);
    bands = listToAttrs (imap0 (i: line: let
      foo = splitString " " line;
    in {
      name = "band#${toString i}";
      value = mkBand {
        frequency = toInt (head foo);
        gain = last foo;
      };
    }) paramLines);
  in builtins.toJSON (mkEqualizer { inherit bands; });

  processFile = file: name: {
    "${getPresetName name}" = mkPresetFromFile file;
  };

in processDir processFile (hasInfix "GraphicEQ")
