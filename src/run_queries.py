
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DB = ROOT / 'data' / 'movielens.db'
QUERIES = ROOT / 'sql' / 'queries'
RESULTS = ROOT / 'output' / 'queries'

RESULTS.mkdir(parents=True, exist_ok=True)

with sqlite3.connect(DB) as con:
    for query_file in sorted(QUERIES.glob('*.sql')):
        cursor = con.execute(query_file.read_text())
        rows = cursor.fetchall()

        output_file = RESULTS / f'{query_file.stem}.csv'

        import csv
        with output_file.open('w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow([column[0] for column in cursor.description])
            writer.writerows(rows)

        print(f'{query_file.name}: {len(rows)} rows')
