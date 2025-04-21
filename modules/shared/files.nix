{ pkgs, config, user, ... }:

{
    # Initializes Emacs with org-mode so we can tangle the main config
    # Emacs 29 includes org-mode now
    ".emacs.d/init.el" = {
    text = builtins.readFile ../shared/config/emacs/init.el;
  };
}
