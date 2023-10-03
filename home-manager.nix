{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  mixxx-uaccess = pkgs.writeTextFile {
    name = "mixxx-usb-uaccess.rules";
    destination = "/etc/udev/rules.d";
    text = ''
      # This udev rule allows Mixxx to access HID and USB Bulk controllers when running as a normal user

      # Sources:
      # http://www.linux-usb.org/usb.ids
      # https://www.the-sz.com/products/usbid/
      # https://devicehunt.com/all-usb-vendors

      # Note that the udev rule must match on the USB device level; matching the USB interface
      # descriptor with bInterfaceClass does not work.

      # New IDs must be also added to res/linux/mixxx.metainfo.xml

      # Install and execute before 70-uaccess.rules, e.g. .../udev/rules.d/69-mixxx-usb-uaccess.rules

      # Allen + Heath Ltd.
      KERNEL=="hidraw*", ATTRS{idVendor}=="22f0", TAG+="uaccess"
      # Allen + Heath Xone 23C hardware mixer with USB audio interface
      # This is required so all 4 input and all 4 output channels of the audio interface are available.
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="22f0", ATTR{idProduct}=="0008", ATTR{bConfigurationValue}="2"
      # Arturia
      KERNEL=="hidraw*", ATTRS{idVendor}=="1c75", TAG+="uaccess"
      # BEHRINGER International GmbH
      KERNEL=="hidraw*", ATTRS{idVendor}=="1397", TAG+="uaccess"
      # D&M Holdings, Inc. (Denon/Marantz)
      KERNEL=="hidraw*", ATTRS{idVendor}=="154e", TAG+="uaccess"
      # EKS (Otus)
      KERNEL=="hidraw*", ATTRS{idVendor}=="1157", TAG+="uaccess"
      # Gemini
      KERNEL=="hidraw*", ATTRS{idVendor}=="23c7", TAG+="uaccess"
      # Guillemot Corp. (Hercules)
      KERNEL=="hidraw*", ATTRS{idVendor}=="06f8", TAG+="uaccess"
      # Some older Hercules controllers are accessed through USB Bulk endpoints through libusb
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="06f8", TAG+="uaccess"
      # inMusic (Numark, Denon)
      KERNEL=="hidraw*", ATTRS{idVendor}=="15e4", TAG+="uaccess"
      # KORG, Inc.
      KERNEL=="hidraw*", ATTRS{idVendor}=="0944", TAG+="uaccess"
      # Native Instruments
      KERNEL=="hidraw*", ATTRS{idVendor}=="17cc", TAG+="uaccess"
      # First generation Native Instruments controllers can be accessed through USB Bulk endpoints through libusb
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="17cc", TAG+="uaccess"
      # Nintendo Co., Ltd
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", TAG+="uaccess"
      # Pioneer Corp.
      KERNEL=="hidraw*", ATTRS{idVendor}=="08e4", TAG+="uaccess"
      # AlphaTheta Corp.
      KERNEL=="hidraw*", ATTRS{idVendor}=="2b73", TAG+="uaccess"
      # Rane
      KERNEL=="hidraw*", ATTRS{idVendor}=="13e5", TAG+="uaccess"
      # Reloop
      KERNEL=="hidraw*", ATTRS{idVendor}=="200c", TAG+="uaccess"
      # Roland Corp.
      KERNEL=="hidraw*", ATTRS{idVendor}=="0582", TAG+="uaccess"
      # Sony Corp.
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", TAG+="uaccess"

      # Missing:
      # - American Musical Supply (AMS/Mixars)

      # Only some distribuions require the below
      KERNEL=="hiddev*", NAME="usb/%k", GROUP="uaccess"
    '';
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
    ./sway.nix
    # ./hyprland.nix
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.audisho = { pkgs, ... }: {
      programs.home-manager.enable = true;

      home = {
        stateVersion = "23.05";
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
          mixxx-uaccess
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
    };
  };
}
