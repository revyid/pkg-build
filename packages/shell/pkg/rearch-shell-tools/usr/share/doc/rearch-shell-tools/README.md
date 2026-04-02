# ReArch Shell Tools

This package contains the core shell tools for ReArch OS.

## Included Tools

### System Information & Monitoring
- `rearch-fetch` - High-speed system information fetcher
- `rearch-sysinfo` - Detailed system information
- `rearch-check` - System health diagnostic tool
- `rearch-update` - Update notifier

### Package Management
- `rearch-sync` - Universal package sync (pacman/AUR/Flatpak)
- `rearch-pkg` - Enhanced package manager
- `rearch-aur` - AUR helper manager
- `rearch-mirrors` - Smart mirror selector
- `rearch-clean` - Intelligent system cleaner

### System Management
- `rearch-kernel-toggle` - Easy kernel switcher
- `rearch-services` - Service manager
- `rearch-boot` - Boot manager
- `rearch-logs` - Log viewer
- `rearch-tweaks` - System optimizations
- `rearch-zram` - ZRAM manager

### Hardware Management
- `rearch-gpu` - GPU manager
- `rearch-wifi` - WiFi manager
- `rearch-btrfs` - Btrfs manager
- `rearch-ports` - Network port manager

### Desktop & Theming
- `rearch-desktop` - Desktop environment manager
- `rearch-theme` - Theme manager
- `rearch-backup` - Backup manager

## Usage

All tools support both interactive and command-line modes:

```bash
# Interactive mode (default)
rearch-fetch

# Command mode
rearch-fetch --no-logo
rearch-sync --check
rearch-clean --dry-run
```

## License

MIT License - REArch Team
