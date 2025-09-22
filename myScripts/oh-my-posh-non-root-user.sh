#!/bin/bash

###############################################
# setup oh-my-posh for non root user
###############################################
# Exit on error
set -e

# Ensure the script is NOT run as root
if [[ $EUID -eq 0 ]]; then
    echo "Please DO NOT run this script as root."
    exit 1
fi

# Variables
USER_HOME="$HOME"
OMP_BIN="$USER_HOME/.local/bin/oh-my-posh"
BASH_PROFILE="$USER_HOME/.bash_profile"
THEME_REPO="$USER_HOME/oh-my-posh"
THEME_DIR="$THEME_REPO/themes"
POSH_THEME="hul10"
THEME_PATH="$THEME_DIR/$POSH_THEME.omp.json"
FONT_LIST=("BigBlueTerminal" "DejaVuSansMono" "Hasklig" "Hack")

echo "Checking Oh My Posh installation..."

# Install Oh My Posh if not already installed
if [[ ! -f "$OMP_BIN" ]]; then
    echo "Installing Oh My Posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
else
    echo "Oh My Posh is already installed."
fi

echo "Version: $($OMP_BIN version)"

# Ensure ~/.local/bin is in PATH
if ! grep -q "$USER_HOME/.local/bin" "$BASH_PROFILE"; then
    echo "Adding $USER_HOME/.local/bin to PATH in $BASH_PROFILE..."
    echo 'export PATH=$PATH:$HOME/.local/bin' >> "$BASH_PROFILE"
    export PATH=$PATH:$HOME/.local/bin
fi

# Install Fonts
echo "Installing fonts..."
for font in "${FONT_LIST[@]}"; do
    if fc-list | grep -i "$font" > /dev/null; then
        echo "Font '$font' is already installed. Skipping."
    else
        echo "Installing font: $font..."
        $OMP_BIN font install "$font"
    fi
done

echo ""
echo "Installed fonts:"
printf '  - %s\n' "${FONT_LIST[@]}"
echo "Set one of these fonts manually in your terminal settings."

# Clone Oh My Posh theme repo if not already cloned
if [[ ! -d "$THEME_DIR" ]]; then
    echo "Cloning Oh My Posh themes into $THEME_REPO..."
    git clone https://github.com/JanDeDobbeleer/oh-my-posh.git "$THEME_REPO"
else
    echo "Theme repository already exists at $THEME_REPO"
fi

# Check theme file
if [[ ! -f "$THEME_PATH" ]]; then
    echo "Theme file not found: $THEME_PATH"
    exit 1
fi

# Configure Oh My Posh in .bash_profile
if ! grep -q "oh-my-posh init bash" "$BASH_PROFILE"; then
    echo "Adding Oh My Posh configuration to $BASH_PROFILE..."
    {
        echo ""
        echo "# >>> Oh My Posh Setup >>>"
        echo "export POSH_THEME=\"$POSH_THEME\""
        echo "eval \"\$($OMP_BIN init bash --config $THEME_PATH)\""
        echo "# <<< Oh My Posh Setup <<<"
    } >> "$BASH_PROFILE"
else
    echo "Oh My Posh is already configured in $BASH_PROFILE"
fi

# Reload shell
echo "Reloading $BASH_PROFILE..."
source "$BASH_PROFILE"

echo "Setup complete. Launching new shell..."
exec bash
