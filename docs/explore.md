# Exploring your bot

## Startup

Start the bot using either `uv run disbot` (or the Justfile alias `just up`):

```sh
$ uv run disbot
2024-12-30 16:31:26 WARNING  discord.ext.commands.bot Privileged message content intent is missing, commands may not work as expected.
2024-12-30 16:31:26 INFO     discord.client logging in using static token
2024-12-30 16:31:27 INFO     discord.gateway Shard ID None has connected to Gateway (Session ID: ...).
my-bot#1234 is ready!
```

You should now be able to use the initial `/hello` command on your server, and get back a friendly response:

![The test bot responding to /hello command](imgs/example-disbot-hello.png)

## How, um... how does it work?

Let's look at the source in detail, which is fairly small.

In fact, here's the whole thing (or, at least, what _was_ in `src/disbot/__init__.py` originally):

<!--
    This section uses the Snippets extension.

    For details on this syntax, see:
    https://facelessuser.github.io/pymdown-extensions/extensions/snippets/#snippets-notation
-->

```py
--8<-- "docs/_original_src/full.py"
```

Let's look at this source in parts.

### Environment variables

Let's explore how environment variables are handled:

```py
import os
...
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_TOKEN", "")

```

This uses the [`python-dotenv`](https://pypi.org/project/python-dotenv/) package. The function `load_dotenv()` automatically reads our `.env` file, populating environment variables with its contents.

If you followed the [setup instructions](index.md), you may have a `.env` file with the following in it:

```sh
# .env
DISCORD_TOKEN=superSecretTokenValue12345
```

When `load_dotenv` is called, the environment variable `DISCORD_TOKEN` is populated with the string value `"superSecretTokenValue12345"`. We can then read the value of this variable using [`os.getenv()`](https://docs.python.org/3/library/os.html#os.getenv):

```py
TOKEN = os.getenv("DISCORD_TOKEN", "")  #(1)
# "superSecretTokenValue12345"
```

1.  The second argument is the _default value_ in case the environment variable is missing.

_To be continued_
