# ReArch OS Tools Documentation

## Complete List of 24 ReArch Tools

### System Information & Monitoring (4 tools)

#### 1. rearch-fetch
High-speed, unique system information tool - faster alternative to neofetch/fastfetch.

```bash
rearch-fetch              # Show system info with logo
rearch-fetch --no-logo    # Show without logo
rearch-fetch --minimal    # Show minimal info
```

Features:
- Cached results for speed
- ReArch branding
- Comprehensive hardware info
- Battery status (laptops)

#### 2. rearch-sysinfo
Detailed system information with export capability.

```bash
rearch-sysinfo            # Show all info
rearch-sysinfo cpu        # CPU info only
rearch-sysinfo memory     # Memory info only
rearch-sysinfo export     # Export to file
```

#### 3. rearch-check
Comprehensive system health diagnostic tool.

```bash
rearch-check              # Full system check
rearch-check --quick      # Quick check only
rearch-check --disk-only  # Disk health only
rearch-check --ram-only   # RAM health only
```

Checks:
- Disk usage and SMART status
- RAM usage and errors
- Failed systemd units
- Security settings
- Network connectivity
- Temperatures

#### 4. rearch-update
Smart update notifier with caching.

```bash
rearch-update             # Check for updates
rearch-update --details   # Show update details
rearch-update --notify    # Send desktop notification
rearch-update --cached    # Show cached results
```

### Package Management (5 tools)

#### 5. rearch-sync
Universal package sync - handles pacman, AUR, and Flatpak in one command.

```bash
rearch-sync               # Full system update
rearch-sync --check       # Check only, don't update
rearch-sync --pacman-only # Pacman only
rearch-sync --aur-only    # AUR only
rearch-sync --no-confirm  # Don't ask for confirmation
```

#### 6. rearch-pkg
Enhanced pacman wrapper with additional features.

```bash
rearch-pkg search QUERY   # Search packages
rearch-pkg info PKG       # Show package info
rearch-pkg owner FILE     # Find package owning file
rearch-pkg orphans        # Show orphaned packages
rearch-pkg stats          # Package statistics
```

#### 7. rearch-aur
AUR helper manager - install and manage AUR helpers.

```bash
rearch-aur list           # List available helpers
rearch-aur install yay    # Install yay
rearch-aur search QUERY   # Search AUR
rearch-aur update         # Update AUR packages
```

#### 8. rearch-mirrors
Smart mirror selector - finds fastest mirrors based on location.

```bash
rearch-mirrors            # Interactive mirror selection
rearch-mirrors --country Indonesia  # Filter by country
rearch-mirrors --top 5    # Select top 5 mirrors
rearch-mirrors --restore  # Restore backup
```

#### 9. rearch-clean
Intelligent system cleaner - deep-cleans cache, orphans, and logs.

```bash
rearch-clean              # Standard cleaning
rearch-clean --dry-run    # Show what would be cleaned
rearch-clean --aggressive # Aggressive cleaning
rearch-clean --minimal    # Minimal cleaning
```

Cleans:
- Pacman cache
- Orphaned packages
- Log files
- User cache
- AUR build cache
- Docker resources
- Old kernels

### System Management (6 tools)

#### 10. rearch-kernel-toggle
Easy kernel switcher - switch between Zen, LTS, Mainline, Hardened.

```bash
rearch-kernel-toggle                    # Interactive menu
rearch-kernel-toggle list               # List installed kernels
rearch-kernel-toggle install linux-zen  # Install kernel
rearch-kernel-toggle default linux-lts  # Set default kernel
```

#### 11. rearch-services
Service manager - simplified systemd service management.

```bash
rearch-services           # Interactive menu
rearch-services list      # List services
rearch-services status SERVICE
rearch-services restart SERVICE
rearch-services logs SERVICE
```

#### 12. rearch-boot
Boot manager - manage GRUB, boot entries, and parameters.

```bash
rearch-boot               # Interactive menu
rearch-boot list          # List boot entries
rearch-boot default ENTRY # Set default entry
rearch-boot timeout 5     # Set timeout
rearch-boot params        # Edit kernel parameters
```

#### 13. rearch-logs
Log viewer - simplified journalctl wrapper.

