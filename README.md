# nix-config

macOS setup with nix-darwin, Home Manager and nix-homebrew. The repo lives at `~/.config/nix-config`.

| File | What it's for |
|---|---|
| `flake.nix` | Inputs and username |
| `system.nix` | Nix settings, macOS defaults, Homebrew and Home Manager setup |
| `apps.nix` | Every installed app (casks, packages, programs) |
| `home.nix` | Git config, links the files in `config/` into place |
| `config/` | App configs (Hammerspoon, Karabiner) |
| `tap/Casks/` | Custom Homebrew casks (Rex) |

## Requirements

- **Apple Silicon Mac.** The config is built for `aarch64-darwin`, so it won't work on Intel Macs.
- **macOS 15 (Sequoia) or newer.** Rex needs it.
- **macOS account name must be `rohan`.** That's the short name, with a home folder at `/Users/rohan`. To use a different account, change `username` in `flake.nix`.
## Fresh machine

1. **Install Nix** with flakes turned on:
   ```sh
   curl -sSfL https://channels.nixos.org/nix-latest/nix-installer | sh -s -- install --enable-flakes
   ```
   Open a new terminal afterwards.

2. **Clone this repo** to `~/.config/nix-config`:
   ```sh
   nix run nixpkgs#git -- clone https://github.com/rdave8/nix-config.git ~/.config/nix-config
   ```

3. **Install nix-darwin and apply the config:**
   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix-config#macbook
   ```

## Day to day

**Apply changes:**
```sh
sudo darwin-rebuild switch --flake ~/.config/nix-config#macbook
```
Run `git add` on new files before switching. Flakes only see files git tracks.

After changing a file in `config/`, reload Hammerspoon from its menu bar icon. Karabiner reads `config/karabiner/` directly and picks up changes on its own (changes made in its settings UI land there too, so commit them).

**Add an app** in `apps.nix`. Use the first option that exists:
1. A Home Manager module: `programs.<name>.enable = true;`
2. A nixpkgs package: add it to `home.packages`
3. A Homebrew cask: add it to `homebrew.casks`
4. Not available anywhere: add a cask file to `tap/Casks/<name>.rb` and list it as `"rohan/local/<name>"`

**Remove an app** by deleting it from `apps.nix` and switching. Casks are zapped, which also deletes the app's data. Never `brew install` anything by hand. The next switch removes anything that isn't listed.

**Update everything**, then commit `flake.lock`:
```sh
nix flake update --flake ~/.config/nix-config
sudo darwin-rebuild switch --flake ~/.config/nix-config#macbook
```

**Undo the last switch:**
```sh
sudo darwin-rebuild --rollback
```
