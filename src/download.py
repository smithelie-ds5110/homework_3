from pathlib import Path
from zipfile import ZipFile
import hashlib
import requests


# Path setup
PROJECT_ROOT = Path(__file__).resolve().parent.parent
RAW_PATH = PROJECT_ROOT / "raw"
ZIP_PATH = RAW_PATH / "ml-100k.zip"
URL = "https://files.grouplens.org/datasets/movielens/ml-100k.zip"


def main():
    RAW_PATH.mkdir(parents=True, exist_ok=True)

    # Download
    if not ZIP_PATH.exists():
        print(f"Downloading MovieLens 100K data to {ZIP_PATH}")
        response = requests.get(URL, timeout=120)
        response.raise_for_status()
        ZIP_PATH.write_bytes(response.content)
        print("Download complete.")
    else:
        print(f"ZIP already exists at {ZIP_PATH}. Skipping download.")

    # Validate and extract
    with ZipFile(ZIP_PATH) as archive:
        corrupt_file = archive.testzip()

        if corrupt_file is not None:
            raise ValueError(f"ZIP integrity check failed: {corrupt_file}")

        print("ZIP integrity check succeeded.")

        archive.extractall(RAW_PATH)
        print(f"Dataset extracted to {RAW_PATH}")

    # Calculate checksum
    sha256 = hashlib.sha256(ZIP_PATH.read_bytes()).hexdigest()
    print(f"SHA256 hash is: {sha256}")


if __name__ == "__main__":
    main()

