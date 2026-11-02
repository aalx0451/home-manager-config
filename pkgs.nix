{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    file
    firefox
    grim
    networkmanagerapplet
    python3
    telegram-desktop
    vim
    wl-clipboard
  ];
}
