from __future__ import annotations

import csv
import gzip
import io
import logging
from dataclasses import asdict, fields
from pathlib import Path
from typing import TYPE_CHECKING, TypeVar

logger = logging.getLogger(__name__)

if TYPE_CHECKING:
    from _typeshed import DataclassInstance

    T = TypeVar("T", bound=DataclassInstance)


def save_records(records: list[T], file_path: str, file_name: str, compress: bool) -> None:
    """Saves records collection as CSV file"""
    file = Path(file_path, file_name)
    if not records:
        logger.warning(f"No records to save. File path={file.as_posix()}")
        return

    logger.debug(f"Saving {len(records)} to CSV file. Path={file.as_posix()} compression={compress}")

    s = io.StringIO()
    fieldnames = [f.name for f in fields(records[0])]
    writer = csv.DictWriter(s, fieldnames)
    writer.writeheader()
    for record in records:
        writer.writerow(asdict(record))
    s.seek(0)

    file.parent.mkdir(parents=True, exist_ok=True)
    if compress:
        with gzip.open(file.as_posix(), "wt") as gzipped:
            gzipped.write(s.read())
        logger.info(f"Saved and compressed {len(records)} records. File path={file.as_posix()} compression=GZIP")
    else:
        with file.open("w") as fp:
            fp.write(s.read())
        logger.info(f"Saved {len(records)} records. File path={file.as_posix()}")
