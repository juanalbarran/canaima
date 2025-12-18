# Quickshell module

This Quickshell module is the status bar of the laptop, it is configured to work with both Hyprland and Sway.

## How it works

It works as a service in systemctl were it will run the service quickshell

### Commands

dd
For manually start the service

```bash
systemctl --user start quickshell
```

For Troubleshooting if it doesn't show

```bash
journalctl --user -u quickshell -e
```
