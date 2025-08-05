{
  description = "Arexibo - An unofficial alternate Digital Signage Player for Xibo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Use the specific Rust version from rust-toolchain file
        rustVersion = "1.75.0";
        rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

        # Qt and other native dependencies
        buildInputs = with pkgs; [
          # Qt dependencies
          qt6.full
          qt6.qtwebengine
          qt6.qtwayland  # Add Wayland support
          
          # System libraries
          dbus
          zeromq
          pkg-config
          
          # Build tools
          cmake
          gcc
          
          # Additional runtime dependencies
          ffmpeg
        ];

        nativeBuildInputs = with pkgs; [
          rust
          pkg-config
          cmake
          qt6.wrapQtAppsHook
        ];

      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "arexibo";
          version = "0.3.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = nativeBuildInputs;
          buildInputs = buildInputs;

          # Set environment variables for Qt development
          QT_QPA_PLATFORM_PLUGIN_PATH = "${pkgs.qt6.qtbase}/lib/qt-6/plugins";
          QML2_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";
          
          # Set PKG_CONFIG_PATH for dependencies
          PKG_CONFIG_PATH = pkgs.lib.concatStringsSep ":" [
            "${pkgs.dbus.dev}/lib/pkgconfig"
            "${pkgs.zeromq}/lib/pkgconfig"
            "${pkgs.qt6.qtbase.dev}/lib/pkgconfig"
            "${pkgs.qt6.qtwebengine.dev}/lib/pkgconfig"
          ];

          # Set environment variables for Qt
          qtWrapperArgs = [
            "--prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}"
          ];

          postInstall = ''
            wrapQtApp $out/bin/arexibo
          '';

          meta = with pkgs.lib; {
            description = "An unofficial alternate Digital Signage Player for Xibo";
            homepage = "https://github.com/birkenfeld/arexibo";
            license = licenses.agpl3Plus;
            maintainers = [ ];
            platforms = platforms.linux;
            mainProgram = "arexibo";
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          buildInputs = nativeBuildInputs ++ buildInputs ++ (with pkgs; [
            # Additional development tools
            rust-analyzer
            cargo-watch
            cargo-edit
            clippy
            rustfmt
            
            # Debugging tools
            gdb
            valgrind
          ]);

          shellHook = ''
            echo "Arexibo development environment"
            echo "Rust version: ${rustVersion}"
            echo ""
            echo "Available commands:"
            echo "  cargo build --release  # Build the project"
            echo "  cargo run              # Run the project"
            echo "  cargo test             # Run tests"
            echo ""
            echo "Qt and other dependencies are available in the environment."
            
            # Set up environment for Qt development
            export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins"
            export QML2_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
          '';
        };

        # Apps for easy running
        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "arexibo";
        };
      }) // {
        # NixOS module (not system-specific)
        nixosModules.default = import ./nixos-module.nix;
        nixosModules.arexibo = import ./nixos-module.nix;
      });
}