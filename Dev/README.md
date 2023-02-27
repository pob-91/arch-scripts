# Dev Setup #

> Set of tools and commands to set up a good dev environment.
>
> Some of these are mentioned / covered in the [README.md](/).
>
>This setup is opinionated as will not work for everyone.

* [CLI Tools](#markdown-header-cli-tools)
* [Languages & SDKs](#markdown-header-cli-tools)
* [Config](#markdown-header-config)
	* [Docker Credential Storage](#markdown-header-docker-credential-storage)
* [Scripts](#markdown-header-scripts)
* [IDEs](#markdown-header-ides)
* [VMs](#markdown-header-vms)

## CLI Tools ##

* Network Manager Open VPN tool - `sudo pacman -S networkmanager-openvpn` - adds an option to the network manager applet to create a VPN connection from a generated config file.
* jq - `sudo pacman -S jq` - bash JSON tool.
* awscli - `pip install --user awscli` - required python-pip (see below) - Amazon Web Services CLI.

## Languages & SDKS ##

* Dotnet - `sudo pacman -S dotnet-sdk aspnet-runtime`.
* Nodejs & npm - `sudo pacman -S nodejs-lts-gallium npm` - [see here for more node versions](https://wiki.archlinux.org/title/Node.js_).
* Docker - [see README](/) for docker install instructions.
* Python 3.9 - `yay -S python39` - example of getting other python versions.
* pip - `sudo pacman -S python-pip` - install python 3.10 packages (see next point on python versions).
* Python 3.10 - currently arch ships with python 3.10 installed. If this changes you will be able to use yay to get it.
* Java (we're going with 17 which is the latest LTS at the time of writing) - `sudo pacman -S jdk17-openjdk maven` - maven is the package manager for java.


## Config ##

* bashrc - the `arch-scripts/Xorg/.bashrc` file has a load of useful aliases e.t.c and exports the required `DOCKER_HOST` (assuming your user id is 1000 which it normally is) .
* git - setup git by running `git config --global user.name NAME` - `git config --global user.email EMAIL` - `git config --global credential.helper libsecret` - this requires libsecret which is installed as part of the default set of packages in the [README](/) - `git config --global diff.tool meld` - `git config --global merge.tool meld` - this sets up meld to be the diff tool, you will need the meld executable installed via pacman.
* Max Number of File Watchers - `sudo vim /etc/sysctl.conf` - add the line `fs.inotify.max_user_watches = 524288` - run `sudo sysctl -p --system` - this increases the number of file watches and is required for IDEs editing large projects.

### Docker Credential Storage ###

This enables you to log in to docker image hubs and push images and store the credentials securely. It requires `pass` and a keyring program e.g. `seahorse` as per the [README](/README.md).

Run `gpg --full-generate-key` and run through the prompts selecting the default settings and then entering the email, name e.t.c.

`cd` into the `~/bin` directory. If you are using the `.bashrc` in the `arch-scripts/Xorg` directory then this folder will already be in your path. If it is not then add it.

Get docker credential helper (at time of writing is 0.6.4 but check the latest version on git) - `wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.4/docker-credential-pass-v0.6.4-amd64.tar.gz`.

Unzip it - `tar xvzf docker-credential-pass-v0.6.4-amd64.tar.gz` and remove the zip file `rm docker-credential-pass-v0.6.4-amd64.tar.gz` and make the extract executable `chmod a+x docker-credential-pass`.

Get the name of the key you created `gpg --list-secret-keys` and copy the uuid.

Init pass with the key uuid: `pass init UUID`.

Run `pass insert docker-credential-helpers/docker-pass-initialized-check`.

Finally copy the `arch-scripts/.docker/config.json` into `$HOME/.docker/config.json`.

## Scripts ##

* `openvpn-ubuntu-install.sh` in this folder is a utility script that can be run on an ubuntu server to setup ovpenvpn. It results in an `ovpn` file saved to `/root/NAME.ovpn`. Copy it into the home directory and `chown` it to belong to the current user `chown ubuntu NAME.ovpn`. Then `scp` it onto your client computer and use the network manager tool to create a connection. You will then be `VPN`ed into that machine and all requests e.t.c will be routed through it.

## IDEs ##

My personal favourites are the [JetBrains IDEs](https://www.jetbrains.com/). Instructions on how to install these on Arch are in the [README](/). 

The upside to Arch is that these are available as pre build binaries in the chaotic-aur. On other systems (debian, fedora) JetBrains suggests to install using Snap.

## VMs ##

Personal favourite VM if requires is virtual box. To install do the following:

Install the package `sudo pacman -S virtualbox virtualbox-guest-iso`.

Add any users you want to be able to use virtual box to the `vboxusers` group: 

```
sudo usermod -aG vboxusers USERNAME
```

Load the virtual box kernel module:

```
sudo modprobe vboxdrv
```

Install the extension package:

```
yay -S virtualbox-ext-oracle
```

Enable the vbox web service:

```
sudo systemctl enable vboxweb.service
sudo systemctl start vboxweb.service
```

If all done correctly the output from `lsmod | grep -i vbox` should be some virtual box kernel modules.

There is another VM called [VirtManager](https://wiki.archlinux.org/title/Virt-Manager) and it is supposed to be more efficient, however, for testing OSes and user friendliness VirtualBox is better in my opinion.