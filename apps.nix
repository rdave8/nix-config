{ pkgs, username, ... }:

{
  nix-homebrew.taps."${username}/homebrew-local" = pkgs.runCommandLocal "homebrew-local" { } ''
    cp -r ${./tap} $out
  '';
  nix-homebrew.trust.taps = [ "${username}/local" ];

  homebrew.casks = [
    "hammerspoon"
    "karabiner-elements"
    "focusrite-control-2"
    "fl-studio"
    "discord"
    "${username}/local/rex"
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      brave
      claude-code
      spotify
      scroll-reverser
      iina
      python3
      nodejs
    ];

    programs.uv.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.obsidian.enable = true;
    programs.vscode.enable = true;
    programs.lazygit.enable = true;
  };
}
