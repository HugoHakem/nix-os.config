{ user, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_stateHome  = "${home}/.local/state"; in
{
  # Initializes Emacs with org-mode so we can tangle the main config
  # Emacs 29 includes org-mode now
  ".emacs.d/init.el" = {
    text = builtins.readFile ../shared/config/emacs/init.el;
  };
}
