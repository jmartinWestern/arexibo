# Quickstart: Arexibo NixOS Module

## Prerequisites

- NixOS system
- Access to a Xibo CMS server
- Display key from the CMS

## Installation

1. Add arexibo to your flake inputs:

```nix
{
  inputs.arexibo.url = "github:birkenfeld/arexibo";  # or local path
  # ...
}
```

2. Import the module in your NixOS configuration:

```nix
{
  inputs,
  ...
}: {
  nixosConfigurations.myhost = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.arexibo.nixosModules.default
      # your other modules
    ];
  };
}
```

## Configuration

Enable and configure the service:

```nix
{
  services.arexibo = {
    enable = true;
    host = "https://your-cms.example.com/";
    key = "your-display-key";
    # Optional:
    # displayId = "unique-id";
    # proxy = "http://proxy.example.com:8080";
    # dataDir = "/var/lib/arexibo";
  };
}
```

## Usage

1. Rebuild and switch your NixOS configuration:

```bash
sudo nixos-rebuild switch
```

2. The service will start automatically and attempt to connect to the CMS.

3. Monitor logs:

```bash
journalctl -u arexibo.service -f
```

4. The display will show content once authorized by the CMS.

## Troubleshooting

- Check service status: `systemctl status arexibo`
- View logs: `journalctl -u arexibo`
- Ensure network connectivity to the CMS host
- Verify the display key is correct