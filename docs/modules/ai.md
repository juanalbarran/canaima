# AI

All the AI apps, one directory per app under `modules/ai/`, merged into the `ai` module. Imported by `canaima` and `mucuchies`.

- `claude-code`: [Claude Code](https://claude.com/claude-code) through Home Manager's `programs.claude-code`, with the binary from the [nix-claude-code](https://github.com/ryoppippi/nix-claude-code) flake input (official prebuilt, newer than nixpkgs). Update it with `nix flake update nix-claude-code`. `claude-cli://` links open it through `claude-code-url-handler.desktop` (the file Claude Code writes on start; the association is declared here because Home Manager owns `mimeapps.list`).

| Command  | Source                                 | Description                              |
| -------- | -------------------------------------- | ---------------------------------------- |
| `/issue` | `modules/ai/claude/_commands/issue.md` | Show a GitHub issue and start solving it |
