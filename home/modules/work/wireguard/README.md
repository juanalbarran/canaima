# Wireguard

This application is the one `ctwo` uses for the access to their `vpn`

## To start the VPN

```bash
sudo $(which wg-quick) up ~/.config/wireguard/wg0.conf
```

## To stop the VPN

```bash
sudo $(which wg-quick) down ~/.config/wireguard/wg0.conf
```
