# Just tools to work on the project.
# https://just.systems/

### START COMMON ###
import? 'common.just'

# Show these help docs
[default]
help:
    @just --list --unsorted --justfile {{ source_file() }}

# Pull latest common justfile recipes to local repo
[group("commons")]
sync-commons:
    -rm common.just
    curl -H 'Cache-Control: no-cache, no-store' \
        https://raw.githubusercontent.com/griceturrble/common-project-files/main/common.just?cachebust={{ uuid() }} > common.just
### END COMMON ###

# bootstrap the dev environment
bootstrap:
    just sync-commons
    just bootstrap-commons
    -just ensure-env-file
    just sync-uv


# Sync uv dependencies in all groups
sync-uv:
    uv sync --all-groups

alias sync := sync-uv


# Run the bot
up:
    uv run thebot


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
    ! {{ path_exists(env_file) }}
    just write-template-env-file

# [over]write the .env file using a template (WARNING, YOU MAY LOSE LOCAL CREDENTIALS THIS WAY)
[confirm("Are you sure you want to overwrite the .env file (any stored credentials will be erased)? [y/N]")]
@write-template-env-file:
    -rm {{ env_file }}
    touch {{ env_file }}
    echo "{{ env_file_template }}" > {{ env_file }}
    echo "{{ GREEN }}>> Env file '{{ env_file }}' (re)generated{{ NORMAL }}"

# Want to add tests to this project?
# Consider uncommenting the commands below for some simple test command runners.

# # Run tests on Python 'version' with pytest 'args'
# [group("testing")]
# test-on version *args:
#     @echo "{{ GREEN }}>> Testing on {{ version }}...{{ NORMAL }}"
#     uv run --python {{ version }} pytest {{ args }}


# # Run tests with pytest 'args' on latest Python
# [group("testing")]
# test *args:
#     @just test-on 3.12 {{args}}
#     @just test-on 3.13 {{args}}

# Serve mkdocs site locally with auto-reloading
[group("docs")]
docs-serve:
    uv run mkdocs serve

# Build production version of mkdocs site to 'sitedir' directory
[group("docs")]
docs-build sitedir="site":
    uv run mkdocs build -d {{ sitedir }}
