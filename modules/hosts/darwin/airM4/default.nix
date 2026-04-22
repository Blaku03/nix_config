{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "airM4";
    user.name = "bartekbrzyski";
    state = {
      darwin = 5;
      version = "22.05";
    };
    system = "aarch64-darwin";
  };
in
{
  flake.darwinConfigurations.airM4 = inputs.nix-darwin.lib.darwinSystem {
    system = host.system;
    specialArgs = { inherit inputs; };
    modules = with config.flake.modules.darwin; [
      base
      airM4
    ];
  };

  flake.modules.darwin.airM4 = {
    inherit host;

    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        fish
        git
        kitty
        neovim
        ssh
        starship
        claudeCode
        claudeConfig
        aerospace
      ];
    };
  };
}
