{
  pkgs,
  lib,
  config,
  ...
}:

let
  mod = "Mod1";

  lockAndSleep = pkgs.writeShellScript "sway-lock-and-sleep" ''
    ${pkgs.swayidle}/bin/swayidle -w \
      timeout 1 '${pkgs.sway}/bin/swaymsg "output * power off"' \
      resume '${pkgs.sway}/bin/swaymsg "output * power on"' &
    IDLE_PID=$!

    ${pkgs.swaylock}/bin/swaylock -c 000000

    kill $IDLE_PID
    ${pkgs.sway}/bin/swaymsg "output * power on"
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = mod;
      terminal = "kitty";
      menu = "wmenu-run";

      left = "h";
      down = "j";
      up = "k";
      right = "l";

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 10.0;
      };

      bars = [
        {
          command = "waybar";
        }
      ];

      input = {
        "type:touchpad" = {
          dwt = "disabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };

        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:caps_toggle,grp_led:caps";
        };

        "1102:4639:DELL081C:00_044E:121F_Mouse" = {
          dwt = "disabled";
          scroll_method = "on_button_down";
          scroll_button = "274";
        };
      };

      startup = [
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        {
          command = ''
            swayidle -w \
              timeout 300 'swaylock -f -c 000000' \
              timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
              before-sleep 'swaylock -f -c 000000'
          '';
        }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+m" = "kill";
        "${mod}+Escape" = "exec ${lockAndSleep}";
        "Print" = "exec grim - | wl-copy";

        "--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "--locked XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        "--locked XF86AudioPlay" = "exec playerctl play-pause";
        "--locked XF86AudioPause" = "exec playerctl play-pause";
        "--locked XF86AudioPrev" = "exec playerctl previous";
        "--locked XF86AudioNext" = "exec playerctl next";
        "--locked XF86AudioStop" = "exec playerctl stop";

        "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
      };
    };

    extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next

      include /etc/sway/config.d/*
    '';
  };
}
