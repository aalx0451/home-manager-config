{ pkgs, ... }:

{
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };
}
