import json
from pathlib import Path

ROOT = Path(__file__).parent
SOURCE = ROOT.parent / "outputs" / "01a00f62-5505-7d02-b166-f2c217013118" / "Resumen_calendario_horas_2023_2026.xlsx.inspect.ndjson"

monthly = None
for line in SOURCE.read_text(encoding="utf-8").splitlines():
    row = json.loads(line)
    if row.get("kind") == "table" and row.get("sheet") == "Resumen mensual":
        monthly = row["values"]
        break
if monthly is None:
    raise RuntimeError("No se encontró el resumen mensual validado")

headers = monthly[3]
records = []
for values in monthly[4:]:
    if not values or not values[0]:
        continue
    records.append({
        "month": values[0],
        "physical": values[1] or 0,
        "accredited": values[2] or 0,
        "computable": values[3] or 0,
        "required": values[4] or 0,
        "extra": values[5] or 0,
        "deficit": values[6] or 0,
        "bankUsed": values[7] or 0,
        "net": values[8] or 0,
        "vacation": values[9] or 0,
        "sick": values[10] or 0,
        "paidLeave": values[11] or 0,
        "purpleWork": values[12] or 0,
        "incidents": values[13] or 0,
    })

output = "window.AUTHORITATIVE_MONTHS=" + json.dumps(records, ensure_ascii=False, separators=(",", ":")) + ";\n"
(ROOT / "authoritative-summary.js").write_text(output, encoding="utf-8")
print(f"{len(records)} meses validados exportados")
