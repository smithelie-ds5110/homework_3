
PYTHON ?= python3

.PHONY: all clean

all: raw/ml-100k/u.data
	$(PYTHON) src/load.py
	$(PYTHON) src/run_queries.py

raw/ml-100k/u.data:
	$(PYTHON) src/download.py

clean:
	rm -rf data output
