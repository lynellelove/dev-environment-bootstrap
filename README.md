# Linux Development Environment Bootstrap

A Bash/Python developer tooling project for bootstrapping a Linux-based development environment.

This project automates several setup tasks that are commonly needed on a new development machine, including configuring a local `~/bin` directory, installing a Miniconda Python environment, installing system packages, and running basic environment verification scripts.

## Overview

The main setup script performs the following actions:

- Configures a local `~/bin ` directory using a symbolic link to the repository's `bin` folder
- Adds `~/bin~ to the user's shell `PATH` if it is not already configured
- Downloads and installs Miniconda
- Creates a Conda environment for Python development
- Installs Python dependencies from `requirements.txt`
- Installs selected Linux packages from `packages.txt`
- Runs Python verification scripts to confirm the environment is working
- Prints basic system and hardware information

## Project Structure

```text
.
├── bin/
├── setup.sh
├── system_info.py
├── verify_python_env.py
├── packages.txt
├── requirements.txt
└── README.md
```

## Technologies Used

- Bash
- Python
- Conda/Miniconda
- Linux pacakge management with apt

## Python Dependencies

The Python environment installs the packages listed in `requirements.txt`:

- pandas
- lxml
- bs4
- requests

## System Packages

The setup script installs the packages listed in `packages.txt`:

- doxygen
- sqlite3

## Scripts

`setup.sh`
Main bootstrap script. It configures the local bin directory, installs Miniconda, creates a Python environment, installs dependencies, installs selected system packages, and runs verification scripts.

`verify_python_environment`
Verifies that selected Python dependencies can be imported successfully.

`system_info.py`
Prints basic operating system and hardware information useing Python's `platform` module.

## How to Run

This project is intended for a Linux environment.

From the project root, make the setup script executable:

`chmod +x setup.sh`

Then run:

`./setup.sh`

## Notes

This script makes changes to the user's local development environment, including:

- Creating or replacing the `~/bin` symbolic link
- Updating .bashrc to include `~/bin` in the shell `PATH`
- Installing Miniconda under the user's home directory
- Installing system packages with `apt`

Review the script before running it on a new machine.

## What I Learned

This project helped reinforce practical scripting and automation concepts, including:

- Writing Bash scripts
- Creating symbolic links
- Updating shell configuration files
- Automating pacakge installation
- Creating and activating Conda environments
- Using Pythonfor environment verification and system information reporting
- Structuring a small developer tooling project for reuse