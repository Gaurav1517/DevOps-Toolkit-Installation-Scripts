#!/bin/bash
############################################
# Setup oh-my-posh for root user
############################################
# Exit on error
set -e

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo " Please run as root."
    exit 1
fi

echo " Checking Oh My Posh installation..."
OMP_BIN="/root/.local/bin/oh-my-posh"
if [[ ! -f "$OMP_BIN" ]]; then
    echo " Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    echo " Oh My Posh already installed at $OMP_BIN"
fi

echo " Version: $($OMP_BIN version)"

# Ensure /root/.local/bin is in PATH
if ! grep -q "/root/.local/bin" /root/.bash_profile; then
    echo " Adding /root/.local/bin to PATH..."
    echo 'export PATH=$PATH:/root/.local/bin' >> /root/.bash_profile
    export PATH=$PATH:/root/.local/bin
fi

# Install fonts
FONT_DIR="/usr/share/fonts"
FONT_LIST=("BigBlueTerminal" "DejaVuSansMono" "Hasklig" "Hack")

echo " Installing fonts (if not already installed)..."
for font in "${FONT_LIST[@]}"; do
    # Check if font is already installed (case-insensitive match)
    if fc-list | grep -i "$font" > /dev/null; then
        echo " Font '$font' already installed. Skipping."
    else
        echo " Installing font '$font'..."
        $OMP_BIN font install "$font"
    fi
done

echo " Fonts installed. Set one of them manually in your terminal emulator:"
printf '  - %s\n' "${FONT_LIST[@]}"
echo ""

# Clone theme repo if not present
THEME_REPO="/root/oh-my-posh"
THEME_DIR="$THEME_REPO/themes"
if [[ ! -d "$THEME_DIR" ]]; then
    echo " Cloning Oh My Posh themes..."
    git clone https://github.com/JanDeDobbeleer/oh-my-posh.git "$THEME_REPO"
else
    echo " Themes already cloned at $THEME_DIR"
fi

# Select theme
POSH_THEME="hul10"
THEME_PATH="$THEME_DIR/$POSH_THEME.omp.json"

if [[ ! -f "$THEME_PATH" ]]; then
    echo " Theme file not found: $THEME_PATH"
    exit 1
fi

# Set up oh-my-posh init in bash_profile
if ! grep -q "oh-my-posh init bash" /root/.bash_profile; then
    echo " Adding Oh My Posh config to /root/.bash_profile..."
    {
        echo ""
        echo "# >>> Oh My Posh Setup >>>"
        echo "export POSH_THEME=\"$POSH_THEME\""
        echo "eval \"\$($OMP_BIN init bash --config $THEME_PATH)\""
        echo "# <<< Oh My Posh Setup <<<"
    } >> /root/.bash_profile
else
    echo " Oh My Posh already configured in /root/.bash_profile"
fi

# Final reload
echo " Reloading profile..."
source /root/.bash_profile

echo " Setup complete! Launching new shell..."
exec bash
