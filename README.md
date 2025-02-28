# Python bootstrap repository

Everything configured in a way I like to quickly start new Python package development.

## Features
* Poetry project
  * With some useful dependencies
  * Defined linting and other dev tools settings
* Dockerfile to build small container (with .dockerignore)
* Docker compose config for using containers
* Git fix for Unix and Windows file endings
* Preconfigured devcontainer
  * Poetry installed and venv created
  * Specified safe git repository
  * Useful extensions installed: python dev tools, bookmarks, gitlens, spellcheck, csv, markdown, yaml support
* Defined recommended extensions
  * Should be the same as extensions installed with devcontainer
* Python debugger launch task configured
* Various VSCode settings configured
  * Format on Save (organize imports, insert new lines, trim trailing whitespaces)
  * Python path defaults to .venv
  * Strict pyright checks
  * Python dev tools extensions configured to read config files
  * Small dictionary for spellchecker

## Necessary changes to make a new package
* Replace this `README.md`
* `pyproject.toml`: Update `[tool.poetry]` entires
* `Dockerfile`: Update `CMD` with your package name
* Rename `bootstrap_python/` directory with your package name
* `.vscode/launch.json`: update `module` with your package name
* `.devcontainer/devcontainer.json`: update `postCreateCommand[safe directory]` with your directory name

## Environment configuration

```bash
poetry install
ln -s $(poetry env info --path) .venv
pre-commit install
pre-commit autoupdate
pre-commit run --all-files
```

## Run
```bash
poetry run python -m bootstrap_python
```

## Build Python package
```bash
poetry build
```

## Build and run
```bash
docker compose up
```
