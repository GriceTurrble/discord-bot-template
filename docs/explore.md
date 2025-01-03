# Anatomy of a Discord Bot

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

To answer that, let's look at the source code for this bot, which isn't much.

In fact, here's the whole thing
(at least, the original `src/disbot/__init__.py` from this template):

```py
import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN", "")
DISCORD_GUILD = int(os.getenv("DISCORD_GUILD", "0"))

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)


@bot.event
async def on_ready():
    print(f"Logged in as {bot.user} (ID: {bot.user.id})")


@bot.tree.command(
    description="Replies to /hello",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def hello(interaction: discord.Interaction):
    """Just say hello."""
    print("Responding to /hello")
    await interaction.response.send_message("Hello, how's it going?")


@bot.command(description="Replies to !whatsup")
async def whatsup(ctx):
    """Just say hello."""
    print("Responding to !whatsup")
    await ctx.send("Nothing much")


def main():
    """Run the bot."""
    bot.run(DISCORD_TOKEN)
    print("Shutting down.")


if __name__ == "__main__":
    main()
```

The source code may seem complex,
especially for newcomers to Discord bots, Python, or programming in general.
Let's look at each part the above code in more detail, one piece at a time.

### Environment variable handling

Per the [Twelve-Factor App method](https://12factor.net/),
we prefer to [store config in the environment](https://12factor.net/config).
This means all parts of the _configuration_ of the app -
including any secrets like our Discord app token and which server/guild to connect to -
should be separate from the _code_ of that app.
This reduces the possibility of accidentally committing a token to a public repo,
as well as making it easier to start the app with a different configuration
without needing to make changes to the actual code of the app.

Now, remember our `.env` file created during the [bootstrap step](index.md#bootstrap-environment) in setup?
It may look something like this:

```sh
DISCORD_TOKEN=superSecretTokenValue12345 #(1)
DISCORD_GUILD=678910
```

1. If this is your real token value, please contact Discord support and tell them something is very, very wrong.

Now have a look at this section of our code:

```py
from dotenv import load_dotenv

load_dotenv()

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN", "") #(1)
DISCORD_GUILD = int(os.getenv("DISCORD_GUILD", "0"))
```

1. This second argument is a default value, returned if the environment variable is not present at all.
   You can read this as "return the value of `DISCORD_TOKEN` if it is present, otherwise return an empty string".

   If this default were missing, it would return `None`.
   It may still be useful to use `None` in some contexts, of course.

   Or, maybe you want the whole program to crash if the environment variable is missing
   (yes, sometimes that's a good thing!).
   In which case, consider simply calling `os.environ["KEY"]`, which will throw an exception
   if that environment variable is missing.

The `load_dotenv()` function
(from the [`python-dotenv`](https://pypi.org/project/python-dotenv/) package)
reads the contents of that `.env` file.
Each line is parsed into an [environment variable](https://en.wikipedia.org/wiki/Environment_variable)
in the form `name=value`.

Next, [`os.getenv()`](https://docs.python.org/3/library/os.html#os.getenv)
can be used to pull a given value from the environment.
In our case, we want to grab our `DISCORD_TOKEN` and our `DISCORD_GUILD` values,
storing these in variables

!!! info "One option out of many"
`load_dotenv()` is not required for `os.getenv()` to function;
the former is simply a helper method for loading the `.env` file's contents.
You could just as easily set these environment variables in other ways,
such as on the command line when running the program:

    ```sh
    # Set an environment variable inline when starting the program:
    DISCORD_GUILD=678910 uv run disbot

    # Setting a variable ahead of time with `export`:
    export DISCORD_GUILD=678910
    uv run disbot
    ```

    Explore your use case and decide how you want these values set in your own environment.

### Defining the bot

Next we come to this bit of code, which creates our `bot` object:

```py
# Recall where these imports came from:
import discord
from discord.ext import commands

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)
```

#### Intents

The `intents` parameter is used to define
[Gateway Intents](https://discordpy.readthedocs.io/en/stable/intents.html)
for our bot.
These allow a bot to subscribe to specific events and ignore others.

The [default intents](https://discordpy.readthedocs.io/en/stable/api.html#discord.Intents.default)
provide most of the events you need, but not those considered "privileged",
such as presence and message content.
This is why we are explicitly setting `intents.message_content = True` above,
so that the bot is able to read the contents of a message in order to know
whether it should respond to a command from one.

!!! note

    You must *also* set the Message Content intent within the
    [Discord Developer portal]
    As shown in the [permissions setup](index.md#setup-intents-and-permissions),

#### Command prefix

The
[`command_prefix`](https://discordpy.readthedocs.io/en/stable/ext/commands/api.html#discord.ext.commands.Bot.command_prefix),
as the name implies, is the prefix expected for commands assigned to this bot.
For instance, if we have a command called `foo` with a prefix of `!`,
the bot will respond when `!foo` is at the start a user's message.

### Adding a slash command

Now let's get to the good part: an actual command!

```py
@bot.tree.command(
    description="Replies to /hello",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def hello(interaction: discord.Interaction):
    """Just say hello."""
    print("Responding to /hello")
    await interaction.response.send_message("Hello, how's it going?")
```

Most simple commands can take this form,
where a [coroutine](https://realpython.com/async-io-python/)
is defined to handle the logic of our command,
decorated by a helper function to register it with the bot
and give it some useful metadata.

In this case, we are adding a command to the bot's
[command tree](https://discordpy.readthedocs.io/en/stable/interactions/api.html#discord.app_commands.CommandTree)
(found at the attribute `bot.tree`)
by using its
[`@command` decorator](https://discordpy.readthedocs.io/en/stable/interactions/api.html#discord.app_commands.CommandTree.command).
We give the command a `name`, which is the name used to invoke it in a Discord chat channel;
a helpful `description` to describe that command;
and, optionally, a `guild` (server) to add this command to.

The command coroutine (the `async def` function we define) takes an
[`Interaction`](https://discordpy.readthedocs.io/en/stable/interactions/api.html#discord.Interaction)
object,
which gives us access to information about the message that sent this command to our bot
(its author, the channel it was sent in, the guild that channel belongs to, and so on).

We use this interaction to create a `response`
(which is of type
[`InteractionResponse`](https://discordpy.readthedocs.io/en/stable/interactions/api.html#discord.InteractionResponse))
back to the user who sent this command, using the
[`send_message`](https://discordpy.readthedocs.io/en/stable/interactions/api.html#discord.InteractionResponse.send_message)
method to send a simple text message back.

That's a lengthy explanation for a pretty simple interaction ("it responds 'Hello, how's it going?'"),
but those details open the door to many possibilities:

- responding with a message that can contain one or more
  [embeds](https://discordpy.readthedocs.io/en/stable/api.html#discord.Embed),
  [files](https://discordpy.readthedocs.io/en/stable/api.html#discord.File),
  or even a [poll](https://discordpy.readthedocs.io/en/stable/api.html#discord.Poll).
- editing a previous message that was sent
- adding a reaction to a post
- checking the roles of a user to see if they are permitted to use this command

Using the `.response` attribute of the interaction is not even required.
I invite you to explore the `Interaction` object and its associated attributes in more detail
to discover what you might want to do with your bot command.

### Adding a non-slash command

TBD, and need to update the code to match

### Events

TBD

### Starting the bot

TBD
