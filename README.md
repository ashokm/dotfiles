# ashokm does dotfiles

[![CI](https://github.com/ashokm/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/ashokm/dotfiles/actions/workflows/ci.yml)
[![MegaLinter](https://github.com/ashokm/dotfiles/actions/workflows/mega-linter.yml/badge.svg)](https://github.com/ashokm/dotfiles/actions/workflows/mega-linter.yml)

Your dotfiles are how you personalize your system. These are mine.

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and
remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own
risk!

## Install

```shell
git clone https://github.com/ashokm/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh --install
```

This will symlink the files in `~/.dotfiles/dotfiles` to your home directory. Everything is configured and tweaked
within `~/.dotfiles`.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```shell
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands
without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this (and I use `githome` and `gitwork` aliases to switch between home and work email
addresses):

```shell
# Git credentials
GIT_AUTHOR_NAME="Ashok Manji"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"

GIT_HOME_EMAIL="1902568+ashokm@users.noreply.github.com"
GIT_WORK_EMAIL="work.username@company.com"
GIT_AUTHOR_EMAIL="$GIT_HOME_EMAIL"
GIT_COMMITTER_EMAIL="$GIT_HOME_EMAIL"
git config --global user.email "$GIT_HOME_EMAIL"
```

## Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```shell
./scripts/macos.sh
```

## Optional

<details>
  <summary><b>Switch remote URL from HTTPS to SSH</b></summary>

1. List your existing remotes in order to get the name of the remote you want to change.

    ```shell
    $ git remote -v
    > origin  https://github.com/USERNAME/REPOSITORY.git (fetch)
    > origin  https://github.com/USERNAME/REPOSITORY.git (push)
    ```

2. Change your remote's URL from HTTPS to SSH with the `git remote set-url` command.

    ```shell
    $ git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
    >
    ```

3. Verify that the remote URL has changed.

    ```shell
    $ git remote -v
    # Verify new remote URL
    > origin  git@github.com:USERNAME/REPOSITORY.git (fetch)
    > origin  git@github.com:USERNAME/REPOSITORY.git (push)
    ```

:octocat: [Reference](https://docs.github.com/en/get-started/getting-started-with-git/managing-remote-repositories#switching-remote-urls-from-https-to-ssh)
</details>

## Uninstall

```shell
cd ~/.dotfiles
./bootstrap.sh --uninstall
rm -rf ~/.dotfiles
```

## Screenshots

![Screenshot of my shell prompt](screenshot.png)

## Credits

This project uses open source components. You can find the source code of their open source projects along with license
information below. We acknowledge and are grateful to these developers for their contributions to open source.

* [Mathias' dotfiles](https://github.com/mathiasbynens/dotfiles) by Mathias Bynens (MIT)
* [holman does dotfiles](https://github.com/holman/dotfiles) by Zach Holman (MIT)
