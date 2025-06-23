<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Note on NVIDIA Drivers Installation

When setting up the virtual machine, you may not have the CUDA drivers pre-installed. During the installation process, CUDA drivers and the toolkit are handled by the script. The installer will check if the CUDA drivers are working properly with:

```bash
nvidia-smi
```

If the command is not present or fails, you will be prompted to install the drivers through the script.

+ If you answer any of `(y|Y|yes|YES)`, the script will do the following:

    ```bash
    # Retrieve your OS name and version
    . /etc/os-release
    OS_ID=$ID
    OS_VERSION_ID=$VERSION_ID
    ARCH=$(uname -m)

    # Retrieve your architecture
    case "$ARCH" in
    x86_64)
        ARCH_PATH="x86_64"
        ;;
    aarch64)
        ARCH_PATH="arm64"
        ;;
    esac

    # Build a URL from this information to retrieve the installation kit from the NVIDIA archive
    URL="https://developer.download.nvidia.com/compute/cuda/repos/${OS_ID}${OS_VERSION_ID}/${ARCH_PATH}/cuda-keyring_1.1-1_all.deb"
    
    # Add the NVIDIA CUDA keyring and repository
    wget $URL
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda
    ```

+ **If you have any doubts**, please skip the CUDA installation by answering **no** to the prompt.
    Then follow the official tutorial provided by [cloud.google.com](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu).
    You will find three different guides:

  + **Install GPU drivers on VMs using [NVIDIA guides](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#no-secure-boot).**
    + In particular, when clicking on [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit-archive), you will be redirected to the [archive page](https://developer.nvidia.com/cuda-toolkit-archive). To [download the latest CUDA toolkit](https://developer.nvidia.com/cuda-downloads), they suggest a script very similar to the one above:

      ```bash
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
      sudo dpkg -i cuda-keyring_1.1-1_all.deb
      sudo apt-get update
      sudo apt-get -y install cuda-toolkit-12-8 # By choosing `cuda` instead of `cuda-toolkit-12-8`, both the toolkit and drivers are installed
      ```

  + **Install GPU drivers on VMs using the [installation script](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#install-script).**
    + In practice, this script may not always work as expected. Following the NVIDIA instructions is generally more reliable, but requires a better understanding of the process.

  + **Install GPU drivers on [Secure Boot VMs](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#secure-boot)**
    + This was not my use case. I am unsure how Secure Boot VMs interact with Nix. Please open an [issue](https://github.com/HugoHakem/nix-os.config/issues) if you encounter any problems or have relevant information.