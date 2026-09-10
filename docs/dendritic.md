# Dendritic

The idea of this `dendritic` branch is to migrate slowly this config to the dendritic pattern.

## Directory layout

```
.
├── docs/                   reference for humans and AI agents
│   └── dendritic.md
├── modules/                features — the bulk of the config
│   ├── core/
│   ├── ui/
│   └── workspace/
├── presets/                named bundles of features
│   ├── canaima.nix
│   └── sarisarinama.nix
├── hosts/                  machines, and only what is true of one machine
├── flake.nix
└── flake.lock
```

### Presets

| Name         | User          | Description                            |
| ------------ | ------------- | -------------------------------------- |
| Canaima      | juan          | It's the preset for my personal laptop |
| Sarisarinama | juan-albarran | It's the preset for my work laptop     |

### Modules

Here are the most important modules and a brief explanation

#### Core

This is the `core` module, contains the modules that are core in nixos and nix configuration

#### UI

Contains all the modules for `ui`

#### Workspace

All the modules for work: editor, multiplexer
