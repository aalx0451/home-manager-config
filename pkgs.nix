{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file
    firefox
  ];
}
