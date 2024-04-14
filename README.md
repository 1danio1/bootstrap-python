```
poetry install
ls -s $(poetry env info --path) .venv
pre-commit install
pre-commit run --all-files
pre-commit autoupdate

poetry run python bootstrap_python
```

TODO describe what needs to be changed

TODO validate devcontainer starts correctly from scratch

TODO validate everything works correctly (devcontainer build, python tools)
