{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    file
    firefox
    python3
    telegram-desktop
    vim
  ];
}
