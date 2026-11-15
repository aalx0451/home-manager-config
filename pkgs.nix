{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      brightnessctl
      dua
      file
      firefox
      fractal
      grim
      networkmanagerapplet
      keepassxc
      playerctl
      python3
      swayidle
      swaylock
      vim
      wireguard-tools
      wl-clipboard
      wmenu
    ]
    ++ (with pkgs.llvmPackages; [
      (lib.hiPrio clang)
      clang-tools
    ])
    ++ (with inputs.yukigram.packages.${pkgs.stdenv.hostPlatform.system}; [
      nixpak
    ]);
}
