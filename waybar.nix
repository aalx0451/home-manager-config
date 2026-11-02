{ pkgs, lib, ... }:

let
  statusConfig = {
    datesSince = [
      [
        2023
        7
        24
        16
        4
      ]
      [
        2026
        7
        18
        18
        40
      ]
    ];
    datesUntil = [ ];
    batteryPath = "/sys/class/power_supply/BAT0/uevent";
    lowChargeThreshold = 5;
  };

  formatDatetime = d: "datetime(${lib.concatStringsSep ", " (map toString d)})";

  formatTuple =
    list:
    if list == [ ] then
      "()"
    else
      "(\n        " + lib.concatMapStringsSep ",\n        " formatDatetime list + ",\n    )";

  statusScript =
    pkgs.writers.writePython3 "waybar-status"
      {
        flakeIgnore = [
          "E501"
          "W293"
        ];
      }
      ''
        import time
        from dataclasses import dataclass
        from datetime import datetime
        from pathlib import Path


        @dataclass(frozen=True, slots=True)
        class Config:
            dates_since: tuple[datetime, ...] = ${formatTuple statusConfig.datesSince}
            dates_until: tuple[datetime, ...] = ${formatTuple statusConfig.datesUntil}
            battery_path: Path = Path("${statusConfig.batteryPath}")
            low_charge_threshold: int = ${toString statusConfig.lowChargeThreshold}


        def read_battery(path: Path) -> tuple[str | None, int | None]:
            status, charge = None, None
            try:
                with path.open() as f:
                    for line in f:
                        if line.startswith("POWER_SUPPLY_STATUS="):
                            status = line.partition("=")[2].strip()
                        elif line.startswith("POWER_SUPPLY_CAPACITY="):
                            charge = int(line.partition("=")[2])
                        if status is not None and charge is not None:
                            break
            except OSError:
                pass
            return status, charge


        def format_date(
            now: datetime, dates_since: tuple[datetime, ...], dates_until: tuple[datetime, ...]
        ) -> str:
            parts = [
                "::".join(f"{(now - d).days:04d}" for d in dates_since),
                "::".join(f"{(d - now).days:04d}" for d in dates_until),
                now.strftime("%j:%Y:%m:%d:%H:%M:%S"),
            ]
            return ":".join(p for p in parts if p)


        def format_battery(status: str | None, charge: int | None, threshold: int) -> str:
            if charge is None:
                return ""
            text = f"{charge}% ({status})" if status else f"{charge}%"
            if status == "Discharging" and charge <= threshold:
                return f"<span foreground='red' weight='bold'>! {text}</span>"
            return text


        def main() -> None:
            cfg = Config()
            while True:
                now = datetime.now()
                date_str = format_date(now, cfg.dates_since, cfg.dates_until)
                batt_str = format_battery(*read_battery(cfg.battery_path), cfg.low_charge_threshold)
                print(f"{date_str} {batt_str}".rstrip(), flush=True)
                time.sleep(1.0 - (time.time() % 1.0))


        if __name__ == "__main__":
            main()
      '';
in
{
  programs.waybar = {
    settings = {
      mainBar = {
        backlight = {
          format = "*:{percent} ";
        };

        "custom/status" = {
          exec = "${statusScript}";
        };

        pulseaudio = {
          format = " {format_source}:{volume} ";
          format-muted = " D:{volume} ";
          format-source = "A";
          format-source-muted = "M";
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };

        ipc = true;
        modules-left = [ "sway/workspaces" ];
        modules-right = [
          "custom/status"
          "pulseaudio"
          "backlight"
          "tray"
        ];
      };
    };

    style = ''
      #waybar {
        background: black;
        font-size: 10pt;
        font-family: "JetBrainsMono Nerd Font", Monospace;
        min-height: 0;
        border-bottom: 1px solid #333;
      }

      #workspaces *, .modules-right > * > * {
        color: white;
      }

      #workspaces > * {
        padding: 0 4px;
        border-right: 1px solid #333;
        border-radius: 0;
        background: black;
      }

      .modules-right > * > * {
        padding: 0 4px;
      }

      #workspaces > .visible,
      #workspaces > .focused {
        background: #285577;
      }

      #workspaces > .urgent {
        background: #900000;
      }
    '';
  };
}
