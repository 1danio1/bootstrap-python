import logging

from bootstrap_python.settings import Settings

logger = logging.getLogger(__name__)


def run(settings: Settings) -> None:
    print("Hello world")
