{
  flake.modules.darwin.base =
    { config, ... }:
    {
      users.users.${config.host.user.name} = {
        name = config.host.user.name;
        home = "/Users/${config.host.user.name}";
      };

      system.primaryUser = config.host.user.name;
    };
}