```bash
rearch-logs               # Interactive menu
rearch-logs boot          # Current boot log
rearch-logs kernel        # Kernel logs
rearch-logs errors        # Error logs
rearch-logs follow        # Follow logs in real-time
```

#### 14. rearch-tweaks
System tweaks and optimizations.

```bash
rearch-tweaks             # Interactive menu
rearch-tweaks gaming      # Gaming optimizations
rearch-tweaks laptop      # Laptop optimizations
rearch-tweaks desktop     # Desktop optimizations
rearch-tweaks ssd         # SSD optimizations
```

#### 15. rearch-zram
ZRAM manager - configure and optimize ZRAM settings.

```bash
rearch-zram               # Interactive menu
rearch-zram status        # Show ZRAM status
rearch-zram enable        # Enable ZRAM
rearch-zram config        # Configure ZRAM
rearch-zram monitor       # Monitor ZRAM
```

### Hardware Management (4 tools)

#### 16. rearch-gpu
GPU manager - manage NVIDIA/AMD/Intel GPUs and drivers.

```bash
rearch-gpu                # Interactive menu
rearch-gpu info           # Show GPU info
rearch-gpu monitor        # Monitor GPU
rearch-gpu install nvidia # Install NVIDIA drivers
rearch-gpu switch         # Switch GPU (hybrid)
```

#### 17. rearch-wifi
Simplified WiFi manager - TUI for NetworkManager.

```bash
rearch-wifi               # Interactive menu
rearch-wifi scan          # Scan networks
rearch-wifi connect SSID  # Connect to network
rearch-wifi status        # Show connection status
```

#### 18. rearch-btrfs
Btrfs manager - snapshots, subvolumes, and filesystem management.

```bash
rearch-btrfs              # Interactive menu
rearch-btrfs snapshots    # List snapshots
rearch-btrfs create NAME  # Create snapshot
rearch-btrfs restore SNAP # Restore snapshot
rearch-btrfs balance      # Balance filesystem
```

#### 19. rearch-ports
Network port manager - monitor and manage network ports.

```bash
rearch-ports              # Interactive menu
rearch-ports list         # List listening ports
rearch-ports check PORT   # Check port status
rearch-ports kill PORT    # Kill process on port
rearch-ports firewall     # Show firewall status
```

### Desktop & Theming (3 tools)

#### 20. rearch-desktop
Desktop environment manager - install, switch, and manage DEs.

```bash
rearch-desktop            # Interactive menu
rearch-desktop list       # List available DEs
rearch-desktop install xfce
rearch-desktop switch kde
```

Supported DEs: XFCE, KDE Plasma, GNOME, Cinnamon, MATE, LXQt, Sway, Hyprland, i3

#### 21. rearch-theme
Theme manager - switch global themes simultaneously.

```bash
rearch-theme              # Interactive menu
rearch-theme list         # List available themes
rearch-theme apply dark   # Apply dark theme preset
rearch-theme gtk THEME    # Set GTK theme
rearch-theme icon THEME   # Set icon theme
```

#### 22. rearch-backup
Backup and restore tool.

```bash
rearch-backup             # Interactive menu
rearch-backup create      # Create backup
rearch-backup list        # List backups
rearch-backup restore NAME
```

### Additional Tools (2 tools)

#### 23. rearch-welcome
Welcome application (GUI) - helps users set up the OS.

#### 24. rearch-theme-engine
Theme engine (GUI) - advanced theme management.

## Tool Categories Summary

| Category | Tools | Count |
|----------|-------|-------|
| System Info | fetch, sysinfo, check, update | 4 |
| Package Mgmt | sync, pkg, aur, mirrors, clean | 5 |
| System Mgmt | kernel-toggle, services, boot, logs, tweaks, zram | 6 |
| Hardware | gpu, wifi, btrfs, ports | 4 |
| Desktop | desktop, theme, backup | 3 |
| GUI | welcome, theme-engine | 2 |
| **Total** | | **24** |

## Common Options

All tools support:
- `--help, -h` - Show help
- `--version, -v` - Show version
- Interactive mode (default when no arguments)
- Command mode (with arguments)

## Exit Codes

- 0 - Success
- 1 - General error
- 2 - Critical issues (rearch-check)
