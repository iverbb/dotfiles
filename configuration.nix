# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

with pkgs;
let
  # Emacs
  # (emacs.overrideAttrs (oldAttrs: {
  #     imagemagick = imagemagickBig;
  #   }))

  # Haskell
  haskellWithMyPackages = (haskellPackages.ghcWithPackages
    (p:
      [ haskellPackages.network
	haskellPackages.xmonad
	haskellPackages.xmonad-contrib
	haskellPackages.xmonad-extras
	haskellPackages.xmobar
        haskellPackages.libmpd
        haskellPackages.stack
        # haskellPackages.hindent # Yurp still brokered
        haskellPackages.hlint
        haskellPackages.Agda
	haskellPackages.utf8-string
      ]
    )
  );

  # Python
  pythonWithMyPackages = (python37.withPackages
    (python-packages:
      with python-packages;
      [
        scipy
        pandas
        numpy
        plotly
        python37Packages.opencv4
        python37Packages.python-language-server
        python37Packages.pydocstyle
        python37Packages.pyflakes
        python37Packages.importmagic
        python37Packages.epc
        python37Packages.dash
        python37Packages.mypy
        python37Packages.mypy-extensions
        python37Packages.pyls-mypy
        python37Packages.pyls-black
        python37Packages.django
      ]
     )
    );

  # R
  rWithMyPackages   = rWrapper.override{ packages = with rPackages; [ ggplot2 dplyr xts ]; };

  # Latex
  myLatex = (texlive.combine { inherit (texlive) scheme-tetex collection-latex collection-latexextra; });

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader = {
    grub.enable  = true;
    grub.version = 2;
    grub.device  = "/dev/sda"; # or "nodev" for efi only
  };
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "nixos"; # Define your hostname.
    useDHCP  = false;
    interfaces.enp0s3.useDHCP = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "no-latin1";
  #};
  console.useXkbConfig = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      }))
    ];

  environment.systemPackages = with pkgs; [

    # Editors
    # myEmacs
    emacsUnstable
    neovim

    # Web
    firefox-beta-bin
    wget

    # Latex
    # texlive.combined.scheme-tetex
    # tetex
    myLatex

    # Haskell
    haskellWithMyPackages

    # Python(needed for some emacs features)
    pythonWithMyPackages

    # Prolog
    swiProlog

    # TDT4155
    scala
    openjdk
    sbt

    # R
    # rWithMyPackages

    # Julia

    # Rust
    # clippy # Linter for rust
    # rustracer # code completion
    # rustfmt
    # rustup
    # rustc
    # cargo

    # # C-C++
    clang
    # ccls
    # clang-tools
    # rtags

    # # Misc
    # llvm_9
    zip
    unzip
    zathura
    imagemagickBig
    dmenu
    feh
    exa
    alacritty
    git
    x11
    xorg.libX11
    xorg.libXext
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    gcc
    xdo
    xdotool
    # home-manager
    picom
  ];

  # Set transparency
  services.picom = {
    enable          = true;
    opacityRules = [
    	"90:class_g = 'Emacs'"
	"100:class_g = 'firefox'"
	"90:class_g = 'Alacritty'"
	"90:class_g = 'xmobar'"
	"90:class_g = 'dmenu'"
	];
    };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable     = true;
    layout     = "no,cn";
    xkbOptions = "ctrl:swapcaps, eurosign:e, alt_space_toggle";
    # Enable touchpad support.
    libinput.enable = true;
    # Enable XMonad window manager.
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "none+xmonad";
    desktopManager = {
      xterm.enable = false;
      };
    # XMonad allow
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };
  };






  # Enable fish
  programs.fish.enable = true;

  # Add image support to emacs
  # programs.emacs = {
  #   enable  = true;
  #   package = pkgs.emacs.override { imagemagick = pkgs.imagemagickBig; };
  # };

  # Set alacritty as terminal
  environment.sessionVariables.TERMINAL = [ "alacritty" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wenwen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

