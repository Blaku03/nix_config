{ self, inputs, ... }:
let
  nixConfigDir = "$HOME/.config/nix";
  primaryUser = "bartekbrzyski";
in
{
  flake.darwinConfigurations.airM4 = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit nixConfigDir primaryUser; };
    modules = [
      self.darwinModules.systemBase

      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager

      {
        inputs.home-manager.useGlobalPkgs = true;
        inputs.home-manager.useUserPackages = true;
        inputs.home-manager.extraSpecialArgs = { inherit nixConfigDir primaryUser; };
        inputs.home-manager.backupFileExtension = "bak";
        inputs.home-manager.users.${primaryUser} = self.homeModules.homeBase;
      }
    ];
  };
}
