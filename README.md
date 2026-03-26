# nix_config

Change name of Macbook ex. airM4

```
sudo scutil --set HostName airM4
sudo scutil --set ComputerName airM4
sudo scutil --set LocalHostName airM4
```

Download xcode tools

```
xcode-select --install
```

Install lix:

```
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```

Install nix-darwin

```
nix run nix-darwin --extra-expermiental-features "nix-command flakes" -- switch --flake ~/.config/nix#airM4
```
