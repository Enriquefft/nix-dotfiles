# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "hybridz_nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Lima";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
sound.enable = true;
hardware.pulseaudio.enable = true;
hardware.enableAllFirmware = true;
hardware.opengl = {
	enable = true;
	driSupport = true;
	driSupport32Bit = true;
};

services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
	modesetting.enable = true;

	powerManagement = {

	enable = true;

	finegrained = true;
	};

	prime = {

		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";

		offload = {

		enable = true;
		enableOffloadCmd = true;
		};

	};

	open = false;

	nvidiaSettings = true;

	package = config.boot.kernelPackages.nvidiaPackages.stable;

};


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.hybridz = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" "networkmanager" "audio"]; # Enable ‘sudo’ for the user.
   };

   home-manager.users.hybridz = {pkgs, ...}: {
	programs.kitty = {

		enable = true;
		theme = "Solarized Dark";
		font.name = "FiraCode Nerd Font";

	};

	programs.git = {

		enable = true;
		userName = "Enriquefft";
		userEmail = "enriquefft2001@gmail.com";

	};


	# DONT CHANGE!!
  home.stateVersion = "23.11";
	

   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget


  fonts.packages = with pkgs; [

	(nerdfonts.override { fonts = [ "FiraCode" ]; })

  ];

	environment.localBinInPath = true;
   environment.systemPackages = with pkgs; [
     wget
       tree
       fastfetch
       gh
	gnumake
	pamixer
	pavucontrol
   ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

nixpkgs.config.allowUnfree = true;
nixpkgs.config.pulseaudio = true;

  nixpkgs.overlays = let
    nix-xilinx = import (builtins.fetchTarball "https://gitlab.com/doronbehar/nix-xilinx/-/archive/master/nix-xilinx-master.tar.gz");
  in [
    nix-xilinx.overlay
    (
      final: prev: {
        # Your own overlays...
      }
    )
  ];


nix.settings.experimental-features = [ "nix-command" "flakes" ];
nix.settings.trusted-users = [ "root" "hybridz" ];
programs.neovim = {
	enable = true;
	defaultEditor = true;
	viAlias = true;
	vimAlias = true;
};
programs.hyprland.enable = true;
programs.firefox.enable = true;
programs.waybar.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  security.doas.enable = true;
  security.sudo.enable = true;
  security.doas.extraRules = [
  
  {
  users = ["hybridz"];
  keepEnv = true;
  persist = true;

  }

  ];
  

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

