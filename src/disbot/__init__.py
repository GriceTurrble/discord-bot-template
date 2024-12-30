import os

import discord
from discord import app_commands
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
TOKEN = os.getenv("DISCORD_TOKEN", "")
GUILD = int(os.getenv("DISCORD_GUILD", ""))  # Ensure GUILD is an integer

# Intents
intents = discord.Intents.default()
client = discord.Client(intents=intents)

# Command tree for slash commands
tree = app_commands.CommandTree(client)


# Define a simple slash command
@tree.command(
    name="hello",
    description="Replies with Hello!",
    guild=discord.Object(id=GUILD),
)
async def hello(interaction: discord.Interaction):
    await interaction.response.send_message("Hello!")


# on_ready event should come after defining commands
@client.event
async def on_ready():
    guild = discord.Object(id=GUILD)
    await tree.sync(guild=guild)  # Sync commands to the specific guild
    print(f"Commands synced to guild {GUILD}")
    print(f"{client.user} is ready!")


def main():
    """Run the bot"""
    client.run(TOKEN)


if __name__ == "__main__":
    main()
