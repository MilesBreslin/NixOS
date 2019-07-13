{ config, pkgs, lib, ... }:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
  ];

  fileSystems."/" =
  { fsType = "tmpfs";
    options = [ "mode=0755" ];
  };

  boot.loader.grub.enable = false;


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
