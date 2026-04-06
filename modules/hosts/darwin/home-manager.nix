{
  flake.modules.darwin.base =
    {
      self,
      inputs,
      config,
      ...
    }:
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs self; };
      home-manager.backupFileExtension = "bak";
      home-manager.users.${config.my.user.name} = {
        imports = builtins.attrValues self.modules.homeManager;

        my.user.name = config.my.user.name;
        my.nixConfigDir = config.my.nixConfigDir;
      };
    };
}
