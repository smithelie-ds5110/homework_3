"""Build data/movielens.db from raw/ml-100k.

Rows the schema refuses are left out and saved to output/rejected.csv with
SQLite's error message. 
"""
import csv
import sqlite3
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "raw" / "ml-100k"
DB_PATH = ROOT / "data" / "movielens.db"
REJECTED_PATH = ROOT / "output" / "rejected.csv"
TABLES = ["occupations", "genres", "users", "movies", "movie_genres", "ratings"]

rejected = []


def lines(name, sep, encoding="utf-8"):
    """Yield (line number, fields) for each non-empty line of a raw file."""
    with open(RAW / name, encoding=encoding) as f:
        for n, line in enumerate(f, start=1):
            if line.strip():
                yield n, line.rstrip("\n").split(sep)


def iso(text):
    return datetime.strptime(text, "%d-%b-%Y").strftime("%Y-%m-%d") if text else None


def insert(con, table, row, source, n):
    """Insert one row. If the schema refuses it, log it and move on."""
    try:
        con.execute(f"INSERT INTO {table} VALUES ({','.join('?' * len(row))})", row)
    except sqlite3.Error as e:
        rejected.append((table, source, n, row, str(e)))


DB_PATH.parent.mkdir(exist_ok=True)
REJECTED_PATH.parent.mkdir(exist_ok=True)
DB_PATH.unlink(missing_ok=True)                       # rebuild from scratch

con = sqlite3.connect(DB_PATH)
con.execute("PRAGMA foreign_keys = ON")               # off by default in SQLite
con.executescript((ROOT / "sql" / "schema.sql").read_text())

for n, f in lines("u.occupation", "|"):
    insert(con, "occupations", (f[0],), "u.occupation", n)

for n, f in lines("u.genre", "|"):
    insert(con, "genres", (int(f[1]), f[0]), "u.genre", n)

for n, f in lines("u.user", "|"):
    insert(con, "users", (int(f[0]), int(f[1]), f[2], f[3], f[4]), "u.user", n)

for n, f in lines("u.item", "|", "latin-1"):
    insert(con, "movies", (int(f[0]), f[1], iso(f[2]), iso(f[3]), f[4] or None), "u.item", n)
    for genre_id, flag in enumerate(f[5:]):           # 19 flags -> one row per flag of 1
        if flag == "1":
            insert(con, "movie_genres", (int(f[0]), genre_id), "u.item", n)

for n, f in lines("u.data", "\t"):
    insert(con, "ratings", tuple(map(int, f)), "u.data", n)

con.commit()

with open(REJECTED_PATH, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["table", "source_file", "line", "row", "error"])
    writer.writerows(rejected)

for table in TABLES:
    loaded = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    bad = sum(r[0] == table for r in rejected)
    print(f"{table:<14}{loaded:>8} loaded{bad:>6} rejected")
print(f"\nDatabase: {DB_PATH}\nRejected rows saved to: {REJECTED_PATH}")
con.close()
