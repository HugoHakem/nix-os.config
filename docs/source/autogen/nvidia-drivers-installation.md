<!-- AUTO-GENERATED FILE. DO NOT EDIT. -->
<!-- markdownlint-disable MD041 MD047 MD059 -->

# Note on NVIDIA drivers installation

When setting up the Virtual Machine, you may not have the CUDA drivers already installed. In the installation set up, CUDA drivers and toolkit are taking care of in the script. The installer will check if cuda drivers are working fine with:

```bash
nvidia-smi
```

If the command is not present or just fail, you will be prompt whether you want to install it through the script.

+ If you answer any of `(y|Y|yes|YES)` this will do the following:

    ```bash
    # Retrieve your OS name, and version
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

    # Build a URL from those information from where to retrieve the installation kit in the NVIDIA archive
    URL="https://developer.download.nvidia.com/compute/cuda/repos/${OS_ID}${OS_VERSION_ID}/${ARCH_PATH}/cuda-keyring_1.1-1_all.deb"
    
    # Add the NVIDIA CUDA keyring and repo
    wget $URL
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda
    ```

+ **If you have any doubt**, please skip the installation of CUDA by saying **no** to the prompt.
    Then follow the tutorial provided by [cloud.google.com](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu) itself.  
    You will find 3 different guide.

  + **Install GPU drivers on VMs by using NVIDIA guides [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#no-secure-boot).**
    + In particular, when clicking on [NVIDIA CUDA Toolkit](https://developer.nvidia.com/cuda-toolkit-archive), you will end up on that [page](https://developer.nvidia.com/cuda-toolkit-archive). Then when wanting to [download the latest CUDA toolkit](https://developer.nvidia.com/cuda-downloads) they will suggest a script that is very similar to our installation mode:

      ```bash
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
      sudo dpkg -i cuda-keyring_1.1-1_all.deb
      sudo apt-get update
      sudo apt-get -y install cuda-toolkit-12-8 # here, by choosing `cuda` instead of `cuda-toolkit-12-8` it install both toolit and drivers
      ```

  + **Install GPU drivers on VMs by using installation script [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#install-script).**
    + Surprisingly, it didn't necessarily worked so well when trying to use their script. Following NVIDIA recipe is probably better but require to know more what you're doing.

  + **Install GPU drivers (Secure Boot VMs) [here](https://cloud.google.com/compute/docs/gpus/install-drivers-gpu#secure-boot)**
    + It wasn't not my use case. I don't know how secure boot VMs work with Nix... Please open an [issue](https://github.com/HugoHakem/nix-os.config/issues) if you find anything wrong!