# Introduction

**DisBot** is a simple template for a [Discord](https://discord.com/) bot
using [discord.py](https://discordpy.readthedocs.io/en/stable/).

[Use this template :material-github:](https://github.com/new?template_name=disbot&template_owner=GriceTurrble){ .md-button .md-button--primary }

![The test bot responding to /hello command](imgs/example-disbot-hello.png)

## Getting started

Before you can run the bot, you have:

1. Install a few essential tools;
2. Grab your bot's Discord token; and
3. Invite the bot to your server.

Let's explore these in detail below:

### Install tools

To start, install necessary tooling to work on this project.

If you use [Homebrew](https://brew.sh/),
you can take advantage of the `Brewfile` available
to install the bundle of tools:

```shell
brew bundle install
```

Otherwise, please follow installation instructions for each of the following minimal tools:

- [just](https://just.systems/), a command runner similar to Make.
- [pre-commit](https://pre-commit.com/), a framework for managing pre-commit hooks (used for code quality).
- [uv](https://docs.astral.sh/uv/), a Python package and project manager.

Most other tooling uses the `Justfile` recipes or standard `uv` commands.

!!! note

    `uv` can handle Python installations for you, if you want it to.
    Otherwise, you can install **Python 3.12** yourself from [python.org](https://python.org/downloads),
    or use a version manager like [pyenv](https://github.com/pyenv/pyenv).

### Bootstrap

!!! note

    Run `just help` (or `just` by itself) to display help documentation about the commands available in the Justfile.

    For more details on Just, refer to the [Just manual](https://just.systems/man/en/).

Bootstrap your environment using `just bootstrap`.
This performs a few helpful steps, such as `pre-commit install` to get pre-commit hooks set up for you,
and `uv sync` to initialize your Python virtual environment
(you will find it as a `.venv` folder inside the project).

You'll also find a new `.env` file is added,
containing some environment variable definitions:

```sh
# Get your Discord token from the Discord dev console
# THIS IS CONFIDENTIAL! DO NOT SHARE YOUR TOKEN!
DISCORD_TOKEN=
# Copy the guild ID (aka server ID) from a target private server.
# If present, some commands become private to this guild only.
# Otherwise, all commands are globally available for all bot installs.
# DISCORD_GUILD=
```

### Discord bot token

If you don't have a Discord bot application set up in
[Discord Developer portal](https://discord.com/developers/applications) yet,
head there now and make one!

Under the **Settings > Bot** section, create or reset your token. Copy this token into the `.env` file:

```
DISCORD_TOKEN=superSecretTokenValue12345
```

!!! warning

    Discord bot tokens are confidential, and should never be shared with anyone!
    You may want to keep a copy of the token value in a password manager like (1Password or Bitwarden),
    but otherwise it should _never_ be committed to your git repo!

    The `.env` file containing that secret remain ignored (via `.gitignore`),
    and you should _only_ use the `DISCORD_TOKEN` environment variable to access it temporarily
    (be wary of any `print()` or `logging` calls that may expose it, as well!).

### Invite the bot to your server

Back in the [Discord Developer portal](https://discord.com/developers/applications),
under **Settings > Installation**, select the option for installation you want.
For testing on a private server, I recommend "Guild Install";
and under Install Link, choose "Discord Provided Link".

Save these settings, then copy the OAuth link that was created:

```
https://discord.com/oauth2/authorize?client_id=12345...
```

Paste this link into your browser, then follow Discord's authentication flow to invite the app to your server.
