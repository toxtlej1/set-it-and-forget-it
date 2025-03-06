#!/bin/bash

# Define the list of applications/tools in a separate file
CONFIG_FILE="apps.txt"

# Function to install Homebrew if not installed
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi
}

# Function to install applications from a list
install_apps() {
    while IFS= read -r app || [[ -n "$app" ]]; do
        if [[ ! "$app" =~ ^#.*$ ]]; then
            if [[ "$app" == cask:* ]]; then
                app_name="${app#cask:}"  # Remove 'cask:' prefix
                echo "Installing GUI app: $app_name..."
                brew install --cask "$app_name" || echo "Failed to install $app_name"
            else
                echo "Installing CLI tool: $app..."
                brew install "$app" || echo "Failed to install $app"
            fi
        fi
    done < "$CONFIG_FILE"
}

# Execute functions
install_homebrew
brew update
install_apps

echo "Setup complete!"
