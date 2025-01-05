# Just tools to work on the project.
# https://just.systems/

# Show these help docs
help:
    @just --list --unsorted --justfile {{ source_file() }}

env_file := ".env"
env_file_template := """# Get your Discord token from the Discord dev console
# THIS IS CONFIDENTIAL! DO NOT SHARE YOUR TOKEN!
DISCORD_TOKEN=
# Copy the guild ID (aka server ID) of your server,
# then uncomment the line below.
# DISCORD_GUILD="""

# Check that a .env file is present, writing a template version if not.
[no-exit-message]
@ensure-env-file:
    # Exist if the file already exists
    ! {{path_exists(env_file)}}
    just write-template-env-file

# [over]write the .env file using a template (WARNING, YOU MAY LOSE LOCAL CREDENTIALS THIS WAY)
[confirm("Are you sure you want to overwrite the .env file (any stored credentials will be erased)? [y/N]")]
@write-template-env-file:
    rm {{env_file}}
    touch {{env_file}}
    echo "{{env_file_template}}" > {{env_file}}

# Setup dev environment
[group("setup")]
bootstrap:
    -just ensure-env-file
    pre-commit install
    uv sync --all-groups

# Run the bot
up:
    uv run thebot

# Lint all project files using 'pre-commit run <hook_id>'. By default, runs all hooks.
[group("devtools")]
lint hook_id="":
    pre-commit run {{hook_id}} --all-files


# The result should be `\\[ \\]`, but we need to escape those slashes again here to make it work:
GREP_TARGET := "\\\\[gone\\\\]"

# Prunes local branches deleted from remote.
[group("git")]
prune-dead-branches:
    @echo "{{ BG_GREEN }}>> 'Removing dead branches...{{ NORMAL }}"
    @git fetch --prune
    @git branch -v | grep "{{ GREP_TARGET }}" | awk '{print $1}' | xargs -I{} git branch -D {}

alias prune := prune-dead-branches

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

# Serve mkdocs site locally with auto-reloading
[group("docs")]
docs-serve:
    uv run mkdocs serve

# Build production version of mkdocs site to 'sitedir' directory
[group("docs")]
docs-build sitedir="site":
    uv run mkdocs build -d {{sitedir}}
