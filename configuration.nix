{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #(modulesPath + "/installer/scan/not-detected.nix")
    #(modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelModules = [ "amdgpu" "vfio-pci" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "intel_iommu=on" "vfio-pci.ids=10de:24c9,10de:228b" "hugepagesz=1G" "hugepages=24" ];

  networking.networkmanager.enable = true;
  networking.hostName = "vykas";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  time.timeZone = "America/Costa_Rica";

  services.xserver.enable = true;
  #services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "plasmax11";
  services.desktopManager.plasma6.enable = true;

  services.openssh.enable = true;

  virtualisation.waydroid.enable = true;

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  programs.virt-manager.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  users.users.kenpb = {
    isNormalUser = true;
    description = "kenpb";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    weston
    distrobox
    firefox
    vscode
    looking-glass-client
  ];

  environment.variables = { EDITOR = "vim"; };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGAXHREBRAHwsBxrG5rFg3Q0jbnJTtdPRS2O7rAhskDATIt2p08k72/psp1v2eRDJ1X9PYOsyFlAzzviDfyL8j6E1VG1ihV3cEJyXh/t/md6PdssEIoqsu/xQwhARo+SUL0dUfW/q6AO6Fr+nWNXEIpaNKQZD8D1qv+bYN7JXdZxfOJUsdwvUn+vhe68D7NpAoQwEsNTZWsqC+9DsSoWZby+iwBy+Lm94x8FjOMzHKxYhSkumQJT2lmt7btPKkt4nMMZ3cZOiGYbS3v6ITRkKKtMOB3zqQAo1W0As5AwLZ0JAA+YOGHUSg691J5nDG/x9p2mz0W8Zc/z5uc1CEb/Msr25aZsSeYxkC9ZFk/XawF38QOxD+iSsfWcjryMQunYVr1oa/yoJsyuHOyRncO836S2U9ydcHU+mDFJAWcJ8LcxzlPFO0Mq1IbBp5wikJFQT4kl1JHJqj5223uteuYNQw1cRZpFs19q7a7IWoyQeq9990PrINR78jN+kSksxUwZpWiBX8RihZ0U1m10qPd602zcsjA6KQN1WKtebHhJxb9sWGDkbqW6AOd1qzPdU0s4Mx5fP1dOhfjMUlG5/jNeiqI9Yb81wtgRrDsb411QBdFQ1s4VOtSxoPnQ3nRX86+jBNrRVZj2RYxU/0V12ryWr2vZ0juhjcMD3gYKQRostObw== kenpb@vykas"
  ];

  system.stateVersion = "24.05";
}
