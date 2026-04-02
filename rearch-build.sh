#!/bin/bash
#
# rearch-build.sh - Master build script for ReArch OS
# Automates compilation, repository creation, and ISO generation
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR/rearch-repo"
REPO_DB="$REPO_DIR/x86_64/rearch-repo.db.tar.gz"
PACKAGES_DIR="$SCRIPT_DIR/packages"
ISO_PROFILE="$SCRIPT_DIR/iso-profile"
OUTPUT_DIR="$SCRIPT_DIR/out"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_section() { echo -e "\n${CYAN}${BOLD}▶ $1${NC}"; }

# Show banner
show_banner() {
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
    ____  _______    ____             __
   / __ \/ ___/ /   / __ \____ ______/ /_
  / /_/ / /  / /   / /_/ / __ `/ ___/ __ \
 / _, _/ /__/ /___/ _, _/ /_/ (__  ) / / /
/_/ |_|\____/_____/_/ |_|\__,_/____/_/ /_/

EOF
    echo -e "${NC}"
    echo -e "${BOLD}ReArch OS Build System${NC}\n"
}

# Check dependencies
check_deps() {
    log_section "Checking Dependencies"
    
    local deps=("makepkg" "repo-add" "mkarchiso" "pacman")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Install with: sudo pacman -S base-devel archiso pacman"
        exit 1
    fi
    
    log_success "All dependencies satisfied"
}

# Initialize repository
init_repo() {
    log_section "Initializing Repository"
    
    mkdir -p "$REPO_DIR/x86_64"
    
    # Create pacman.conf for the repository
    cat > "$REPO_DIR/pacman.conf" << EOF
#
# ReArch Repository Configuration
#

[options]
HoldPkg = pacman glibc
Architecture = auto
Color
CheckSpace
ParallelDownloads = 5
ILoveCandy

[rearch]
SigLevel = Optional TrustAll
Server = file://$REPO_DIR/\$arch

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
    
    log_success "Repository initialized at $REPO_DIR"
}

# Build a single package
build_package() {
    local pkg_dir="$1"
    local pkg_name=$(basename "$pkg_dir")
    
    log_info "Building $pkg_name..."
    
    if [[ ! -f "$pkg_dir/PKGBUILD" ]]; then
        log_warn "No PKGBUILD found in $pkg_dir, skipping"
        return 0
    fi
    
    cd "$pkg_dir"
    
    # Clean previous builds
    rm -rf pkg src *.pkg.tar.*
    
    # Build package skipping dependency checks for custom local packages
    if makepkg -sfd --skipinteg --noconfirm; then
        # Move built packages to repo
        for pkg in *.pkg.tar.zst; do
            if [[ -f "$pkg" ]]; then
                mv "$pkg" "$REPO_DIR/x86_64/"
                log_success "Built: $pkg"
            fi
        done
    else
        log_error "Failed to build $pkg_name"
        return 1
    fi
    
    cd "$SCRIPT_DIR"
}

# Build all packages
build_all_packages() {
    log_section "Building Packages"
    
    # Build core packages first
    log_info "Building CORE packages..."
    for pkg_dir in "$PACKAGES_DIR"/core/*/; do
        [[ -d "$pkg_dir" ]] || continue
        build_package "$pkg_dir"
    done
    
    # Build shell tools
    log_info "Building SHELL tools..."
    if [[ -f "$PACKAGES_DIR/shell/PKGBUILD" ]]; then
        cd "$PACKAGES_DIR/shell"
        
        # Build skipping dependency checks
        rm -rf pkg src *.pkg.tar.*
        if makepkg -sfd --skipinteg --noconfirm; then
            for pkg in *.pkg.tar.zst; do
                [[ -f "$pkg" ]] && mv "$pkg" "$REPO_DIR/x86_64/"
            done
            log_success "Shell tools built"
        fi
        
        # Cleanup
        rm -f rearch-*
        cd "$SCRIPT_DIR"
    fi
    
    # Build GUI packages
    log_info "Building GUI packages..."
    for pkg_dir in "$PACKAGES_DIR"/gui/*/; do
        [[ -d "$pkg_dir" ]] || continue
        build_package "$pkg_dir"
    done
    
    # Build utils packages
    log_info "Building UTILS packages..."
    for pkg_dir in "$PACKAGES_DIR"/utils/*/; do
        [[ -d "$pkg_dir" ]] || continue
        build_package "$pkg_dir"
    done
}

# Update repository database
update_repo_db() {
    log_section "Updating Repository Database"
    
    cd "$REPO_DIR/x86_64"
    
    # Remove old database
    rm -f rearch-repo.db.tar.gz rearch-repo.files.tar.gz
    rm -f rearch-repo.db rearch-repo.files
    
    # Create new database
    for pkg in *.pkg.tar.zst; do
        if [[ -f "$pkg" ]]; then
            repo-add rearch-repo.db.tar.gz "$pkg"
        fi
    done
    
    # Create symlinks
    ln -sf rearch-repo.db.tar.gz rearch-repo.db 2>/dev/null || true
    ln -sf rearch-repo.files.tar.gz rearch-repo.files 2>/dev/null || true
    
    cd "$SCRIPT_DIR"
    
    log_success "Repository database updated"
    
    # Show repo contents
    log_info "Repository contents:"
    ls -lh "$REPO_DIR/x86_64/"*.pkg.tar.zst 2>/dev/null | awk '{print "  " $9, "(" $5 ")"}'
}

# Create ISO profile
create_iso_profile() {
    log_section "Creating ISO Profile"
    
    mkdir -p "$ISO_PROFILE"
    
    # Copy base from existing or create new
    if [[ -d "$SCRIPT_DIR/../rearch-os-main" ]]; then
        log_info "Using existing ISO profile as base"
        cp -r "$SCRIPT_DIR/../rearch-os-main/"* "$ISO_PROFILE/" 2>/dev/null || true
    fi
    
    # Update pacman.conf to include rearch repo
    cat > "$ISO_PROFILE/pacman.conf" << EOF
#
# ReArch OS Pacman Configuration for ISO Build
#

[options]
HoldPkg = pacman glibc
Architecture = auto
Color
CheckSpace
ParallelDownloads = 5
DisableDownloadTimeout
ILoveCandy
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional

#
# REARCH CUSTOM REPOSITORY
#
[rearch]
Server = file://$REPO_DIR/\$arch
SigLevel = Optional TrustAll

#
# ARCH LINUX OFFICIAL REPOSITORIES
#
[core]
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch

[extra]
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch

[multilib]
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
EOF
    
    # Update packages.x86_64 to include rearch packages
    if [[ -f "$ISO_PROFILE/packages.x86_64" ]]; then
        # Add rearch packages at the end
        cat >> "$ISO_PROFILE/packages.x86_64" << 'EOF'

# --- ReArch OS Custom Packages ---
rearch-keyring
rearch-hooks
rearch-base
rearch-shell-tools
EOF
    fi
    
    # Copy repository to airootfs
    mkdir -p "$ISO_PROFILE/airootfs/etc/pacman.d"
    cp "$ISO_PROFILE/pacman.conf" "$ISO_PROFILE/airootfs/etc/pacman.conf"
    
    # Add rearch repo to installed system
    mkdir -p "$ISO_PROFILE/airootfs/etc/pacman.d"
    cat > "$ISO_PROFILE/airootfs/etc/pacman.d/rearch-repo.conf" << EOF
[rearch]
Server = https://arch.revy.my.id/repo/\$arch
SigLevel = Optional TrustAll
EOF
    
    log_success "ISO profile created at $ISO_PROFILE"
}

# Build ISO
build_iso() {
    log_section "Building ISO"
    
    mkdir -p "$OUTPUT_DIR"
    
    # Clean previous build if requested
    if [[ "${CLEAN_BUILD:-0}" == "1" ]]; then
        log_info "Cleaning previous build..."
        sudo rm -rf "$OUTPUT_DIR/work"
    fi
    
    # Build ISO using mkarchiso
    log_info "Running mkarchiso (this may take 30-60 minutes)..."
    
    if sudo mkarchiso -v -w "$OUTPUT_DIR/work" -o "$OUTPUT_DIR" "$ISO_PROFILE"; then
        log_success "ISO built successfully!"
        
        # Show ISO info
        local iso_file=$(ls -t "$OUTPUT_DIR"/*.iso 2>/dev/null | head -1)
        if [[ -f "$iso_file" ]]; then
            echo ""
            echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
            echo -e "${GREEN}${BOLD}  ReArch OS ISO Built Successfully!${NC}"
            echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════════════${NC}"
            echo ""
            echo -e "  ${CYAN}ISO File:${NC} $iso_file"
            echo -e "  ${CYAN}Size:${NC} $(du -h "$iso_file" | cut -f1)"
            echo -e "  ${CYAN}SHA256:${NC} $(sha256sum "$iso_file" | cut -d' ' -f1)"
            echo ""
            echo -e "  ${YELLOW}To test the ISO:${NC}"
            echo -e "  ${GREEN}qemu-system-x86_64 -m 4096 -cdrom $iso_file${NC}"
            echo ""
        fi
    else
        log_error "ISO build failed"
        return 1
    fi
}

# Sign packages (optional)
sign_packages() {
    log_section "Signing Packages"
    
    if [[ -n "$GPG_KEY" ]]; then
        cd "$REPO_DIR/x86_64"
        
        for pkg in *.pkg.tar.zst; do
            if [[ -f "$pkg" && ! -f "$pkg.sig" ]]; then
                log_info "Signing $pkg..."
                gpg --detach-sign --use-agent -u "$GPG_KEY" "$pkg"
            fi
        done
        
        cd "$SCRIPT_DIR"
        log_success "Packages signed"
    else
        log_warn "GPG_KEY not set, skipping package signing"
    fi
}

# Clean build artifacts
clean() {
    log_section "Cleaning Build Artifacts"
    
    read -rp "Remove all build artifacts? [y/N]: " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sudo rm -rf "$OUTPUT_DIR"
        rm -rf "$REPO_DIR/x86_64"/*.pkg.tar.zst
        rm -f "$REPO_DIR/x86_64"/*.db*
        rm -f "$REPO_DIR/x86_64"/*.files*
        
        # Clean package build directories
        for pkg_dir in "$PACKAGES_DIR"/*/*/; do
            [[ -d "$pkg_dir" ]] || continue
            rm -rf "$pkg_dir/pkg" "$pkg_dir/src" "$pkg_dir"/*.pkg.tar.*
        done
        
        log_success "Build artifacts cleaned"
    fi
}

# Show help
usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  all               Build everything (packages, repo, ISO)"
    echo "  packages          Build packages only"
    echo "  repo              Update repository database only"
    echo "  iso               Build ISO only"
    echo "  sign              Sign packages"
    echo "  clean             Clean build artifacts"
    echo "  help              Show this help"
    echo ""
    echo "Environment variables:"
    echo "  CLEAN_BUILD=1     Force clean ISO build"
    echo "  GPG_KEY=<key>     GPG key for package signing"
}

# Main function
main() {
    show_banner
    
    case "${1:-all}" in
        all)
            check_deps
            init_repo
            build_all_packages
            update_repo_db
            sign_packages
            create_iso_profile
            build_iso
            ;;
        packages)
            check_deps
            init_repo
            build_all_packages
            update_repo_db
            ;;
        repo)
            update_repo_db
            ;;
        iso)
            check_deps
            create_iso_profile
            build_iso
            ;;
        sign)
            sign_packages
            ;;
        clean)
            clean
            ;;
        help|--help|-h)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown command: $1"
            usage
            exit 1
            ;;
    esac
    
    echo ""
    log_success "Build process completed!"
}

main "$@"
