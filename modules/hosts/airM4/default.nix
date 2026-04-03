{ self, inputs, ... }:
{
  flake.darwinConfigurations.airM4 = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.darwinModules.core
      self.darwinModules.macos
      self.darwinModules.packages
      self.darwinModules.homebrew
      self.darwinModules.home-manager

      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager

      {
        my.user.name = "bartekbrzyski";
        my.nixConfigDir = "$HOME/.config/nix";
      }
    ];
  };
}
