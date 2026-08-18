import json
from pathlib import Path

SOURCE = Path(r"C:\Users\jvazquez\Documents\ChatGPT\CAlendario Anual\hours_enriched.json")
OUTPUT = Path(__file__).with_name("historical-data.js")

raw = json.loads(SOURCE.read_text(encoding="utf-8"))["days"]

def score(row):
    fields = ("morning_in", "morning_out", "afternoon_in", "afternoon_out", "notes", "calendar_comment", "calendar_kind")
    return sum(bool(row.get(k)) for k in fields) + (5 if row.get("actual_hours", 0) else 0)

# Algunas fechas aparecen en dos archivos mensuales. Conservamos el registro
# más completo y rellenamos cualquier campo que solo exista en el duplicado.
merged = {}
for row in raw:
    date = row.get("iso_date")
    if not date:
        continue
    if date not in merged or score(row) > score(merged[date]):
        base, other = dict(row), merged.get(date, {})
    else:
        base, other = merged[date], row
    for key, value in other.items():
        if base.get(key) in (None, "", 0, 0.0) and value not in (None, "", 0, 0.0):
            base[key] = value
    merged[date] = base

def classify(row):
    kind = (row.get("calendar_kind") or "").lower()
    comment = (row.get("calendar_comment") or "").lower()
    if row.get("reduction_days") or "reducci" in kind:
        return "reduction"
    if row.get("sick_days") or "baja" in kind:
        return "sick"
    if row.get("vacation_days") or "vacacion" in kind:
        return "vacation"
    if row.get("comp_hours") or "compensaci" in kind or "horas compensadas" in comment:
        return "comp"
    if row.get("actual_hours", 0) or row.get("worked_marker", 0):
        return "work"
    if row.get("calendar_marker", 0) and row.get("workable_marker", 0):
        return "work"
    return ""

result = {}
for date, row in sorted(merged.items()):
    notes = row.get("notes") or ""
    cal = row.get("calendar_comment") or ""
    if cal and cal not in notes:
        notes = (notes + (" · " if notes else "") + cal).strip()
    item = {
        "type": classify(row),
        "amIn": row.get("morning_in") or "",
        "amOut": row.get("morning_out") or "",
        "pmIn": row.get("afternoon_in") or "",
        "pmOut": row.get("afternoon_out") or "",
        "comment": notes,
        "hours": "",
        "imported": True,
    }
    # Las horas de compensación se consumen de la bolsa. En el resto de
    # ausencias el programa calcula la obligación diaria correspondiente.
    if item["type"] == "comp" and row.get("comp_hours"):
        item["hours"] = round(float(row["comp_hours"]), 4)
    result[date] = item

# Correcciones confirmadas durante el análisis previo.
overrides = {
    "2024-03-27": {"type": "comp", "hours": 8},
    "2024-07-25": {"type": "work"},
    "2024-07-26": {"type": "work"},
    "2024-07-30": {"type": "comp", "hours": 8},
    "2024-08-02": {"type": "comp", "hours": 8},
    "2024-03-14": {"type": "paid_leave"},
    "2024-03-15": {"type": "paid_leave"},
    "2024-07-12": {"type": "paid_leave"},
    "2025-04-01": {"type": "paid_leave"},
    "2025-04-02": {"type": "paid_leave"},
    "2025-04-03": {"type": "paid_leave"},
    "2025-04-04": {"type": "paid_leave"},
    "2025-10-15": {"type": "comp", "hours": 2.62},
    "2025-10-16": {"type": "comp", "hours": 8},
    "2025-10-17": {"type": "comp", "hours": 1.38},
    "2025-12-22": {"type": "vacation"},
    "2025-12-23": {"type": "vacation"},
    "2025-12-26": {"type": "vacation"},
    "2025-12-29": {"type": "vacation"},
    "2025-12-30": {"type": "vacation"},
    "2026-04-07": {"type": "paid_leave"},
}
for date, patch in overrides.items():
    result.setdefault(date, {"type":"", "amIn":"", "amOut":"", "pmIn":"", "pmOut":"", "comment":"", "hours":"", "imported":True})
    result[date].update(patch)

payload = json.dumps(result, ensure_ascii=False, separators=(",", ":"))
OUTPUT.write_text("window.HISTORICAL_DAYS=" + payload + ";\n", encoding="utf-8")
print(f"{len(result)} fechas exportadas a {OUTPUT}")
