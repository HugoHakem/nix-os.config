self: super: {
  emacs = super.emacs.override {
    withNativeCompilation = false;
  };
}