_: super:
    let
    emacs = super.emacs-unstable.override { withNativeCompilation = false; };
    in
    {
    inherit emacs;
    notmuch = pkgs.notmuch.override { inherit emacs; };
    }