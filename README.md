# Simple flake example to build docker images for different platforms

## Quick Start (no checkout required)

ARM (aarch64-linux):

```bash
$ nix build github:MaxDaten/flake-cross-container-example#hello-aarch64-linux
$ skopeo inspect docker-archive:result | jq -r '.Os, .Architecture'
linux
arm64
```

x86 (x86_64-linux):

```bash
$ nix build github:MaxDaten/flake-cross-container-example#hello-x86_64-linux
$ skopeo inspect docker-archive:result | jq -r '.Os, .Architecture'
linux
amd64
```

## Extended Guide

To build images for different platforms using `nix build`, follow these steps:

1. Ensure you have Nix installed on your system. If not, you can install it using the following command:

    ```bash
    curl -L https://nixos.org/nix/install | sh
    ```

    And make sure flake support is enabled. You can do this by adding the following line to your `~/.config/nix/nix.conf` file:

    ```conf
    experimental-features = nix-command flakes
    ```

2. Run the following command to build the image:

    For example, to build the image for `aarch64-linux`, you can use the following command:

    ```bash
    $ nix build .#hello-aarch64-linux
    $ skopeo inspect docker-archive:result | jq -r '.Os, .Architecture'
    linux
    arm64
    ```

The pattern for the build targets is `.<name>-<platform>`.

Please note that the available platforms are defined in the `allSystems` attribute of the `flake.nix` file. In this case, the available platforms are `x86_64-darwin`, `aarch64-darwin`, `x86_64-linux`, and `aarch64-linux`.
