import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN", "")
DISCORD_GUILD = int(os.getenv("DISCORD_GUILD", "0"))

intents = discord.Intents.default()
bot = commands.Bot(
    command_prefix="!",
    intents=intents,
)


@bot.tree.command(
    name="hello",
    description="Replies with Hello!",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def hello(
    interaction: discord.Interaction,
):
    """Just say hello."""
    await interaction.response.send_message("Hello, how are you?")


@bot.event
async def on_ready():
    print(f"{bot.user} is ready!")


def main():
    """Run the bot."""
    bot.run(DISCORD_TOKEN)


if __name__ == "__main__":
    main()
