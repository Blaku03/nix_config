{ self, inputs, ... }:
{
  flake.darwinConfigurations.airM4 = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.modules.darwin.base

      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager

      {
        my.user.name = "bartekbrzyski";
        my.nixConfigDir = "$HOME/.config/nix"; # Intentionally a shell-only value used by the shell aliases
      }
    ];
  };
}
