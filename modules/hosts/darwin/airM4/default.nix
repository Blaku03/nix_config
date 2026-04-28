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

    # # Linux builder for building x86_64/aarch64-linux packages on macOS.
    # nix.linux-builder = {
    #   enable = true;
    #   ephemeral = true;

    #   # How many different packages can build at the same time.
    #   maxJobs = 2;

    #   supportedFeatures = [
    #     "kvm"
    #     "benchmark"
    #     "big-parallel"
    #   ];

    #   config = {
    #     virtualisation = {
    #       darwin-builder = {
    #         diskSize = 40 * 1024;
    #         memorySize = 10 * 1024;
    #       };
    #       cores = 8;
    #     };

    #     # Use all virtual cores for a single build inside the Linux VM.
    #     nix.settings.cores = 0;
    #   };
    # };

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
