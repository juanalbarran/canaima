# Impala

Impala is a TUI Network manager so it is easier to configure the wifi

## NixOS systems

## Debian based systems

NOTE: It doesn't work in nix user, so im using nmtui

For make it work on Ubuntu y needed to make some changes
Ubuntu by default uses `wpa_supplicant` as NetworkManager, but Impala to work need to use `iwd`.
Because the `iwd` and the `wpa_supplicant` will fight for the wifi card i shouldn't have both running at the seame time so i had to do the following

### Install `iwd`

```bash
sudo apt update
sudo apt install iwd
```

### Configure NetworkManager to use `iwd`

1. Open the NetworkManager config file

```bash
sudo vim /etc/NetworkManager/conf.d/iwd.conf
```

2. Add the following line under the `[device]` block or create it

```toml
[device]
wifi.backend=iwd
```

### Enable and restart services

```bash
# Stop the old wpa_supplicant
sudo systemctl stop wpa_supplicant
#sudo systemctl disable wpa_supplicant

# Enable and start iwd
sudo systemctl enable --now iwd

# Restart NetworkManager so it connects to iwd
sudo systemctl stop NetworkManager
```

### Configure iwd to DHCP

Well iwd should be working by now but i can connect to the network but it can resolve any address so we need to iwd handle the network configuration (IP and DNS) automatically

1. We wedit the `iwd` configuration file

```bash
sudo vim /etc/iwd/main.conf
```

2. Now we modify the file

```toml
[General]
EnableNetworkConfiguration=true
```

3. Restart the `iwd` service

```bash
sudo systemctl restart iwd
```
