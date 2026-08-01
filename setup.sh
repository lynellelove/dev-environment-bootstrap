#!/usr/bin/env bash

# Set Warnings
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Global Variables
ts=$(date +%y-%m-%d-%H-%M)


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  main
#   DESCRIPTION:  This is the main driver function.
#    PARAMETERS:  None
#       RETURNS:  Success or Error
#-------------------------------------------------------------------------------
main()
 {
    # Configure local bin
    echo "Configuring your local bin"

    dotfiles_bin="$HOME/dev-bootstrap-environment/bin"
    home_bin="$HOME/bin"
    LEADER="***"

    echo "$LEADER Creating Link to $home_bin from $dotfiles_bin folder"

    # Remove link if already exists
    if [ -e "$home_bin" ] || [ -L "$home_bin" ]; then
        echo "$LEADER Removing old link"
        rm -rf "$home_bin"
    fi 

    # Create new link
    echo "$LEADER Creating new Link"
    ln -s "$dotfiles_bin" "$home_bin"

    # Add ~/bin link to path if isn't already configured
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
        echo "$LEADER Adding $home_bin to your PATH variable in .bashrc"
        echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    else
        echo "$LEADER PATH already configured in .bashrc"
    fi

    echo "Installing Conda Python Environment"

    conda_script="$HOME/miniconda.sh"
    conda_path="$HOME/miniconda3"
    CONDA_INSTALL_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

    # Remove conda if it exists
    if [ -d "$conda_path" ]; then
        echo "$LEADER Removing the conda folder"
        rm -rf "$conda_path"
    fi 

    # Download conda
    echo "$LEADER Downloading the conda setup script"
    wget "$CONDA_INSTALL_URL" -O "$conda_script"
    
    # Install conda
    echo "$LEADER Installing conda"
    bash "$conda_script" -b -p "$conda_path"

    # Initialize conda and make it available in current session
    "$conda_path/bin/conda" init bash
    source "$conda_path/etc/profile.d/conda.sh" 

    # Create conda environment
    echo "$LEADER Creating a test conda environment"
    CONDA_ENV="test_env"
    conda create -n "$CONDA_ENV" python=3.10 -y

    # Activate conda environment
    echo "$LEADER Activating the test conda environment"
    conda activate "$CONDA_ENV"

    # Install packages
    echo "$LEADER Installing the test conda environment"
    conda install --file requirements.txt -y

    # Test
    python verify_python_env.py

    # Deactivate conda environment
    echo "$LEADER Deactivating the test conda environment"
    conda deactivate

    # Clean-up
    echo "$LEADER Removing the conda setup script"
    rm "$conda_script"

    echo "$LEADER Installing packages"

    # Update and install packages
    echo "Updating..."
    sudo apt update
    while read -r package || [ -n "$package" ]; do
        echo "$LEADER Installing $package..."
        sudo apt install -y "$package"
    done < packages.txt

    # Verify installation
    echo "$LEADER Verifying package installation(s)"
    success=0
    fail=0
    while read -r package || [ -n "$package" ]; do
        if dpkg -l "$package" 2>/dev/null | grep -q "^ii"; then
            echo "$package successfully installed"
            success=$((success+1))
        else
            echo "Unable to install $package"
            fail=$((fail+1))
        fi
    done < packages.txt
    echo "[$success] packages installed, [$fail] packages failed"

    echo "$LEADER Running system information script"

    # Activate conda env
    echo "$LEADER Activating conda environment"
    conda activate test_env

    # Run script
    python system_info.py

    # Check exit code
    echo "$LEADER Checking exit code"
    if [ $? -eq 0 ]; then
        echo "System information script successful"
    else
        echo "System information script failed with exit code $?"
    fi

    # Deactivate conda env
    echo "$LEADER Deactivating conda environment"
    conda deactivate

    # reset bash
    exec bash
}



############################ Main Program #####################################
main "$@"     

exit 0
