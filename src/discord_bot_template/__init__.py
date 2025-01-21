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
    """Let us know we logged in properly."""
    print(f"Logged in as {bot.user} (ID: {bot.user.id})")


@bot.tree.command(
    description="Replies with Hello!",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def hello(interaction: discord.Interaction):
    """Just say hello."""
    print("Responding to /hello")
    await interaction.response.send_message("Hello, how are you?")


@bot.command(
    description="Replies to !whatsup",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def whatsup(ctx):
    """Tell us what's up."""
    print("Responding to !whatsup")
    await ctx.send("Nothing much")


@bot.command(
    description="Sync the bot tree to update Slash command changes to the server",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def sync(ctx):
    """Sync the bot command tree for Slash commands."""
    print("Syncing the command tree...")
    await bot.tree.sync(guild=discord.Object(id=DISCORD_GUILD))
    await ctx.reply("✅ Command tree synced")
    print("Sync Complete!")


def main():
    """Run the bot."""
    bot.run(DISCORD_TOKEN)
    print("Shutting down.")


if __name__ == "__main__":
    main()
