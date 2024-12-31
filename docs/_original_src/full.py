import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_TOKEN", "")
# The Guild or Server ID to constrain this bot to.
# If not given, then the bot becomes globally active.
GUILD_ID: int | None = int(os.getenv("DISCORD_GUILD", "")) or None
MY_GUILD_ONLY = discord.Object(id=GUILD_ID) if GUILD_ID else None

intents = discord.Intents.default()
bot = commands.Bot("!", intents=intents)


@bot.tree.command(
    name="hello",
    description="Replies with Hello!",
    guild=MY_GUILD_ONLY,
)
async def hello(interaction: discord.Interaction):
    """Just say hello."""
    await interaction.response.send_message("Hello, how are you?")


@bot.event
async def on_ready():
    print(f"{bot.user} is ready!")


def main():
    """Run the bot."""
    bot.run(TOKEN)


if __name__ == "__main__":
    main()
