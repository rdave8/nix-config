{
  inputs,
  config,
  pkgs,
  username,
  ...
}:

let
  brewVersion = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.brew-src.original.ref;
in
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.${username}.home = "/Users/${username}";
  system.primaryUser = username;

  system.defaults.dock = { };

  system.defaults.CustomUserPreferences."com.pilotmoon.scroll-reverser" = {
    InvertScrollingOn = true;
  };

  nix-homebrew = {
    enable = true;
    user = username;
    extraEnv.HOMEBREW_GIT_PATH = "${pkgs.git}/bin/git";
    package = inputs.brew-src // {
      name = "brew-${brewVersion}";
      version = brewVersion;
    };
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = import ./home.nix;
  };

  system.stateVersion = 6;
}
