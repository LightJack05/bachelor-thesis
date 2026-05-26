{
  description = "LaTeX project dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    latexShell.url = "git+https://gitea.lightjack.de/LightJack05/nix-library?dir=shells/latex";
    generalLib.url = "git+https://gitea.lightjack.de/LightJack05/nix-library?dir=lib/general";
    # --- Optional libs (uncomment input + merge lines below to enable) ---
    # podmanLib.url = "git+https://gitea.lightjack.de/LightJack05/nix-library?dir=lib/podman";
    # qemuLib.url = "git+https://gitea.lightjack.de/LightJack05/nix-library?dir=lib/qemu";
  };

  outputs = { self, nixpkgs, latexShell, generalLib, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # --- Add project-specific packages here ---
          extraPackages = [
          ];

          # --- Add project-specific shell hook here (env vars, startup messages, etc.) ---
          extraShellHook = ''
          '';

          # --- Optional lib packages (uncomment matching input above to enable) ---
          optionalPackages = []
          # ++ podmanLib.packages.${system}
          # ++ qemuLib.packages.${system}
          ;

          # --- Optional lib hooks (uncomment matching input above to enable) ---
          optionalHook = ""
          # + podmanLib.shellHook
          # + qemuLib.shellHook
          ;
        in
        {
          default = pkgs.mkShell {
            name = "latex-dev-shell";
            packages = latexShell.shellConfig.${system}.packages
              ++ generalLib.packages.${system}
              ++ optionalPackages
              ++ extraPackages;
            shellHook = latexShell.shellConfig.${system}.shellHook
              + generalLib.shellHook
              + optionalHook
              + extraShellHook;
          };
        }
      );
    };
}
