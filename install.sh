#!/usr/bin/env bash
# install.sh — prototyper installer for ~/.agents/skills/prototyper/
#
# Single source of truth: `~/.agents/skills/prototyper/` holds the real files.
# Each detected AI tool (Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot)
# gets a link from its skills directory pointing to the canonical location.
# Manage one place, every tool sees the update.
#
# Link type per platform:
#   * Linux / macOS: POSIX symlink (`ln -sfn`)
#   * Windows (Git Bash / MSYS): NTFS junction (`mklink /J`) — works without
#     admin rights or Developer Mode
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/ZorCorp/prototyper/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --update
#   curl -fsSL .../install.sh | bash -s -- --uninstall
#   curl -fsSL .../install.sh | bash -s -- --no-link       # skip the symlink step
#   curl -fsSL .../install.sh | bash -s -- --force-link    # symlink even if tool dir absent
#
# Advanced: override the source tarball (e.g. to test a feature branch)
#   REPO_TARBALL=https://github.com/ZorCorp/prototyper/archive/refs/heads/my-branch.tar.gz \
#     bash install.sh

set -euo pipefail

REPO_TARBALL="${REPO_TARBALL:-https://github.com/ZorCorp/prototyper/archive/refs/heads/main.tar.gz}"
INSTALL_DIR="$HOME/.agents/skills/prototyper"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP_DIR="$HOME/.agents/skills/prototyper.bak-$TIMESTAMP"
STAGING=""
DO_LINK=1
FORCE_LINK=0

# Tools to link into, in "name:target_path" form.
LINK_TARGETS=(
    "claude-code:$HOME/.claude/skills/prototyper"
    "codex:$HOME/.codex/skills/prototyper"
    "gemini-cli:$HOME/.gemini/skills/prototyper"
    "cursor:$HOME/.cursor/skills/prototyper"
    "github-copilot:$HOME/.copilot/skills/prototyper"
)

cleanup() {
    if [[ -n "$STAGING" && -d "$STAGING" ]]; then
        rm -rf "$STAGING"
    fi
}
trap cleanup EXIT

MODE="install"
for arg in "$@"; do
    case "$arg" in
        --update)      MODE="update" ;;
        --uninstall)   MODE="uninstall" ;;
        --no-link)     DO_LINK=0 ;;
        --force-link)  FORCE_LINK=1 ;;
        *) echo "Unknown arg: $arg" >&2; exit 2 ;;
    esac
done

is_windows() {
    case "$(uname -s 2>/dev/null)" in
        MINGW*|MSYS*|CYGWIN*) return 0 ;;
        *) return 1 ;;
    esac
}

make_dir_link() {
    local src="$1" dst="$2"
    if is_windows; then
        local src_win dst_win
        src_win="$(cygpath -w "$src" 2>/dev/null || echo "$src")"
        dst_win="$(cygpath -w "$dst" 2>/dev/null || echo "$dst")"
        echo "mklink /J \"$dst_win\" \"$src_win\"" | cmd >/dev/null 2>&1
        if [[ -e "$dst" ]]; then
            return 0
        else
            return 1
        fi
    else
        ln -sfn "$src" "$dst"
    fi
}

is_dir_link() {
    [[ -L "$1" ]]
}

link_points_to_ours() {
    local path="$1"
    [[ -L "$path" ]] || return 1
    local resolved; resolved="$(readlink "$path" 2>/dev/null || true)"
    [[ -z "$resolved" ]] && return 1
    if [[ "$resolved" == "$INSTALL_DIR" ]]; then
        return 0
    fi
    [[ "$resolved" == *"/.agents/skills/prototyper" ]]
}

remove_dir_link() {
    local path="$1"
    rm -f "$path" 2>/dev/null || true
    if [[ -e "$path" ]] && is_windows; then
        local path_win; path_win="$(cygpath -w "$path" 2>/dev/null || echo "$path")"
        echo "rmdir \"$path_win\"" | cmd >/dev/null 2>&1 || true
    fi
}

