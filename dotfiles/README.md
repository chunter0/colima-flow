# Dotfiles Directory

This directory contains configuration files (dotfiles) that will be available in your Colima VM. These files help customize your development environment and maintain consistent tooling across different machines.

## What Goes Here

Place any configuration files you want accessible inside the VM. These typically include:

### Shell & Terminal Configuration
- `.bashrc` / `.zshrc` - Shell configuration and aliases
- `.bash_profile` / `.zsh_profile` - Login shell configuration
- `.tmux.conf` - Terminal multiplexer configuration ✓ (included)

### Editor Configuration
- `.vimrc` - Vim editor configuration ✓ (included)
- `.nvim/` - Neovim configuration directory
- `.emacs` / `.emacs.d/` - Emacs configuration

### Development Tools
- `.gitconfig` - Git configuration ✓ (included as template)
- `.gitignore_global` - Global Git ignore patterns
- `.ssh/config` - SSH client configuration
- `.aws/config` - AWS CLI configuration
- `.docker/config.json` - Docker client configuration

### Language-Specific Configuration
- `.npmrc` - Node.js package manager configuration
- `.pypirc` - Python package index configuration
- `.gemrc` - Ruby gem configuration
- `.cargo/config` - Rust package manager configuration

### System Monitoring & Tools
- `btop.conf` - System monitor configuration ✓ (included)
- `.htoprc` - Process viewer configuration
- `.curlrc` - cURL default options

## Current Files

This directory already includes:
- `vimrc` - Basic Vim configuration
- `gitconfig.tpl` - Git configuration template
- `tmux.conf` - Terminal multiplexer setup
- `btop.conf` - System monitor configuration
- `.env` - Environment variables

## How It Works

1. **Mount Point**: This directory is mounted to `/tmp/colima/dotfiles/` in the VM
2. **Provisioning**: The user provisioning script (`scripts/user.sh`) copies these files to the appropriate locations in the home directory
3. **Templates**: Files ending in `.tpl` are processed as templates with variable substitution

## Adding Your Own Files

1. Place your dotfiles in this directory
2. Update `scripts/user.sh` to copy them to the correct locations in the VM
3. For files requiring variable substitution, use the `.tpl` extension

### Example: Adding a .bashrc

1. Create `dotfiles/.bashrc`:
```bash
# Custom aliases
alias ll='ls -la'
alias gs='git status'

# Environment variables
export EDITOR=vim
```

2. Update `scripts/user.sh` to copy it:
```bash
# Copy bashrc
cp /tmp/colima/dotfiles/.bashrc ~/.bashrc
```

### Example: Adding a template file

1. Create `dotfiles/myconfig.tpl`:
```
username=${GITHUB_USER}
email=${GITHUB_USER}@example.com
```

2. Process it in `scripts/user.sh`:
```bash
# Process template
envsubst < /tmp/colima/dotfiles/myconfig.tpl > ~/.myconfig
```

## Best Practices

- **Keep it minimal**: Only include files you actually use
- **Use templates**: For files that need environment-specific values
- **Test changes**: Use `colima stop && colima start` to test new configurations
- **Version control**: Keep your dotfiles in this repository for consistency
- **Document dependencies**: If your dotfiles require specific tools, note them in the provision scripts

## Security Note

Be careful not to include sensitive information like:
- Private SSH keys
- API tokens or passwords
- Personal email addresses (use templates instead)

Use environment variables and templates for any user-specific or sensitive data.
