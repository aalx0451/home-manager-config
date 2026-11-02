{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    file
    firefox
    grim
    networkmanagerapplet
    python3
    swayidle
    telegram-desktop
    vim
    wl-clipboard
    wmenu
  ];
}
