{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./main-user.nix
    inputs.home-manager.nixosModules.default
  ];

  # main-user.enable = true;
  # main-user.userName = "chefkoch";

  ### Kernel (new CPU + GPU need this)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ### Bootloader
  boot.loader = {
    systemd-boot.enable = false;

    limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 5;

      extraEntries = ''
        /Windows 11
          COMMENT=Windows Boot Manager
          protocol: efi_chainload
          image_path: guid(6BF5738B-4A34-4766-850E-179DF4E6B386):/EFI/Microsoft/Boot/bootmgfw.efi
      '';

      style.wallpapers = [ "/boot/splash.jpg" ];
    };
  };
  
  ### Networking
  networking.hostName = "bakery";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ### Time & locale
  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  ### Graphics stack 
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  ### X11 base 
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  ### KDE Plasma 6 on Wayland
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb.layout = "eu";

  ### NVIDIA configuration
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    open = true; 

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  ### Required for NVIDIA Wayland
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  ### Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ### Printing
  services.printing.enable = true;

  ### User
  users.users.chefkoch = {
    isNormalUser = true;
    description = "chefkoch";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "chefkoch" = import ./home.nix;
    };
  };

  ### Allow unfree packages (NVIDIA)
  nixpkgs.config.allowUnfree = true;

  ### zram
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  ### Programs and packages

  environment.systemPackages = with pkgs; [
    # apps
    brave
    kitty
    discord
    stow

    # code editors
    neovim
    vscodium

    # for terminal
    fzf
    fastfetch

  ];

  programs.steam = {
    enable = true;
  };
  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.sway.enable = true;
  programs.localsend.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  ### NixOS release
  system.stateVersion = "25.11";
}
