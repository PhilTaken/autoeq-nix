# AutoEQ-Nix (name subject to change)

### **n.b. very wip**

## Overview

A [home-manager](https://github.com/nix-community/home-manager) module that allows you to declaratively manage your [easyeffects](https://github.com/wwmm/easyeffects) presets by sourcing the ones from [AutoEQ](https://github.com/jaakkopasanen/AutoEq).


## TODO

- source, process and commit autoeq presets in ci
    - then only source the generated files in the home-manager module
    - don't make users fetch the whole autoeq repository (very big in size)
- process GraphicEQ files properly (too many bands currently)
    - reduce to 32 bands using python script
- process all other types of presets

- extend to generically define all kinds of presets (?)
