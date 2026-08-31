# ashokm does dotfiles

[![CI](https://github.com/ashokm/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/ashokm/dotfiles/actions/workflows/ci.yml)
[![MegaLinter](https://github.com/ashokm/dotfiles/actions/workflows/mega-linter.yml/badge.svg)](https://github.com/ashokm/dotfiles/actions/workflows/mega-linter.yml)

Personal shell and system setup for macOS.

**Warning:** Fork and review before using. Remove anything you do not understand or need.

## Install

```shell
git clone https://github.com/ashokm/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh --install
```

Bootstrap will:

- symlink files from `~/.dotfiles/dotfiles` into your home directory
- create `~/.gitconfig-home` and `~/.gitconfig-work` if missing
- link shared Copilot and IntelliJ AI settings into `~/.config/github-copilot/intellij`

## Local overrides

- `~/.path` is sourced early (use it to extend `PATH`)
- `~/.extra` is sourced for machine-local aliases, functions, and secrets

Example `~/.path`:

```shell
export PATH="/usr/local/bin:$PATH"
```

## Git

Set at least `~/.gitconfig-home` before committing:

```gitconfig
[user]
    name = Your Name
    email = your-email@example.com
```

Identity model:

- default identity: `~/.gitconfig-home`
- work override: repos under `~/Workspace/work/` also load `~/.gitconfig-work`

Check active identity:

```shell
gitwho
```

Optional: switch a repo remote from HTTPS to SSH:

```shell
git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
git remote -v
```

Reference: [GitHub docs](https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories#switching-remote-urls-from-https-to-ssh)

## macOS defaults

```shell
./scripts/macos.sh
```

## Uninstall

```shell
cd ~/.dotfiles
./bootstrap.sh --uninstall
rm -rf ~/.dotfiles
```

## Credits

- [Mathias' dotfiles](https://github.com/mathiasbynens/dotfiles) by Mathias Bynens (MIT)
- [holman does dotfiles](https://github.com/holman/dotfiles) by Zach Holman (MIT)
