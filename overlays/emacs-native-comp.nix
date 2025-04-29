# EMACS UTILITIES
# This overlay is used to disable native compilation for Emacs. Since Sequoia 15.4.1, it is the proposed fix for emacs failing to build 
# See corresponding issue: https://github.com/NixOS/nixpkgs/issues/395169
self: super: {
  # emacs = super.emacs.override {
  #   withNativeCompilation = false;
  # };
}