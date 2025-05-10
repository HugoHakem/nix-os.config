# This is an example of how you can download a package from a github repo
self: super: with super; {
    oh-my-bash = stdenv.mkDerivation rec {
        name = "oh-my-bash";
        src = fetchFromGitHub {
            owner = "ohmybash";
            repo = "oh-my-bash";
            rev = "b25b2e80905abc41885dfd560154111e7261b4df"; # May 6, 2025
            sha256 = "sha256-/X9iHhDgHQ8vffTTR3k4f3nCxDfQqLYkeKSIpIzZqvE=";
          };
        buildInputs = [ unzip ]; # what fetchFromGitHub uses under the hood https://ryantm.github.io/nixpkgs/builders/fetchers/
        installPhase = ''
            mkdir -p $out
            cp -r * $out/
        '';
    };
}