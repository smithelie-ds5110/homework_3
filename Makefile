PYTHON ?= python3

.PHONY: all clean

# Download the data if needed, then rebuild the database from scratch.
all: raw/ml-100k/u.data
	$(PYTHON) src/load.py

raw/ml-100k/u.data:
	$(PYTHON) src/download.py

clean:
	rm -rf data output/rejected.csv
