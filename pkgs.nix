{ pkgs, lib, ... }:

{
  home.packages =
    with pkgs;
    [
      brightnessctl
      dua
      file
      firefox
      grim
      networkmanagerapplet
      keepassxc
      playerctl
      python3
      swayidle
      swaylock
      telegram-desktop
      vim
      wireguard-tools
      wl-clipboard
      wmenu
    ]
    ++ (with pkgs.llvmPackages; [
      (lib.hiPrio clang)
      clang-tools
    ]);
}
