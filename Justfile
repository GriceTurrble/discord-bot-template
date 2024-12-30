# Just tools to work on the project.
# https://just.systems/

# Show these help docs
help:
    @just --list --unsorted --justfile {{ source_file() }}

env_file := ".env"
env_file_template := """# Get your Discord token from the Discord dev console
# THIS IS CONFIDENTIAL! DO NOT SHARE YOUR TOKEN!
DISCORD_TOKEN=
# Copy the guild ID (aka server ID) from a target private server below,
# then uncomment the line.
# If present, some commands become private to this guild only.
# Otherwise, all commands are globally available for all guilds the bot is installed to.
# DISCORD_GUILD="""

# Check that a .env file is present, writing a template version if not.
[no-exit-message]
@ensure_env_file:
    # Exist if the file already exists
    ! {{ path_exists(env_file) }}
    touch .env
    echo "{{ env_file_template }}" > {{env_file}}


# Setup dev environment
[group("setup")]
bootstrap: ensure_env_file
    pre-commit install
    uv sync

# Run the bot
up:
    uv run disbot

# Lint all project files using 'pre-commit run <hook_id>'. By default, runs all hooks.
[group("devtools")]
lint hook_id="":
    pre-commit run {{hook_id}} --all-files


# The result should be `\\[ \\]`, but we need to escape those slashes again here to make it work:
GREP_TARGET := "\\\\[gone\\\\]"

# Switches to `main` branch, then prunes local branches deleted from remote.
[group("git")]
prune_dead_branches:
    @echo "{{ BG_GREEN }}>> 'Removing dead branches...{{ NORMAL }}"
    @git switch main
    @git fetch --prune
    @git branch -v | grep "{{ GREP_TARGET }}" | awk '{print $1}' | xargs -I{} git branch -D {}


# Want to add tests to this project?
# Consider uncommenting the commands below for some simple test command runners.

# # Run tests on Python 'version' with pytest 'args'
# [group("testing")]
# test-on version *args:
#     @echo "{{ BG_GREEN }}>> Testing on {{version}}...{{ NORMAL }}"
#     uv run --python {{version}} pytest {{args}}


# # Run tests with pytest 'args' on latest Python
# [group("testing")]
# test *args:
#     @just test-on 3.12 {{args}}
