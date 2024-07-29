#!/bin/zsh

# Function to update and upgrade using dnf for Fedora/CentOS/RHEL
update_dnf() {
    echo "Updating and upgrading..."
    sudo dnf update -y
    sudo dnf upgrade -y
}

# Function to update and upgrade using apt for Ubuntu/Kali/Debian
update_apt() {
    echo "Updating and upgrading..."
    sudo apt update -y
    sudo apt upgrade -y
}

# Function to update and upgrade using Homebrew for macOS (or Linux if installed)
update_homebrew() {
    # Check if Homebrew is installed
    echo "Checking if Homebrew is installed..."
    echo ""
    if command -v brew &> /dev/null; then
        echo "Homebrew is installed."
        echo ""
        if brew update | grep -q "Already up-to-date"; then
            echo ""
            echo "Homebrew is already up to date."
        else
            echo "Homebrew updated."
            echo ""
            echo "Upgrading Homebrew packages..."
            brew upgrade
            echo ""
            echo "Tidying up Homebrew packages..."
            brew cleanup
        fi
    else
        echo "Homebrew is not installed. Skipping Homebrew updates."
    fi
}

# Determining the OS
if [ "$(uname)" = "Darwin" ]; then
    # macOS
    update_homebrew
elif [ -f /etc/redhat-release ] || [ -f /etc/fedora-release ] || [ -f /etc/rocky-release ]; then
    # RHEL, Fedora, or Rocky Linux
    update_dnf
    update_homebrew
elif [ -f /etc/lsb-release ]; then
    # Ubuntu
    update_apt
    update_homebrew
elif [ -f /etc/os-release ] && grep -q "ID=kali" /etc/os-release; then
    # Kali Linux
    update_apt 
    update_homebrew
else
    echo "Unsupported operating system."
    exit 1
fi

echo ""
echo "Updates and upgrades completed."
