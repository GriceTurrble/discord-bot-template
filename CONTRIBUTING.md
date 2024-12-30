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
