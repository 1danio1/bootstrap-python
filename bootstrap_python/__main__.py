import logging

from bootstrap_python.program import run
from bootstrap_python.settings import Settings

settings = Settings()

logging.basicConfig()
logging.getLogger().setLevel(settings.log_level)
logger = logging.getLogger(__name__)

run(settings)
