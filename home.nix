{ lib, config, ... }:

{
  home.activation.registerApps = lib.hm.dag.entryAfter [ "copyApps" ] ''
    run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -f -R "${config.home.homeDirectory}/Applications/Home Manager Apps"
  '';

  # Desktop wallpaper (the login screen follows it). desktoppr comes from the
  # Homebrew cask in apps.nix; skip quietly if it isn't installed yet.
  home.activation.setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x /usr/local/bin/desktoppr ]; then
      run /usr/local/bin/desktoppr ${./config/wallpaper.jpg}
    else
      echo "desktoppr not found; skipping wallpaper"
    fi
  '';

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "rdave8";
      email = "84688513+rdave8@users.noreply.github.com";
    };
  };

  home.file.".hammerspoon/init.lua".source = ./config/hammerspoon/init.lua;
  # Karabiner must be able to write its config, so link the whole directory
  # to the repo (writable) instead of a read-only file in the Nix store.
  xdg.configFile."karabiner".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-config/config/karabiner";

  home.stateVersion = "26.05";
}
