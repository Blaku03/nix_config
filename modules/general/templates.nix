{
  flake.templates =
    let
      templates = [
        {
          name = "default";
          desc = "Default project template";
        }
        {
          name = "python";
          desc = "Python project template";
        }
      ];
    in
    builtins.listToAttrs (
      map (t: {
        name = t.name;
        value = {
          path = ../../templates/${t.name};
          description = t.desc;
        };
      }) templates
    );
}
