{ config, pkgs,  ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {

      "$mod" = "SUPER";

      exec-once = [
        "awww"
        "waybar"
        "mako"
        "walker --gproc"
      ];

      bind = [
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        "bindm = $mod, mouse:272, movewindow"
        "bindm = $mod, mouse:273, resizewindow"

        "$mod, RETURN, exec, kitty"
        "ALT, space, exec, walker"
        "$mod SHIFT, M, exit"
        "$mod, W, killactive"
      ];
    };
  };

  # Mako config
  services.mako = {
    enable = true;
  };

  # Waybar config
  programs.waybar = {
    enable = true;
  };

}
  
