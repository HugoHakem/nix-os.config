# Installation Tutorial for Google Cloud Platform Virtual Machine

## Table of Content

- [Installation Tutorial for Google Cloud Platform Virtual Machine](#installation-tutorial-for-google-cloud-platform-virtual-machine)
  - [Table of Content](#table-of-content)
  - [Contextualization](#contextualization)
  - [Installation Guidelines](#installation-guidelines)
    - [0 Pre-Requisite](#0-pre-requisite)
    - [1 Connect to the virtual machine](#1-connect-to-the-virtual-machine)
    - [2 Install Nix Package Manager](#2-install-nix-package-manager)
    - [3 Pull the configuration file](#3-pull-the-configuration-file)
    - [4 Apply your credentials](#4-apply-your-credentials)
    - [5 Apply your environment](#5-apply-your-environment)
  - [Workflow](#workflow)
    - [Add new system packages](#add-new-system-packages)
    - [For maintenance purposes](#for-maintenance-purposes)
    - [Use template](#use-template)
    - [Connect to the VM with vscode](#connect-to-the-vm-with-vscode)
      - [Code tunnel](#code-tunnel)
      - [Remote SSH](#remote-ssh)

## Contextualization

When setting up a virtual machine building an adequate developer environment might be difficult or fail for obscure reasons. This repo make use of **Nix Package Manager** as a work around.

This guide assumes the following [Pre-Requisites](#0-pre-requisite) which is simply having a virtual machine running. This tutorial will take the example of the Google Cloud Virtual Machine, but it *supposedly* (please open an issue if you encounter any problems) works on any Linux machine.

Afterward, here is what you will do:

1. [Connect to the virtual machine.](#1-connect-to-the-virtual-machine)
2. [Install Nix Package Manager](#2-install-nix-package-manager)
3. [Pull the configuration file](#3-pull-the-configuration-file)
4. [Apply your credentials](#4-apply-your-credentials)
5. [Apply your environment](#5-apply-your-environment)

Once it is finished, you should have a working environment with any basic utilities you may need.

To jump to how to use this config and add project templates, go to [workflow](#workflow).

## Installation Guidelines

### 0 Pre-Requisite

This tutorial assume:

- A gcp virtual machine has already been set up.
- A GPU is available, but the drivers are not necessarily pre-installed from GCP.
- The disk is already configured.
- The server is running on Ubuntu 22.04 with architecture x86/64.

### 1 Connect to the virtual machine

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
```

Note that you can configure your `gcloud config` such that you don't have to enter the `project` and the `zone` every time. See the [`gcloud config set` Documentation](https://cloud.google.com/sdk/gcloud/reference/config/set)

### 2 Install Nix Package Manager

Here we do not seek to switch completely from Linux to NixOS. So we solely install Nix as a package manager, particularly to specify our user configuration with home-manager. A good tutorial about home-manager and the installation step can be found [here](https://github.com/Evertras/simple-homemanager/blob/main/01-install.md). But if are interesting in just making your server running, please keep going.

Run this following command to install nix as a package manager in a multi-user settings (ref to [NixOS documentation](https://nixos.org/download/#nix-install-linux)):

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Then you must add some extra functionality manually in you nix config at `/etc/nix/nix.conf`. In particular, you should:

- enable the **experimental-features** `nix-command` and `flakes`:
  - `nix-command` provides some convenient CLI for nix.
  - `flakes` specify that we can work with `flake.nix` file where the core of your environment is specified.

- provide `root` and your username (that is the result of the `whoami` bash command) as **trusted users**.
  - This allow the user to have their own `~/.config/nix/nix.conf`. Hence this nix configuration will prevail and you won't have to manually modify nix config anymore as long as it is declared in your `flake.nix`.

To do so, please do:

```bash
sudo nano /etc/nix/nix.conf
```

And add:

```bash
experimental-features = nix-command flakes
trusted-users = root hhakem
```

Save your modification and close the file. Note that `sudo` was required because by default, on your GCP machine you can only install things at the user level, hence not as root. You then need super user access to modify things at the root level.

### 3 Pull the configuration file

Now that nix package manager is available, you will pull the configuration file from this repo. Nix is also convenient for that and allows to run flake that are hosted on git repos. Here you will run the `#installation` command that I have specified in [`apps/x86_64-linux/install`](./apps/x86_64-linux/install) as a shell script. It is made available as a nix app with the `mkApp` function in the [`flake.nix`](./flake.nix).

Run the following:

```bash
nix --extra-experimental-features 'nix-command flakes' run github:HugoHakem/nix-os.config?ref=main#install
```

Few things will occur here:

```sh
cleanup             # remove any folder named: "nix-os.config-main.zip" or "nix-os.config-main"
check_installer     # verify `nix` is available
download_config     # download the repo as a zip file and unzip it using both `curl` and `unzip`. 
                    # no need to install it before hand! If you don't have it, I did it for you with `nix shell`
                
cleanup             # again remove the installation folder that we don't need anymore.
                    # the main config has been renamed under `nixos-config/`
check_nvidia        # check if NVIDIA drivers are installed
prompt_reboot       # ask you whether you want to reboot your machine (recommended if NVIDIA drivers are installed)
```

When checking for the NVIDIA drivers, the installer will check if `nvidia-smi` is running as it should. If it doesn't you will be prompt whether you want to install them through the installer. Please see this note on [nvidia drivers installation](./apps/x86_64-linux/nvidia-drivers-installation.md) to have a detailed explanation of what is happening here. If you rather prefer not doing it, because your machine just doesn't have any GPU, or because you rather prefer doing it yourself just answer `no`.

### 4 Apply your credentials

Then **before actually applying your environment configuration**, you need to define your credentials. In particular, you will be defining:

- `GIT_NAME`
  - This doesn't have to be the same as your github repo. It will be the name used to sign your commits.
- `GIT_EMAIL`
  - This is the one associated to your github account.

Also, `user` will be pulled from `whoami`.

Run the following command:

1. Go into the nixos-config directory:

    ```bash
    cd nixos-config/
    ```

2. Run the apply function (which, if you are curious is a bash script detailed [`apps/x86_64-linux/apply`](./apps/x86_64-linux/apply)):

    ```bash
    nix run .#apply
    ```

This will override the following lines in the [flake.nix](./flake.nix):

```nix
user = "hhakem";
git_name = "Hugo";
git_email = "hhakem@broadinstitute.org";
```

If your `git` is already configured, it will pull those information. If your not satisfied with this behavior, then you must changes those lines manually. You won't be able to change it from git CLI (because this is how nix is, immutable (*except when you specify not to*) for perfect reproducibility).

### 5 Apply your environment

You are now ready to apply your environment configuration. Run this command (while still being in the `nixos-config/` folder):

```bash
nix run .#build-switch
```

Again if you are curious, the `build-switch` app is defined [apps/x86_64-linux/build-switch](./apps/x86_64-linux/build-switch).

## Workflow

### Add new system packages

- The standard way to add new packages will be by updating the `modules/shared/packages.nix`(modules/shared/packages.nix). Please visit [modules/shared/README.md](./modules/shared/README.md) for more details. You will find explanations and example on how to add new **packages**, how to create **files** directly (case that won't happen so often), or how to configure **programs**.

- Additionally you may think the package you want to install is linux specific. This config is indeed intended to be both MacOS and Linux compatible. In that case, you will rather modify the [modules/linux/](./modules/linux/README.md) config

- If a nix packages, for some reason doesn't work. Patches will be applied in the [overlay directory](./overlays/README.md). Other use case for `overlays` could be to override certain attributes of packages. An example of such needs can be when on MacOS, you update your MacOS version. Packages might break as of the update and require patches.

Additionnally, know that this the [hosts/linux.nix](./hosts/README.md) exists but on a day to day basis, you won't modify this file.

Finally every time you have done changes to your config, run the following command to actually apply those changes to your system:

```bash
nix run .#build-switch
```

There are some utilities to rollback to a previous version, that can be run with:

```bash
nix run .#rollback
```

You will be prompt which generation to rollback to. It might be useful to retrieve a working system. But it wont give you back your `nixos-config` files. This is why it is advice to init a github repository with your `nixos-config/` folder.

### For maintenance purposes

When doing multiple builds or heavily changing your configuration. It might happen that some packages are still present in your `/nix/store` or that previous version of your [`home-manager`](https://github.com/nix-community/home-manager) configuration are still saved in case you wanted to roll back to them. It is then wise, from time to time to trigger the following command.

```bash
nix-collect-garbage -d
```

Then in your `nixos-config/` folder you will run:

```bash
nix run .#build-switch
```

Sometimes, whenever you want to install a package with a certain version, you may want to try it first this way:

```bash
nix shell nixpkgs#[name-of-the-package]
```

If you want a certain version of that package and you can make it happen through the `nix shell` command but not by using this config, it might be because the `flake.lock` refer to previous versions of your `flake.nix` `inputs`. In that case you may want to try:

```bash
nix flake update 
# optionally you can specify the input you want to update
```

Please refer to the documentation on [`nix flake update`](https://nix.dev/manual/nix/2.25/command-ref/new-cli/nix3-flake-update). Be aware that by updating your input, things might break because options are no longer supported, or syntax has changed etc. Do not use if you don't need it. I advice you init a git repo of your `nixos-config/` so you can revert the lock changes anytime.

### Use template

The goal of setting up your environment is ultimately to do coding projects. In the [templates/](./templates/README.md) folder, you will find a first template for Machine Learning Project on Python.

### Connect to the VM with vscode

Connecting to the Virtual Machine through VSCode can be done with two ways:

- Code Tunnel is great and require minimal set up. But every time you are turning off the VM, you'll have to re do the connecting steps.
- Remote SSH is the best if you want a one off set-up, and is actually not so difficult to put in place.

#### Code tunnel

This requires a github or a microsoft account.

- Connect to the Virtual Machine:
  
  ```bash
  gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
  ```

- Create a background process with your preferred method `tmux` or `screen`. I personally name it vscode:
  - See [tmux cheat sheet](https://tmuxcheatsheet.com/)

    ```bash
    tmux new vscode
    ```

  - See [screen cheat sheet](https://gist.github.com/jctosta/af918e1618682638aa82)

    ```bash
    screen -S vscode
    ```

- Launch the code tunnel:

  ```bash
  code tunnel
  ```

  Follow the instruction from there, you might have to go onto a web link, connect to your github / ms account and put some authentication code.

- Exit the process (*without killing it*)
  - tmux: `<Ctrl + b>` `d`
  - screen: `<Ctrl + a>` `d`

- You are now ready to connect with vscode:
  - Open the command panel by doing `<Cmd + shift + p>`
  - Enter : `Remote-Tunnels: Connect to Tunnel...`
  - You can now use your GitHub or Microsoft account to do so.

#### Remote SSH

This tutorial is inspired from this [blog post](https://medium.com/@albert.brand/remote-to-a-vm-over-an-iap-tunnel-with-vscode-f9fb54676153)

I will present both the *standard way* to add a new Host in your SSH config and *my preferred way*. I recommend following the *standard way* first and *my preferred way* if you are doing this for the first time. Otherwise jump to the [my preferred way](#my-preferred-way)

**Standard way**:

When connecting to the VM, you usually run:

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap
```

If instead you add the `--dry-run` flag, this will return you the actual `ssh` command which will eventually look like this (*I anonymized / simplified the output by putting some variable in angle brackets <...>*):

```bash
/usr/bin/ssh -t -i ~/.ssh/google_compute_engine -o CheckHostIP=no -o HashKnownHosts=no -o HostKeyAlias=compute.<VM_ID> -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=~/.ssh/google_compute_known_hosts -o "ProxyCommand <PYTHON-BIN> -S -W ignore <GCLOUD.py> compute start-iap-tunnel '<VM_NAME>' '%p' --listen-on-stdin --project=<PROJECT_NAME> --zone=<ZONE> --verbosity=warning" -o ProxyUseFdpass=no <USER>@compute.<VM_ID>
```

This kind of ssh command can be added in your vscode so that it recognized your machine via the SSH protocol. The thing is that this ssh command is not format properly so that vscode accept it:

- `/usr/bin/ssh` must be instead `ssh`
- `"ProxyCommand ..."` must be instead `ProxyCommand="..."

This is what this command do:

```bash
gcloud compute ssh ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --tunnel-through-iap --dry-run | \
sed 's/-o "ProxyCommand \([^"]*\)"/-o ProxyCommand="\1"/' | \
sed 's/\/usr\/bin\/ssh/ssh/'
```

You can now copy the output and do the following on vscode:

- Open the command panel by doing `<Cmd + shift + p>`
- Enter : `Remote-SSH: Add New SSH Host...`
- Past the output that you copied.

This will generate an output with this looking in you `~/.ssh/config` file:

```text
Host compute.<VM_ID>
  HostName compute.<VM_ID>
  IdentityFile ~/.ssh/google_compute_engine
  CheckHostIP no
  HashKnownHosts no
  HostKeyAlias compute.<VM_ID>
  IdentitiesOnly yes
  StrictHostKeyChecking yes
  UserKnownHostsFile ~/.ssh/google_compute_known_hosts
  ProxyCommand <PYTHON-BIN> -S -W ignore <GCLOUD.py> compute start-iap-tunnel '<VM_NAME>' '%p' --listen-on-stdin --project=<PROJECT_NAME> --zone=<ZONE> --verbosity=warning
  ProxyUseFdpass no
  User <USER>
```

You are now good to go and you can connect to your machine with ssh with vscode: <a id="ssh-connect"></a>

- Open the command panel by doing `<Cmd + shift + p>`
- Enter : `Remote-SSH: Connect to Host...`
- Select the Host variable of your VM so here: `compute.<VM_ID>`

Additionally, now you don't have to run the traditional `gcloud compute ssh ...` command anymore. You can simply do:

```bash
ssh <USER>@compute.<VM_ID>
```

**Preferred way** <a id="my-preferred-way"></a>:

The previous method is perfectly fine, but there is one underlying problem when using the `google-cloud-sdk` provided by `nix`. This is that the `<PYTHON-BIN>` and the `<GCLOUD.py>` will look to something like this:

```text
<PYTHON-BIN> : /nix/store/90myxg4ckim260mw8mv741b4knykzx50-python3-3.12.9-env/bin/python
<GCLOUD.py> : /nix/store/h618r2jp07djzgsh7ymbpgy6vy1yvwcl-google-cloud-sdk-515.0.0/google-cloud-sdk/lib/gcloud.py
```

What about it?

Well if you hardcode in your SSH config those Path under the ProxyCommand, there is high chance that someday, if you happen to update your `nixos-config`, that those path will change (maybe just hash, or maybe the `google-cloud-sdk` version / `python` version). And you don't want to always have to update your `~/.ssh/config` whenever you are updating your `nixos-config`. Ideally, based on the `gcloud` that we have, we should be able to retrieve where the `<PYTHON-BIN>` and `<GCLOUD.py>` installer live.

Fortunately this is specified under:

```bash
gcloud info
```

This display a long config of the gcloud and in particular we can read under:

```text
Python Location: [<PYTHON-BIN>]
...
Installation Root: [<GCLOUD_PATH>] # Note that here <GCLOUD.py> = <GCLOUD_PATH>/lib/gcloud.py
```

Hence the idea of creating a custom **SSH Host config**, where the `ProxyCommand` would point toward a certain script that would fetch the `<PYTHON-BIN>` and the `<GCLOUD_PATH>` from the `gcloud info` and then compose the actual `ProxyCommand`.

This is what the [modules/shared/config/gcp-ssh-script.sh](./modules/shared/config/gcp-ssh-script.sh) does. It is suposedly the default but you may have to make it executable: Run in your home:

```bash
chmod +x nixos-config/modules/shared/config/gcp-ssh-script.sh
```

Then here is the suggested **SSH Host config**:

```text
Host <HOST_NAME> 
  HostName compute.<VM_ID>
  IdentityFile ~/.ssh/google_compute_engine
  HostKeyAlias compute.<VM_ID>
  IdentitiesOnly yes
  StrictHostKeyChecking yes
  CheckHostIP no
  UserKnownHostsFile ~/.ssh/google_compute_known_hosts
  ProxyCommand ~/nixos-config/modules/shared/config/gcp-ssh-script.sh <VM_NAME> <PROJECT> <ZONE> %p
  User <USER>
```

> Careful: The "%p" is actually very important in the ProxyCommand and is meant to specify the Port of your local machine (usually PORT 22, [see documentation](https://www.ssh.com/academy/ssh/port#:~:text=The%20default%20SSH%20port%20is%2022.))
> You'll notice that some variable are not present when comparing the suggest SSH Host Config and the one obtained above. I simplified it, because looking at the [documentation](https://man.openbsd.org/ssh_config), some were the default.

Here you only have to specify the following flag:

- `<HOST_NAME>`, this can be whatever name you want to refer to when you want to connect to your VM.

The rest of the info can be found on the detail of the VM instance on the google cloud console.

- `<VM_ID>`
  - You can also run:
  
    ```bash
    gcloud compute instances describe ["name of the machine"] --zone ["name of the Zone"] --project ["name of the project"] --format="value(id)"
    ```

- `<VM_NAME>`
- `<PROJECT>`
- `<ZONE>`

You are now good to go and you can connect to your machine VM from vscode or using a simpler ssh command as [above](#ssh-connect).
