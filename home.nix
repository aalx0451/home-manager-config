{ config, pkgs, ... }:

{
  home.username = "lina";
  home.homeDirectory = "/home/lina";

  home.stateVersion = "26.05";

  home.packages = [
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
