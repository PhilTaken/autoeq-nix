{
  lib
}:
let
  l = builtins // lib;
  inherit (l) length attrValues replaceStrings readDir filterAttrs hasInfix foldl' recursiveUpdate attrNames;
in
rec {
  mkFilename = replaceStrings [" "] ["_"];

  mkBand = {
    mode ? "RLC (BT)"
  , mute ? false
  , q ? 4.36
  , slope ? "x1"
  , solo ? false
  , type ? "Bell"
  , frequency
  , gain
  }: {
    inherit mode mute q slope solo type;
  };

  mkEqualizer = {
    bands
  , mode ? "FFT"
  , input-gain ? 2.0
  , output-gain ? 2.3
  , balance ? 1.
  , split-channels ? false
  }: {
    output = {
      blocklist = [];

      "equalizer#0" = {
        inherit mode input-gain output-gain balance split-channels;
        bypass = false;
        left = bands;
        right = bands;

        num-bands = length (attrValues bands);
        pitch-left = 0.0;
        pitch-right = 0.0;
      };

      plugins_order = [
        "equalizer#0"
      ];
    };
  };

  processDir = processFile: fileFilter: pathStr: processDir' { } pathStr fileFilter processFile;
  processDir' = acc: pathStr: fileFilter: processFile:
    let
      path = pathStr;
      toPath = s: path + "/${s}";
      contents = readDir path;

      dirs = filterAttrs (k: v: v == "directory") contents;
      files = filterAttrs (k: v: v == "regular" && (fileFilter k)) contents;

      dirs' = foldl'
        (acc: d: recursiveUpdate acc (processDir processFile fileFilter (pathStr + "/" + d)))
        { }
        (attrNames dirs);

      files' = foldl' (acc: f: recursiveUpdate acc (processFile (toPath f) f)) { } (attrNames files);
    in recursiveUpdate dirs' files';
}
