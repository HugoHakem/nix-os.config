{ inputs }: # modification of the https://github.com/nix-community/nixGL/blob/main/flake.nix

self: super:
#     inputs.nixgl.overlays.default self super
let
  isIntelX86Platform = self.system == "x86_64-linux";
in {
  nixgl = import "${inputs.nixgl}/default.nix" {
    pkgs = self;
    enable32bits = isIntelX86Platform;
    enableIntelX86Extensions = isIntelX86Platform;
    nvidiaVersion = "570.133.20"; #builtins.toFile "nvidia-version.txt" (builtins.readFile /proc/driver/nvidia/version); # adding the nvidiaVersion
  };
}
# The solution to make it work should be here: https://github.com/nix-community/nixGL/pull/197/files