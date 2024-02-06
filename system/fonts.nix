{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      liberation_ttf
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override {
        fonts = [ "FiraCode", "FantasqueSansMono" ];
      })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };
}
