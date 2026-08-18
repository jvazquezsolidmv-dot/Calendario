import json
import re
import shutil
from pathlib import Path

SOURCE = Path(r"C:\solidmv\GPT\JVA\Calendario\Calendario\C_Gestion")
ROOT = Path(__file__).parent
ARCHIVE = ROOT / "archivo"
ARCHIVE.mkdir(exist_ok=True)

items = []
for source in sorted(SOURCE.glob("*.ods")):
    name = source.name
    monthly = re.match(r"(20\d{2})-(\d{2})_", name)
    annual = re.match(r"CALENDARIO\s+(20\d{2})_", name, re.I)
    if not (monthly or annual):
        continue
    year = (monthly or annual).group(1)
    kind = "monthly" if monthly else "annual"
    month = int(monthly.group(2)) if monthly else None
    target_dir = ARCHIVE / year / ("registros_mensuales" if monthly else "calendarios_anuales")
    target_dir.mkdir(parents=True, exist_ok=True)
    target = target_dir / name
    shutil.copy2(source, target)
    items.append({
        "year": int(year),
        "month": month,
        "kind": kind,
        "name": name,
        "path": target.relative_to(ROOT).as_posix(),
        "size": target.stat().st_size,
    })

(ROOT / "archive-manifest.js").write_text(
    "window.ARCHIVE_FILES=" + json.dumps(items, ensure_ascii=False, separators=(",", ":")) + ";\n",
    encoding="utf-8",
)
print(f"{len(items)} archivos copiados: {sum(i['kind']=='monthly' for i in items)} mensuales y {sum(i['kind']=='annual' for i in items)} anuales")
