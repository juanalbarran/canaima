# Dendritic

The idea of this `dendritic` branch is to migrate slowly this config to the dendritic pattern.

## Directory layout

```
.
├── docs/                   reference for humans and AI agents
│   └── dendritic.md
├── modules/                features — the bulk of the config
│   ├── ai/
│   ├── browsers/
│   ├── core/
│   ├── gaming/
│   ├── ui/
│   ├── media/
│   ├── meta/
│   └── workspace/
├── presets/                named bundles of features
│   ├── canaima.nix
│   └── mucuchies.nix
├── hosts/                  machines, and only what is true of one machine
│   └── asus/
├── users/                  users, the main one, my personal, and those related with work
│   ├── juan.nix
│   └── work/
│       └── juan-albarran.nix
├── flake.nix
└── flake.lock
```

### Presets

| Name         | User          | Description                            |
| ------------ | ------------- | -------------------------------------- |
| Canaima      | juan          | It's the preset for my personal laptop |
| Sarisarinama | juan-albarran | It's the preset for my work laptop     |

#### Canaima

Canaima will contain the configuration for my personal laptop.
The more important thing about this is that my personal laptop will run `NixOS`

#### Mucuchies

This preset will be used for all the laptops that i'll use that uses linux and dont use the `NixOS` distribution.
It contains it's own [document](./sarisarinama.md)

### Modules

Here are the most important modules and a brief explanation

- Core: [core](./modules/core.md)
- UI: [UI](./modules/ui.md)
- AI: [ai](./modules/ai.md)
- Browsers: [browsers](./modules/browsers.md)
- Gaming: [gaming](./modules/gaming.md)
- Media: [media](./modules/media.md)
- Workspace: [workspace](./modules/workspace.md)
