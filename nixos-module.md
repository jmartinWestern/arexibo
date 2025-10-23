# Arexibo NixOS Module

This module provides a NixOS service configuration for the Arexibo Digital Signage Player.

## Quick Start

To enable Arexibo on your NixOS system, add the following to your `configuration.nix`:

```nix
{
  # Import the module
  imports = [ ./path/to/arexibo/nixos-module.nix ];
  
  # Configure the service
  services.arexibo = {
    enable = true;
    host = "https://your-cms.example.com/";
    key = "your-display-key-from-cms";
  };
}
```

## Configuration Options

### Basic Configuration

- `services.arexibo.enable` - Enable the Arexibo service
- `services.arexibo.host` - URL of your Xibo CMS server (required)
- `services.arexibo.key` - Display key from your CMS (required). Can be a string or path to a file containing the key.
- `services.arexibo.displayId` - Custom display ID (optional, auto-generated if not set)
- `services.arexibo.displayName` - Initial name for the display (optional)
- `services.arexibo.proxy` - HTTP proxy URL if needed

### System Configuration

- `services.arexibo.dataDir` - Directory for configuration and media files (default: `/var/lib/arexibo`)
- `services.arexibo.user` - User account for the service (default: `arexibo`)
- `services.arexibo.group` - Group account for the service (default: `arexibo`)
- `services.arexibo.autoStart` - Auto-start on boot (default: `true`)

### X Server Configuration

For dedicated signage displays, you can run Arexibo with its own X server:

```nix
services.arexibo = {
  enable = true;
  host = "https://your-cms.example.com/";
  key = "your-display-key";
  
  xserver = {
    enable = true;        # Run with dedicated X server
    display = ":0";       # X11 display number
    vt = "vt2";          # Virtual terminal
    extraArgs = [        # Additional X server arguments
      "-s" "0"           # Disable screensaver
      "-v"               # Verbose
      "-dpms"            # Disable DPMS
    ];
  };
};
```

### Environment Variables

You can set additional environment variables:

```nix
services.arexibo = {
  enable = true;
  host = "https://your-cms.example.com/";
  key = "your-display-key";
  
  extraEnvironment = {
    NO_AT_BRIDGE = "1";
    QT_QPA_PLATFORM = "xcb";
    QT_SCALE_FACTOR = "1.0";
  };
};
```

## Example Configurations

### Basic Setup (Existing Desktop)

For running Arexibo on an existing desktop environment:

```nix
{
  services.arexibo = {
    enable = true;
    host = "https://signage.company.com/";
    key = "abc123def456ghi789";
    proxy = "http://corporate-proxy.company.com:8080";
  };
}
```

### Dedicated Kiosk/Signage Display

For a dedicated signage machine with its own X server:

```nix
{
  services.arexibo = {
    enable = true;
    host = "https://signage.company.com/";
    key = "abc123def456ghi789";
    displayId = "lobby-display-01";
    displayName = "Lobby Digital Signage";
    
    xserver = {
      enable = true;
      display = ":0";
      vt = "vt2";
      extraArgs = [ "-s" "0" "-v" "-dpms" ];
    };
    
    extraEnvironment = {
      NO_AT_BRIDGE = "1";
      QT_QPA_PLATFORM = "xcb";
    };
  };
  
  # Ensure X server is properly configured
  services.xserver.enable = true;
  
  # Disable unnecessary services for kiosk mode
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;
}
```

### High Security Setup

For environments requiring additional security:

```nix
{
  services.arexibo = {
    enable = true;
    host = "https://secure-signage.company.com/";
    key = "secure-display-key";
    dataDir = "/opt/arexibo-data";
    
    # Use dedicated user/group
    user = "signage";
    group = "signage";
  };
  
  # Additional security hardening
  systemd.services.arexibo.serviceConfig = {
    # Additional security restrictions
    PrivateNetwork = false;  # Needs network access
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictRealtime = true;
    LockPersonality = true;
  };
}
```

## Service Management

After configuring and rebuilding your system, you can manage the service with:

```bash
# Check status
sudo systemctl status arexibo

# Start/stop/restart
sudo systemctl start arexibo
sudo systemctl stop arexibo
sudo systemctl restart arexibo

# View logs
sudo journalctl -u arexibo -f

# Initial configuration logs
sudo journalctl -u arexibo --since today | grep -i config
```

## Troubleshooting

### Common Issues

1. **Service fails to start**: Check that host and key are correctly configured
2. **Network issues**: Verify proxy settings if behind corporate firewall
3. **Display issues**: Ensure X server is running and accessible
4. **Permission issues**: Check that the arexibo user has access to required resources

### Debug Mode

To enable more verbose logging, you can temporarily modify the service:

```bash
sudo systemctl edit arexibo
```

Add:
```ini
[Service]
Environment=RUST_LOG=debug
```

### Logs Location

- Service logs: `journalctl -u arexibo`
- Arexibo application logs: Check stdout in service logs
- Configuration directory: `/var/lib/arexibo` (or your custom `dataDir`)

## Dependencies

The module automatically handles the following dependencies:

- Qt 6 with WebEngine
- DBus development libraries
- ZeroMQ
- CMake and build tools
- FFmpeg for media playback

## Security Considerations

The service is configured with several security restrictions:

- Runs as unprivileged user
- Limited filesystem access
- No new privileges
- Private temporary directory
- Protected system directories

### Key Security

The `key` option accepts sensitive authentication credentials. For security:

**✅ Recommended: Use file paths for secrets**
```nix
services.arexibo.key = "/run/secrets/arexibo-key";
```

**❌ Avoid: Hardcoded keys**
```nix
services.arexibo.key = "super-secret-key";  # DON'T DO THIS
```

**Integration with secrets management:**
- **sops-nix**: `key = config.sops.secrets.arexibo-key.path;`
- **agenix**: `key = config.age.secrets.arexibo-key.path;`
- **Manual**: Store key in `/run/secrets/arexibo-key` with appropriate permissions

For production deployments, consider:

- Using HTTPS for CMS connection
- Implementing network restrictions
- Regular security updates
- Monitoring service logs
- Rotating keys periodically

## Updates

To update Arexibo:

1. Update the flake: `nix flake update` in the Arexibo directory
2. Rebuild your system: `sudo nixos-rebuild switch`
3. Restart the service: `sudo systemctl restart arexibo`
