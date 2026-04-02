# ReArch OS Development Directory Structure

```
rearch-os-dev/
├── rearch-build.sh           # Master build script
├── rearch-repo/              # Local package repository
│   ├── x86_64/               # Architecture-specific packages
│   │   ├── *.pkg.tar.zst     # Built packages
│   │   ├── rearch-repo.db    # Repository database
│   │   └── rearch-repo.files # Repository files database
│   └── pacman.conf           # Repository pacman configuration
│
├── packages/                 # Package sources
│   ├── core/                 # [CORE] - System Identity
│   │   ├── rearch-keyring/   # Security keys for repository
│   │   │   ├── PKGBUILD
│   │   │   └── rearch-keyring.install
│   │   ├── rearch-hooks/     # Custom mkinitcpio hooks
│   │   │   ├── PKGBUILD
│   │   │   └── rearch-hooks.install
│   │   └── rearch-base/      # Meta-package for base system
│   │       ├── PKGBUILD
│   │       └── rearch-base.install
│   │
│   ├── shell/                # [SHELL] - Functional Arsenal (CLI)
│   │   ├── PKGBUILD          # Single PKGBUILD for all shell tools
│   │   └── rearch-*          # 24 functional CLI tools:
│   │       ├── rearch-fetch      # System information fetcher
│   │       ├── rearch-clean      # System cleaner
│   │       ├── rearch-mirrors    # Mirror selector
│   │       ├── rearch-sync       # Universal package sync
│   │       ├── rearch-check      # System health check
│   │       ├── rearch-kernel-toggle # Kernel switcher
│   │       ├── rearch-wifi       # WiFi manager
│   │       ├── rearch-btrfs      # Btrfs manager
│   │       ├── rearch-services   # Service manager
│   │       ├── rearch-ports      # Port manager
│   │       ├── rearch-backup     # Backup manager
│   │       ├── rearch-gpu        # GPU manager
│   │       ├── rearch-boot       # Boot manager
│   │       ├── rearch-logs       # Log viewer
│   │       ├── rearch-pkg        # Package manager helper
│   │       ├── rearch-tweaks     # System tweaks
│   │       ├── rearch-theme      # Theme manager
│   │       ├── rearch-update     # Update notifier
│   │       ├── rearch-sysinfo    # System information
│   │       ├── rearch-desktop    # Desktop manager
│   │       ├── rearch-zram       # ZRAM manager
│   │       └── rearch-aur        # AUR manager
│   │
│   ├── gui/                  # [GUI] - Visual & Frontend
│   │   └── (reserved for GUI applications)
│   │
│   └── utils/                # [UTILS] - Utility packages
│       └── (reserved for utility packages)
│
├── iso-profile/              # ISO build profile
│   ├── airootfs/             # AI root filesystem
│   │   └── etc/
│   │       ├── pacman.conf
│   │       └── pacman.d/
│   ├── efiboot/              # UEFI boot files
│   ├── syslinux/             # BIOS boot files
│   ├── packages.x86_64       # Package list
│   ├── pacman.conf           # Build pacman configuration
│   └── profiledef.sh         # ISO profile definition
│
├── scripts/                  # Helper scripts
│   └── (build helper scripts)
│
└── docs/                     # Documentation
    ├── FOLDER_STRUCTURE.md   # This file
    ├── TOOLS.md              # Tool documentation
    └── REPOSITORY.md         # Repository workflow

```

## Package Tiers

### [CORE] - System Identity
These packages define the ReArch OS identity and provide base system configuration:

- **rearch-keyring**: Security keys for repository signing
- **rearch-hooks**: Custom mkinitcpio hooks for branded boot
- **rearch-base**: Meta-package that pulls in all essential ReArch configs

### [SHELL] - The Functional Arsenal
24 unique CLI tools that solve real Arch Linux problems:

| Tool | Description |
|------|-------------|
| rearch-fetch | High-speed system information fetcher |
| rearch-clean | Intelligent system cleaner |
| rearch-mirrors | Smart mirror selector and benchmarker |
| rearch-sync | Universal package sync (pacman/AUR/Flatpak) |
| rearch-check | Comprehensive system health diagnostic |
| rearch-kernel-toggle | Easy kernel switcher |
| rearch-wifi | Simplified WiFi manager |
| rearch-btrfs | Btrfs snapshot and subvolume manager |
| rearch-services | Service manager |
| rearch-ports | Network port manager |
| rearch-backup | Backup and restore tool |
| rearch-gpu | GPU manager |
| rearch-boot | Boot manager |
| rearch-logs | Log viewer |
| rearch-pkg | Package manager helper |
| rearch-tweaks | System tweaks |
| rearch-theme | Theme manager |
| rearch-update | Update notifier |
| rearch-sysinfo | System information |
| rearch-desktop | Desktop environment manager |
| rearch-zram | ZRAM manager |
| rearch-aur | AUR helper manager |

### [GUI] - Visual & Frontend
GUI applications (future development):
- rearch-welcome: Welcome application
- rearch-theme-engine: Theme engine

### [UTILS] - Utilities
Additional utility packages (future development).

## Repository Workflow

1. **Build Packages**: `makepkg -sf` in each package directory
2. **Move Packages**: Copy `.pkg.tar.zst` files to `rearch-repo/x86_64/`
3. **Update Database**: Run `repo-add rearch-repo.db.tar.gz *.pkg.tar.zst`
4. **Build ISO**: Run `mkarchiso` with the ISO profile

## Build Commands

```bash
# Build everything
./rearch-build.sh all

# Build packages only
./rearch-build.sh packages

# Update repository only
./rearch-build.sh repo

# Build ISO only
./rearch-build.sh iso

# Clean build artifacts
./rearch-build.sh clean
```

## Pacman Configuration

The repository is configured in `/etc/pacman.conf`:

```ini
[rearch]
Server = https://arch.revy.my.id/repo/$arch
SigLevel = Optional TrustAll
```

For local development:

```ini
[rearch]
Server = file:///path/to/rearch-os-dev/rearch-repo/$arch
SigLevel = Optional TrustAll
```
