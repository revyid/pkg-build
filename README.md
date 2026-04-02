# ReArch OS Development

**ReArch OS** is an independent Arch Linux-based distribution with a suite of exclusive proprietary CLI/GUI tools developed specifically for this distro.

![ReArch OS](https://arch.revy.my.id/logo.png)

## 🎯 Vision

ReArch OS is not just another Arch ISO. It's a complete ecosystem with:
- **Custom Repository** (`rearch-repo`) with proprietary packages
- **24+ Unique Tools** (`rearch-*`) that solve real Arch problems
- **Modular Package Structure** organized in tiers (CORE, SHELL, GUI)
- **Automated Build System** from compilation to ISO generation

## 📁 Project Structure

```
rearch-os-dev/
├── rearch-build.sh           # Master build script
├── rearch-repo/              # Local package repository
├── packages/                 # Package sources
│   ├── core/                 # [CORE] - System Identity
│   │   ├── rearch-keyring/   # Security keys
│   │   ├── rearch-hooks/     # Custom mkinitcpio hooks
│   │   └── rearch-base/      # Base system meta-package
│   ├── shell/                # [SHELL] - 24 CLI tools
│   ├── gui/                  # [GUI] - GUI applications
│   └── utils/                # [UTILS] - Utilities
├── iso-profile/              # ISO build profile
├── scripts/                  # Helper scripts
└── docs/                     # Documentation
```

## 🛠️ The ReArch Toolset (24 Tools)

### System Information & Monitoring
| Tool | Description |
|------|-------------|
| `rearch-fetch` | High-speed system information fetcher |
| `rearch-sysinfo` | Detailed system information |
| `rearch-check` | System health diagnostic |
| `rearch-update` | Update notifier |

### Package Management
| Tool | Description |
|------|-------------|
| `rearch-sync` | Universal package sync (pacman/AUR/Flatpak) |
| `rearch-pkg` | Enhanced package manager |
| `rearch-aur` | AUR helper manager |
| `rearch-mirrors` | Smart mirror selector |
| `rearch-clean` | Intelligent system cleaner |

### System Management
| Tool | Description |
|------|-------------|
| `rearch-kernel-toggle` | Easy kernel switcher |
| `rearch-services` | Service manager |
| `rearch-boot` | Boot manager |
| `rearch-logs` | Log viewer |
| `rearch-tweaks` | System optimizations |
| `rearch-zram` | ZRAM manager |

### Hardware Management
| Tool | Description |
|------|-------------|
| `rearch-gpu` | GPU manager |
| `rearch-wifi` | WiFi manager |
| `rearch-btrfs` | Btrfs manager |
| `rearch-ports` | Network port manager |

### Desktop & Theming
| Tool | Description |
|------|-------------|
| `rearch-desktop` | Desktop environment manager |
| `rearch-theme` | Theme manager |
| `rearch-backup` | Backup manager |

## 🚀 Quick Start

### Build Everything

```bash
./rearch-build.sh all
```

This will:
1. Build all packages (core, shell, gui, utils)
2. Update the repository database
3. Create the ISO profile
4. Build the final ISO

### Build Commands

```bash
# Build everything (packages + ISO)
./rearch-build.sh all

# Build packages only
./rearch-build.sh packages

# Update repository database
./rearch-build.sh repo

# Build ISO only
./rearch-build.sh iso

# Sign packages with GPG
GPG_KEY=your@key.email ./rearch-build.sh sign

# Clean build artifacts
./rearch-build.sh clean
```

## 📦 Package Tiers

### [CORE] - System Identity
- `rearch-keyring` - Security keys for repository
- `rearch-hooks` - Custom mkinitcpio hooks
- `rearch-base` - Meta-package with system configs

### [SHELL] - Functional Arsenal
24 CLI tools written in Bash, all packaged in `rearch-shell-tools`.

### [GUI] - Visual & Frontend
GUI applications (future development).

## 🔧 Custom Repository Workflow

### 1. Build Packages

```bash
cd packages/core/rearch-base
makepkg -sf
```

### 2. Move to Repository

```bash
mv *.pkg.tar.zst ../../rearch-repo/x86_64/
```

### 3. Update Database

```bash
cd ../../rearch-repo/x86_64
repo-add rearch-repo.db.tar.gz *.pkg.tar.zst
```

### 4. Configure pacman

```ini
[rearch]
Server = file:///path/to/rearch-os-dev/rearch-repo/$arch
SigLevel = Optional TrustAll
```

## 📝 Sample PKGBUILD

```bash
# Maintainer: REArch Team <admin@revy.my.id>
pkgname=rearch-shell-tools
pkgver=1.0.0
pkgrel=1
pkgdesc="Core shell tools for ReArch OS"
arch=('any')
url="https://arch.revy.my.id"
license=('MIT')
depends=('bash' 'pacman' 'systemd')

package() {
    install -dm755 "$pkgdir/usr/bin"
    for tool in rearch-*; do
        install -m755 "$tool" "$pkgdir/usr/bin/$tool"
    done
}
```

## 🎨 Tool Usage Examples

### rearch-fetch
```bash
rearch-fetch              # Show system info
rearch-fetch --no-logo    # Without logo
rearch-fetch --minimal    # Minimal info
```

### rearch-sync
```bash
rearch-sync               # Full system update
rearch-sync --check       # Check only
rearch-sync --no-confirm  # Auto-confirm
```

### rearch-clean
```bash
rearch-clean              # Standard cleaning
rearch-clean --dry-run    # Preview only
rearch-clean --aggressive # Deep clean
```

### rearch-mirrors
```bash
rearch-mirrors            # Interactive selection
rearch-mirrors --top 5    # Top 5 fastest
```

## 📋 Requirements

- Arch Linux or Arch-based distro
- `base-devel` package group
- `archiso` package
- `pacman` package manager

```bash
sudo pacman -S base-devel archiso pacman
```

## 🔒 Security

- Packages can be signed with GPG
- Repository supports signature verification
- Keyring package for trust management

## 📚 Documentation

- [Folder Structure](docs/FOLDER_STRUCTURE.md)
- [Tools Documentation](docs/TOOLS.md)
- [Repository Workflow](docs/REPOSITORY.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

MIT License - REArch Team

## 🙏 Credits

- Arch Linux Team
- Archiso Developers
- REArch Contributors

---

**Made with ❤️ by the REArch Team**

Website: https://arch.revy.my.id  
GitHub: https://github.com/revyid/rearch-os
