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
    await bot.tree.sync(guild=discord.Object(id=DISCORD_GUILD))
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
    """Tell us what's up."""
    print("Responding to !whatsup")
    await ctx.send("Nothing much")


def main():
    """Run the bot."""
    bot.run(DISCORD_TOKEN)
    print("Shutting down.")


if __name__ == "__main__":
    main()
