# Testing bot

## Contributing

### Setup

To get started, clone this repo locally.

If you use [Homebrew](https://brew.sh/), you can take advantage of our [`Brewfile`](Brewfile) to install things as a bundle:

```shell
brew bundle install
```

Otherwise, please installation instructions for each of the following tools:

- [just](https://just.systems/)
- [pre-commit](https://pre-commit.com/)
- [uv](https://docs.astral.sh/uv/)

Most other tooling uses our [`Justfile`](Justfile) recipes or standard `uv` commands.
For instance, you can bootstrap the environment by running:

```shell
just bootstrap
```

Run `just` by itself or `just help` to show help docs from the Justfile.

### Code quality

`pre-commit` takes care of most code quality concerns automatically.
Passing pre-commit hooks is a required check in CI,
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
