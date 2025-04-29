# EMACS UTILITIES
# let
#   emacsOverlaySha256 = "sha256:019q0hm6r05mqiqmfk1zgjqbq5xls4ykh72avdyyh74yhavd1hkb";
# in
#   import (builtins.fetchTarball {
#     url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
#     sha256 = emacsOverlaySha256;
#   })
self: super: {} # TO DELETE IF YOU WANT TO ENABLE EMACS UTILITIES

