{ config, pkgs, ... }:
{
  # imports = [
    # ./sway.nix
    # ./hyprland.nix
  # ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "audisho";
  # home.homeDirectory = "/home/audisho";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  # home-manager = {
    # useUserPackages = true;
    # useGlobalPkgs = true;

    # users.audisho = { pkgs, ... }: {
      # programs.home-manager.enable = true;

      home = {
        stateVersion = "23.11";
        username = "audisho";
        homeDirectory = "/home/audisho";
        packages = with pkgs; [
          httpie
          bat
          micro
          neofetch
          nextcloud-client
          keepassxc
          android-tools
          betterdiscord-installer
          betterdiscordctl
          nodejs
          nodePackages_latest.pnpm
          fnm
          discord
          steam-tui
          steamcmd
          mixxx
#          mixxx-uaccess
          audacity
          gnome.nautilus
          spotify
          gnome.cheese
          syncthing

          # Sway
          swaylock
          swayidleln 
          wl-clipboard
          # tofi
          mako
          alacritty
          pavucontrol
          dbus-sway-environment
          configure-gtk
          xdg-utils
          glib
          dracula-theme
          gnome3.adwaita-icon-theme
          grim
          slurp
          wdisplays
        ];
      };

      programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "audishos";
        userEmail = "audisho.sada@gmail.com";
      };

      programs.zsh = {
        enable = true;
        enableVteIntegration = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "fnm"
          ];
          theme = "robbyrussell";
        };
        initExtra =
          ''
            eval "$(fnm env --use-on-cd)"
          '';
      };

      programs.tmux = {
        enable = true;
        keyMode = "vi";
        shortcut = "a";
        terminal = "screen256color";
        shell = "/etc/profiles/per-user/audisho/bin/zsh";
      };

      programs.neovim = {
        enable = true;
        vimAlias = true;
      };

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [ 
          jnoortheen.nix-ide
          dracula-theme.theme-dracula 
        ];
      };

      
      # programs.rofi.enable = true;
      programs.wofi.enable = true;

      programs.waybar = {
        enable = true;
      };

      wayland.windowManager.sway = {
        enable = true;

        config = rec {
          modifier = "Mod4";
          terminal = "alacritty";
          menu = "wofi --show run --allow-images";
          bars = [{
            command = "waybar";
          }];
          output."*" = { adaptive_sync = "on"; };
        };
       };
    # };
  # };
}
