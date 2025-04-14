final: prev: {
  my-vscode = prev.vscode-with-extensions.override {
    vscode = prev.vscode;
    vscodeExtensions = with prev.vscode-marketplace; [
      # Add your extensions here
      ## nix interpreter
      bbenoist.nix
      ## ruff
      charliermarsh.ruff
      ## copilot
      github.copilot
      github.copilot-chat
      ## python
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ## jupyter
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ## remote
      # ms-vscode-remote.vscode-remote-extensionpack # not handled
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-wsl
      ms-vscode.remote-explorer
      ms-vscode.remote-server
      ## collaboration
      ms-vsliveshare.vsliveshare
    ];
    ## to add package from open-vsx-release
    #  ++ (with prev.open-vsx-release; [
    #   rust-lang.rust-analyzer
    #   golang.go
    # ]);
  };
}
### Ressources
# extension pack not handled: https://github.com/nix-community/nix-vscode-extensions?tab=readme-ov-file#explore:~:text=We%20don%27t%20automatically%20handle%20extension%20packs.%20You%20should%20look%20up%20extensions%20in%20a%20pack%20and%20explicitly%20write%20all%20necessary%20extensions.
# some example https://wiki.nixos.org/wiki/Visual_Studio_Code