{ pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./../flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in import nixpkgs {},
}:
let
  venvDir = "./.venv";
in
  pkgs.mkShell {
    name = "docs";
    buildInputs = with pkgs; [
      uv
    ];
    shellHook = ''
      # Avoid annoying prompts from keyring libraries asking for gnome-keyring, kwallet, etc. (especially useful on headless servers).
      export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring

      # allow uv pip to install wheels
      unset SOURCE_DATE_EPOCH

      # Triggers creation/activation of the .venv virtualenv.
      if [ -d "${venvDir}" ]; then
        echo "Skipping venv creation, '${venvDir}' already exists"
      else
        echo "Creating new venv environment in path: '${venvDir}'"
        uv venv "${venvDir}"
      fi

      # FEEL FREE TO UPDATE WITH --extra name-of-extra-dependencies-in-pyproject.toml
      uv sync
      source "${venvDir}/bin/activate"
    '';
  }

