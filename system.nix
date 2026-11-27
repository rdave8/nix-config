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

  system.defaults.dock = {
    autohide = true;
    persistent-apps = [ ]; # no pinned apps
    persistent-others = [ ]; # no folders/stacks (e.g. Downloads) on the right side
    static-only = true; # only show apps that are open
    show-recents = false; # no "recently opened" apps section
    minimize-to-application = true; # minimize into the app's icon
    autohide-delay = 0.0; # no pause before the Dock appears
    autohide-time-modifier = 0.0; # Dock shows/hides instantly
    mineffect = "scale"; # faster than genie
  };

  # Reducing animations. Writing universalaccess needs Full Disk Access
  # for the terminal running darwin-rebuild.
  system.defaults.universalaccess = {
    reduceMotion = true;
    reduceTransparency = true;
  };

  system.defaults.NSGlobalDomain = {
    NSAutomaticWindowAnimationsEnabled = false;
    NSWindowResizeTime = 0.001;
    NSUseAnimatedFocusRing = false;
    NSScrollAnimationEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false; # autocorrect off
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false; # double-space doesn't insert a period
    NSAutomaticQuoteSubstitutionEnabled = false; # no smart quotes
    NSAutomaticDashSubstitutionEnabled = false; # no smart dashes
    NSAutomaticInlinePredictionEnabled = false; # no inline predictive text
  };

  system.defaults.controlcenter.NowPlaying = false; # hide Now Playing menu bar icon

  system.defaults.WindowManager = {
    StandardHideWidgets = true;
    StageManagerHideWidgets = true;
    EnableStandardClickToShowDesktop = false; # clicking wallpaper doesn't reveal desktop
  };

  # Mouse tracking speed only; trackpad speed is separate (com.apple.trackpad.scaling)
  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 1.5;

  system.defaults.CustomUserPreferences = {
    NSGlobalDomain = {
      "com.apple.mouse.linear" = true; # pointer acceleration off
      WebAutomaticSpellingCorrectionEnabled = false; # autocorrect off in web views
    };
    "com.pilotmoon.scroll-reverser".InvertScrollingOn = true;
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
