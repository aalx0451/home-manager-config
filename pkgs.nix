{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file
    firefox
    python3
    telegram-desktop
    vim
  ];
}
