{ lib, config, ... }:

{
  home.activation.registerApps = lib.hm.dag.entryAfter [ "copyApps" ] ''
    run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
      -f -R "${config.home.homeDirectory}/Applications/Home Manager Apps"
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
  xdg.configFile."karabiner/karabiner.json" = {
    source = ./config/karabiner/karabiner.json;
    force = true;
  };

  home.stateVersion = "26.05";
}