link_to_tools() {
    local canonical="$INSTALL_DIR"
    echo ""
    echo "Linking skill to detected AI tools:"
    local linked=0 skipped=0
    for entry in "${LINK_TARGETS[@]}"; do
        local name="${entry%%:*}"
        local target="${entry#*:}"
        local parent; parent="$(dirname "$target")"
        if [[ ! -d "$parent" && "$FORCE_LINK" != "1" ]]; then
            continue
        fi
        mkdir -p "$parent"
        if is_dir_link "$target"; then
            remove_dir_link "$target"
        elif [[ -e "$target" ]]; then
            echo "  ⚠ $name: $target exists and is not a symlink — skipped (use --force-link to override)"
            skipped=$((skipped + 1))
            continue
        fi
        make_dir_link "$canonical" "$target"
        echo "  ✓ $name → $target"
        linked=$((linked + 1))
    done
    if (( linked == 0 && skipped == 0 )); then
        echo "  (no AI tools detected — canonical copy at $canonical still works for any framework that reads ~/.agents/skills/)"
    fi
}

unlink_tools() {
    local removed=0
    for entry in "${LINK_TARGETS[@]}"; do
        local target="${entry#*:}"
        if link_points_to_ours "$target"; then
            remove_dir_link "$target"
            echo "  ✓ removed link $target"
            removed=$((removed + 1))
        fi
    done
    if (( removed == 0 )); then
        echo "  (no prototyper links found)"
    fi
}

uninstall() {
    echo "Removing prototyper symlinks:"
    unlink_tools
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        echo "✓ Removed $INSTALL_DIR"
    else
        echo "Nothing to uninstall at $INSTALL_DIR"
    fi
}

fetch_and_extract() {
    local dest="$1"
    mkdir -p "$dest"
    if ! curl -fsSL "$REPO_TARBALL" | tar -xz --strip-components=1 -C "$dest"; then
        echo "❌ Failed to fetch or extract $REPO_TARBALL" >&2
        exit 1
    fi
    if [[ -f "$dest/install.sh" ]]; then
        chmod +x "$dest/install.sh"
    fi
    if [[ -f "$dest/scripts/setup.js" ]]; then
        chmod +x "$dest/scripts/setup.js"
    fi
}

prune_backups() {
    local parent="$HOME/.agents/skills"
    local -a olds
    # shellcheck disable=SC2207
    olds=($(ls -dt "$parent/prototyper.bak-"* 2>/dev/null | tail -n +2))
    if (( ${#olds[@]} > 0 )); then
        rm -rf "${olds[@]}"
    fi
}

print_next_steps() {
    cat <<'EOS'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Next steps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Restart your agent so it picks up the new skill.

2. Try the HKUST Store demo:
     cd ~/.agents/skills/prototyper/examples/uststore
     claude
     /prototyper:uststore

3. Or run the full workflow on your own project:
     cd /path/to/your/project
     claude
     /prototyper:prototyper .

EOS
}

case "$MODE" in
    uninstall)
        uninstall
        exit 0
        ;;
    install|update)
        mkdir -p "$HOME/.agents/skills"
        if [[ -d "$INSTALL_DIR" ]]; then
            STAGING="$(mktemp -d)"
            fetch_and_extract "$STAGING"
            if diff -qr "$INSTALL_DIR" "$STAGING" >/dev/null 2>&1; then
                echo "✓ Already up-to-date at $INSTALL_DIR"
            else
                mv "$INSTALL_DIR" "$BACKUP_DIR"
                mv "$STAGING" "$INSTALL_DIR"
                STAGING=""
                echo "✓ Installed to $INSTALL_DIR (previous version backed up to $BACKUP_DIR)"
                prune_backups
            fi
        else
            fetch_and_extract "$INSTALL_DIR"
            echo "✓ Installed to $INSTALL_DIR"
        fi
        if [[ "$DO_LINK" == "1" ]]; then
            link_to_tools
        else
            echo ""
            echo "(--no-link: skipped symlink step; canonical copy at $INSTALL_DIR)"
        fi
        print_next_steps
        ;;
esac
