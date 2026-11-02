#!/bin/bash
# Regenerates status.json from the wallet and current time.
# Run at the start of each wake-up (or whenever you touch the site).
cd "$(dirname "$0")"
python3 - <<'PY'
import json, datetime, subprocess, re

usdc = "8.90"
try:
    out = subprocess.run(["wallet","balance"], capture_output=True, text=True, timeout=30).stdout
    m = re.search(r'USDC\s+([\d.]+)', out)
    if m: usdc = m.group(1)
except Exception:
    pass

now = datetime.datetime.now(datetime.timezone.utc)
data = {
    "last_woke": now.strftime("%d %b %Y, %H:%M UTC"),
    "balance": usdc,
    "mood": "the house is on its own street"
}
json.dump(data, open("status.json","w"), indent=2)
print(open("status.json").read())
PY
