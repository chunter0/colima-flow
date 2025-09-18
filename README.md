# Colima: Container Runtime for macOS

A streamlined Docker Desktop alternative that leverages Lima VMs to provide native container runtime capabilities on macOS, solving long-standing networking and performance issues that have plagued macOS developers.

## Why Colima?

### The macOS Container Problem

For years, macOS developers have struggled with containerization solutions that create an isolated virtual environment, making it difficult to:
- Access services running in containers from the host machine
- Connect to databases and APIs running in containers
- Debug applications that need to communicate between host and container environments
- Share network resources seamlessly between development tools

### Colima's Solution

Colima (Container on Linux for macOS) eliminates these pain points by:

1. **Seamless Network Integration**: Unlike Docker Desktop's VM isolation, Colima provides direct network access between your macOS host and container workloads
2. **True Host-Container Connectivity**: Services running in containers are directly accessible from your macOS host without complex port forwarding
3. **Lightweight Architecture**: Built on Lima (Linux-on-Mac), providing better resource utilization than heavy virtualization solutions
4. **Native Performance**: Optimized for Apple Silicon and Intel Macs with configurable VM types (QEMU/Virtualization.framework)

## Key Benefits

### 🌐 Superior Networking
- **Direct VM IP Access**: The VM gets a reachable IP address on your local network
- **Host Resolution**: Automatic `host.docker.internal` resolution for seamless host-container communication
- **No Port Forwarding Hassles**: Direct access to container services without manual port mapping
- **DNS Integration**: Custom DNS configuration and hostname resolution

### ⚡ Performance Optimized
- **Configurable Resources**: Fine-tune CPU, memory, and disk allocation
- **Multiple Mount Drivers**: Choose between `virtiofs`, `9p`, or `sshfs` based on your performance needs
- **Apple Silicon Support**: Native ARM64 support with optional Rosetta emulation

### 🛠 Developer Experience
- **Docker Drop-in Replacement**: Works with existing Docker workflows and tools
- **Kubernetes Ready**: Optional K3s integration for local Kubernetes development
- **SSH Access**: Direct SSH access to the VM for debugging and administration
- **Provision Scripts**: Automated VM setup with custom system and user scripts

## This Configuration

This repository provides a template for Colima setup with:

- **High-Performance VM**: 8 CPUs, 48GB RAM, 200GB disk
- **Network Access Enabled**: VM gets reachable IP for direct connectivity
- **Custom Provisioning**: Automated setup scripts for system and user configuration
- **Optimized Mounting**: Strategic volume mounts for development workflows
- **SSH Configuration**: Dedicated SSH port (2022) for VM access

## Quick Start

### Prerequisites
```bash
# Install Colima
make install
```

### Customizing Your Setup

When cloning this repository for your own use:

- **Configuration Files**: Place any dotfiles or configuration files you want available in the VM inside the `dotfiles/` directory (e.g., `.vimrc`, `.gitconfig`, etc.)
- **Provision Scripts**: Use the `scripts/` directory for setup commands that should run during VM provisioning (referenced in the `colima.yaml` configuration)

### Start Your Environment
```bash
# Copy configuration and start Colima
make start
```

This will:
1. Copy the optimized `colima.yaml` to your Colima profile
2. Start the VM with networking enabled
3. Run provisioning scripts for environment setup
4. Configure Docker context automatically

### Verify Installation
```bash
# Check Colima status
colima status

# Test Docker connectivity
docker run --rm -p 8080:80 nginx
# Access directly via VM IP or localhost:8080
```

## Network Configuration Highlights

```yaml
network:
  # Enable direct IP access to VM
  address: true
  
  # Resolve host.docker.internal properly
  dnsHosts:
    host.docker.internal: host.lima.internal
```

This configuration solves the classic macOS container networking problem by:
- Giving the VM a directly accessible IP address
- Enabling proper host-container DNS resolution
- Eliminating the need for complex port forwarding setups

## Advanced Usage

### Custom Provisioning
The configuration includes scripts in `/scripts/` that run on VM startup:
- `system.sh`: System-level configuration (runs as root)
- `user.sh`: User-level setup (runs as colima user)

### VM Management
```bash
# Stop the VM
colima stop

# Restart with configuration changes
colima delete && make start

# SSH into the VM
colima ssh

# View VM information
colima list
```

### Integration with Development Tools
Since the VM has a reachable IP address, you can:
- Connect database clients directly to containerized databases
- Access development servers from browsers without port forwarding
- Use network debugging tools that require direct connectivity
- Integrate with IDEs that need container network access

## Troubleshooting

### Common Issues
1. **Port conflicts**: Check if port 2022 is available for SSH
2. **Resource constraints**: Adjust CPU/memory in `colima.yaml` based on your system
3. **Mount issues**: Verify volume mount permissions and paths
4. **Provision scripts not running**: Sometimes provision scripts don't execute when starting a new instance, but will run on restart (`colima stop && colima start`)

### Debugging
```bash
# Check VM logs
colima logs

# SSH into VM for debugging
colima ssh

# Reset configuration
colima delete && make start
```

## Why Not Docker Desktop?

| Feature | Colima | Docker Desktop |
|---------|--------|----------------|
| Network Access | Direct VM IP | Port forwarding only |
| Resource Usage | Lightweight | Heavy resource consumption |
| Cost | Free | Paid for commercial use |
| Customization | Highly configurable | Limited options |
| Performance | Optimized for macOS | Generic virtualization |

## Contributing

This configuration is designed to be a starting point. Feel free to:
- Modify resource allocations in `colima.yaml`
- Add custom provisioning scripts
- Adjust network settings for your environment
- Submit improvements via pull requests

---

**Note**: This setup requires macOS and works best with recent versions (macOS 12+). For Apple Silicon Macs, consider enabling the Virtualization.framework (`vmType: vz`) for better performance.
