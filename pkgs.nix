{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    file
    firefox
    grim
    python3
    telegram-desktop
    vim
  ];
}
