# Arexibo

<p align="center">
  <img src="https://github.com/birkenfeld/arexibo/blob/master/assets/logo.png?raw=true" alt="Logo"/>
</p>

Arexibo is an unofficial alternate Digital Signage Player for [Xibo](https://xibo.org.uk),
implemented mostly in Rust but making use of Qt GUI components, for Linux platforms.

It is currently still incomplete.  Don't expect more complex features to work
unless tested.


## Installation

### Building from Source

Currently, no binary builds are provided.

To build from source, you need:

* The [Rust toolchain](https://www.rust-lang.org/), version >= 1.75.  Refer to
  https://rustup.rs/ for the easiest way to install, if the Linux distribution
  provided package is too old.

* CMake and a C++ compiler.

* Qt 6 with the QtWebEngine component and its development headers.

* Development headers for `dbus` (>= 1.6), `zeromq` (>= 4.1)
  as well as `pkg-config`.

To build, run:

```
$ cargo build --release
```

The binary is placed in `target/release/arexibo` and can be run from there.

To install, run:

```
$ cargo install --path . --root /usr
```

The will install the binary to `/usr/bin/arexibo`.  It requires no other files
at runtime, except for the system libraries it is linked against.

Builds have been tested with the available dependency library versions on Fedora
41, RHEL 9 with EPEL and Ubuntu 24.04.  Note that in order to play some media
like mp4 videos, you will require a `ffmpeg` package that includes some codecs
that RHEL/Fedora don't include in their packages, e.g. from rpmfusion.org.

For RHEL derived distributions, install `cmake gcc-c++ cargo dbus-devel
zeromq-devel qt6-qtwebengine-devel`.  For Debian derived, install `cmake g++
cargo libdbus-1-dev libzmq3-dev qt6-webengine-dev`.

### Using Nix/NixOS

### Using Nix/NixOS

A Nix flake is provided for easy building and installation:

```bash
# Build the package
nix build

# Run directly
nix run

# Install to profile
nix profile install
```

#### NixOS Module

For NixOS users, a complete system module is available that provides declarative configuration and systemd integration for Arexibo as a digital signage service.

##### Quick Start

Add the following to your `configuration.nix`:

```nix
{
  inputs.arexibo.url = "github:jmartinWestern/arexibo";  # or local path
  
  outputs = { nixpkgs, arexibo, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        arexibo.nixosModules.default
        {
          services.arexibo = {
            enable = true;
            host = "https://your-cms.example.com/";
            key = "your-display-key";
          };
        }
      ];
    };
  };
}
```

Then rebuild: `sudo nixos-rebuild switch`

##### Configuration Options

**Basic Configuration:**
- `services.arexibo.enable` - Enable the Arexibo service
- `services.arexibo.host` - URL of your Xibo CMS server (required)
- `services.arexibo.key` - Display key from your CMS (required)
- `services.arexibo.displayId` - Custom display ID (optional, auto-generated if not set)
- `services.arexibo.displayName` - Initial name for the display (optional)
- `services.arexibo.proxy` - HTTP proxy URL if needed

**System Configuration:**
- `services.arexibo.dataDir` - Directory for config and media files (default: `/var/lib/arexibo`)
- `services.arexibo.user` - Service user account (default: `arexibo`)
- `services.arexibo.group` - Service group account (default: `arexibo`)
- `services.arexibo.autoStart` - Auto-start on boot (default: `true`)

**X Server Configuration (for dedicated displays):**
```nix
services.arexibo.xserver = {
  enable = true;        # Run with dedicated X server
  display = ":0";       # X11 display number
  vt = "vt2";          # Virtual terminal
  extraArgs = [        # Additional X server arguments
    "-s" "0"           # Disable screensaver
    "-v"               # Verbose
    "-dpms"            # Disable DPMS
  ];
};
```

**Environment Variables:**
```nix
services.arexibo.extraEnvironment = {
  NO_AT_BRIDGE = "1";
  QT_QPA_PLATFORM = "xcb";
};
```

##### Example Configurations

**Basic Setup (Existing Desktop):**
```nix
services.arexibo = {
  enable = true;
  host = "https://signage.company.com/";
  key = "abc123def456ghi789";
  proxy = "http://corporate-proxy.company.com:8080";
};
```

**Dedicated Kiosk/Signage Display:**
```nix
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
services.xserver.displayManager.gdm.enable = false;  # Disable desktop manager for kiosk
```

##### Service Management

After configuration:

```bash
# Check status
sudo systemctl status arexibo

# View logs
sudo journalctl -u arexibo -f

# Restart service
sudo systemctl restart arexibo
```

##### Updates

To update Arexibo:
1. Update the flake: `nix flake update` in the Arexibo directory
2. Rebuild your system: `sudo nixos-rebuild switch`
3. Restart the service: `sudo systemctl restart arexibo`

For detailed documentation, see `nixos-module.md`.


## Usage

Create a new directory where Arexibo can store configuration and media files.
Then, at first start, use the following command line to configure the player:

```
arexibo --host <https://my.cms/> --key <key> <dir>
```

Further configuration options are `--display-id` (which is normally
auto-generated from machine characteristics) and `--proxy` (if needed).

Arexibo will cache the configuration in the directory, so that in the future you
only need to start with

```
arexibo <dir>
```

Log messages are printed to stdout.  The GUI window will only show up once the
display is authorized.


## Standalone setup with X server

The following example systemd service file shows how to to start an X server
with Arexibo and no DPMS/screensaver:

```
[Unit]
Description=Start X with Arexibo player
After=network-online.target
Requires=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/xinit /usr/bin/arexibo /home/xibo/env -- :0 vt2 -s 0 -v -dpms
User=xibo
Restart=always
RestartSec=60
Environment=NO_AT_BRIDGE=1

[Install]
WantedBy=multi-user.target
```
