```
poetry install
ls -s $(poetry env info --path) .venv
pre-commit install
pre-commit run --all-files
pre-commit autoupdate

poetry run python bootstrap_python

poetry build

docker compose up
```

TODO describe what needs to be changed
