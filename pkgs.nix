{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    file
    firefox
    grim
    networkmanagerapplet
    playerctl
    python3
    swayidle
    swaylock
    telegram-desktop
    vim
    wl-clipboard
    wmenu
  ];
}
