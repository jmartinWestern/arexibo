# Example NixOS Configuration using Arexibo Flake

This example shows how to use the Arexibo flake in a NixOS configuration.

## Method 1: Using Flake Inputs (Recommended)

Create or modify your `/etc/nixos/flake.nix`:

```nix
{
  description = "My NixOS configuration with Arexibo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Add Arexibo flake as input
    arexibo = {
      url = "git+file:///path/to/arexibo";  # or github:birkenfeld/arexibo when published
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, arexibo }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Your existing configuration
        ./configuration.nix
        
        # Import Arexibo module
        arexibo.nixosModules.default
        
        # Add Arexibo package to pkgs
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              arexibo = arexibo.packages.${pkgs.system}.default;
            })
          ];
        })
      ];
    };
  };
}
```

Then in your `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # Your existing configuration...
  
  # Configure Arexibo
  services.arexibo = {
    enable = true;
    host = "https://your-cms.example.com/";
    key = "your-display-key-here";
    
    # Optional: Configure for dedicated signage display
    xserver = {
      enable = true;
      display = ":0";
      vt = "vt2";
    };
  };
  
  # Rest of your configuration...
}
```

## Method 2: Direct Import (Simple)

If you prefer not to use flakes system-wide, you can import directly:

In your `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

let
  # Import the Arexibo flake
  arexibo-flake = builtins.getFlake "git+file:///path/to/arexibo";
  arexibo-pkg = arexibo-flake.packages.${pkgs.system}.default;
in
{
  # Import the module
  imports = [
    arexibo-flake.nixosModules.default
  ];
  
  # Add package to environment
  nixpkgs.overlays = [
    (final: prev: {
      arexibo = arexibo-pkg;
    })
  ];
  
  # Configure the service
  services.arexibo = {
    enable = true;
    host = "https://your-cms.example.com/";
    key = "your-display-key-here";
  };
}
```

## Method 3: Local Development

For local development and testing:

```nix
{ config, pkgs, ... }:

{
  imports = [
    /path/to/arexibo/nixos-module.nix
  ];
  
  # Use a local build
  nixpkgs.overlays = [
    (final: prev: {
      arexibo = prev.callPackage /path/to/arexibo/default.nix {};
    })
  ];
  
  services.arexibo = {
    enable = true;
    host = "https://test-cms.local/";
    key = "test-key";
    autoStart = false;  # Don't start automatically during development
  };
}
```

## Testing the Configuration

1. **Validate the configuration:**
   ```bash
   sudo nixos-rebuild dry-build
   ```

2. **Apply the configuration:**
   ```bash
   sudo nixos-rebuild switch
   ```

3. **Check the service status:**
   ```bash
   sudo systemctl status arexibo
   ```

4. **View logs:**
   ```bash
   sudo journalctl -u arexibo -f
   ```

## Kiosk Mode Example

For a dedicated signage kiosk:

```nix
{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix
    # Arexibo module
    arexibo.nixosModules.default
  ];

  # System configuration for kiosk
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "signage-kiosk";
  networking.networkmanager.enable = true;
  
  # Minimal system for kiosk
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    # Don't start a desktop environment
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
  };
  
  # Arexibo configuration
  services.arexibo = {
    enable = true;
    host = "https://signage.company.com/";
    key = "kiosk-display-key";
    displayId = "lobby-kiosk-01";
    
    # Run with dedicated X server
    xserver = {
      enable = true;
      display = ":0";
      vt = "vt7";
      extraArgs = [ "-s" "0" "-v" "-dpms" ];
    };
    
    extraEnvironment = {
      NO_AT_BRIDGE = "1";
      QT_QPA_PLATFORM = "xcb";
    };
  };
  
  # Security and hardening
  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";  # Disable root login
  
  # Firewall
  networking.firewall.enable = true;
  
  # Auto-login for kiosk user (optional)
  services.getty.autologinUser = "arexibo";
  
  # Automatic updates
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "04:00";
  };
  
  system.stateVersion = "24.05";
}
```

## Wayland Support

Arexibo supports Wayland through Qt 6's Wayland platform plugin. For Wayland systems:

```nix
services.arexibo = {
  enable = true;
  host = "https://your-cms.example.com/";
  key = "your-display-key";
  
  # Configure for Wayland
  extraEnvironment = {
    NO_AT_BRIDGE = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # For fullscreen kiosk mode
  };
  
  # Don't use X server mode on Wayland systems
  xserver.enable = false;
};

# Ensure Wayland support is available
nixpkgs.overlays = [
  (final: prev: {
    arexibo = prev.arexibo.override {
      qtwayland = final.qt6.qtwayland;
    };
  })
];
```

Note: The dedicated X server mode (`xserver.enable = true`) is only for X11 systems and won't work on pure Wayland compositors.

## Environment Variables Reference

Common environment variables you might want to set:

```nix
services.arexibo.extraEnvironment = {
  # Disable accessibility bridge (reduces warnings)
  NO_AT_BRIDGE = "1";
  
  # Qt platform plugin
  QT_QPA_PLATFORM = "xcb";  # or "wayland" for Wayland systems
  
  # Display scaling
  QT_SCALE_FACTOR = "1.0";
  QT_AUTO_SCREEN_SCALE_FACTOR = "0";
  
  # Debugging
  QT_LOGGING_RULES = "*.debug=false";
  RUST_LOG = "info";  # or "debug" for verbose logging
  
  # Hardware acceleration
  LIBVA_DRIVER_NAME = "i965";  # Intel
  VDPAU_DRIVER = "va_gl";      # NVIDIA
};
```
