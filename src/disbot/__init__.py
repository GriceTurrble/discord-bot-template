import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
TOKEN = os.getenv("DISCORD_TOKEN", "")
GUILD = int(os.getenv("DISCORD_GUILD", ""))  # Ensure GUILD is an integer

# Intents
intents = discord.Intents.default()
bot = commands.Bot("!", intents=intents)


# Define a simple slash command
@bot.tree.command(
    name="hello",
    description="Replies with Hello!",
    guild=discord.Object(id=GUILD),
)
async def hello(interaction: discord.Interaction):
    await interaction.response.send_message("Hello, how are you?")


# on_ready event should come after defining commands
@bot.event
async def on_ready():
    # guild = discord.Object(id=GUILD)
    print(f"Commands synced to guild {GUILD}")
    print(f"{bot.user} is ready!")


def main():
    """Run the bot"""
    bot.run(TOKEN)


if __name__ == "__main__":
    main()
