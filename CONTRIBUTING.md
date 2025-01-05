# Contributing to this project

To get started, clone this repo locally,
then follow the setup instructions in the [README](README.md),
up to and including `just bootstrap`.
This should get you set up with all the tools you need.

## Code quality

`pre-commit` takes care of most code quality concerns automatically.
Passing pre-commit hooks is (or should be) a required check in the [CI suite](.github/workflows/ci.yaml),
so it will make your life easier to enable them locally and catch errors early.

To run pre-commit hooks manually, use
[`pre-commit run`](https://pre-commit.com/#pre-commit-run)
with appropriate options.

> [!note]
> For convenience, you can run hooks on all project files by calling `just lint`.
>
> An optional `hook_id` can be used to run a specific hook:
>
> ```shell
> just lint ruff
> # pre-commit run ruff --all-files
> ```

## Testing

This project currently has no tests to run, but they can be added easily

1. Use `uv add --dev pytest pytest-cov` to add these tools to dev dependencies.
2. Uncomment appropriate configurations in [pyproject.toml](pyproject.toml) and [Justfile](Justfile)
   to make setup smoother.

## Documentation

The documentation site is built using [Material for MkDocs].
Dependencies to build the site locally are included in the `docs` optional dependencies.
A simple `uv sync` command will _not_ install these dependencies automatically
(in fact, it will actually **uninstall** them!).

To ensure these dependencies are installed,
use one of the following:

```sh
# All dependency groups are installed by 'just bootstrap' by default:
just bootstrap
# which includes: `uv sync --all-groups`

# The 'docs' group can also be installed manually:
uv sync --group docs
```

You may then run the development server for `mkdocs` using `just docs-serve`:

```sh
just docs-serve
# the same as: `uv run mkdocs serve`
```

Any changes made to the contents of the [`docs/` directory](docs)
or to the [`mkdocs.yml`](mkdocs.yml) config
will cause the site to reload in your browser automatically.

Refer to the [Material for MkDocs] documentation for more details
on using this framework for writing new documentation.

### Building docs for production

Though usually not necessary,
you can also build the production version of the docs site
to the `site/` directory (by default),
using `just docs-build`:

```sh
just docs-build
# the same as: `uv run mkdocs build -d site`
```

> [!note]
> The production version is built and uploaded to GitHub Pages
> as part of the [release workflow](.github/workflows/release.yaml).

[material for mkdocs]: https://squidfunk.github.io/mkdocs-material/
