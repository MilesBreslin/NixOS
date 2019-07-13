{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

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
  };

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./root.authorized_keys ];
}
