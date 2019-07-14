{ config, pkgs, lib, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
  ];

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "mode=0755" ];
  };

  boot.loader.grub.enable = false;
  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
    enable = true;
    autorun = true;

    displayManager.lightdm = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = "miles"
    }

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };
 


  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "yes";
  };


  documentation.enable = mkForce true;
  documentation.nixos.enable = mkForce true;
  services.nixosManual.showManual = true;

  services.mingetty.autologinUser = "root";

  networking.wireless.enable = mkDefault false;

  security.sudo.enable = mkDefault false;

  environment.variables.GC_INITIAL_HEAP_SIZE = "1G";

  networking.firewall.logRefusedConnections = mkDefault false;

  environment.systemPackages =
    with pkgs;
    [
      git
      tmux
    ];

  users.users.miles = {
    isNormalUser = true;
    home = "/home/miles";
    description = "Miles Breslin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ./miles.authorized_keys ];
    hashedPassword = "*";
  };

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [ ./root.authorized_keys ];
    hashedPassword = "*";
  };
}
