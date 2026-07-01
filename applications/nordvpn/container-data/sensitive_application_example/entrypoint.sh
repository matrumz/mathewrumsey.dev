#!/bin/sh
set -e

STATUS_FILE=/usr/share/nginx/html/index.html
INTERVAL=30

# Detect VPN by checking for a WireGuard interface in the shared network namespace
has_wg_interface() {
  for iface in /sys/class/net/wg* /sys/class/net/nordlynx*; do
    [ -e "$iface" ] && return 0
  done
  return 1
}

update_status() {
  ip=$(wget -qO- --timeout=5 https://api.ipify.org 2>/dev/null || echo "")
  geo=$(wget -qO- --timeout=5 "https://ipinfo.io/${ip}/json" 2>/dev/null || echo "{}")
  country=$(printf '%s' "$geo" | sed -n 's/.*"country" *: *"\([^"]*\)".*/\1/p')
  city=$(printf '%s' "$geo" | sed -n 's/.*"city" *: *"\([^"]*\)".*/\1/p')
  org=$(printf '%s' "$geo" | sed -n 's/.*"org" *: *"\([^"]*\)".*/\1/p')
  timestamp=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

  if [ -z "$ip" ]; then
    status="Disconnected"
    color="#f44336"
    icon="&#x26A0;"
  elif has_wg_interface; then
    status="Connected (VPN)"
    color="#4caf50"
    icon="&#x2705;"
  else
    status="Connected (no VPN)"
    color="#ff9800"
    icon="&#x26A0;"
  fi

  cat > "$STATUS_FILE" <<ENDHTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="refresh" content="$INTERVAL">
  <title>VPN Status</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #1a1a2e; color: #eee; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
    .card { background: #16213e; border-radius: 12px; padding: 2rem; max-width: 420px; width: 90%; box-shadow: 0 4px 24px rgba(0,0,0,0.4); }
    .card h1 { font-size: 1.5rem; margin-bottom: 1.5rem; text-align: center; }
    .status { font-size: 1.2rem; font-weight: 600; color: ${color}; text-align: center; margin-bottom: 1.5rem; }
    .details { list-style: none; }
    .details li { padding: 0.6rem 0; border-bottom: 1px solid #2a2a4a; display: flex; justify-content: space-between; }
    .details li:last-child { border-bottom: none; }
    .label { color: #888; }
    .value { font-family: "SF Mono", Monaco, "Cascadia Code", monospace; }
    .footer { text-align: center; margin-top: 1.5rem; font-size: 0.8rem; color: #555; }
  </style>
</head>
<body>
  <div class="card">
    <h1>${icon} VPN Status</h1>
    <div class="status">${status}</div>
    <ul class="details">
      <li><span class="label">Public IP</span><span class="value">${ip:-N/A}</span></li>
      <li><span class="label">City</span><span class="value">${city:-N/A}</span></li>
      <li><span class="label">Country</span><span class="value">${country:-N/A}</span></li>
      <li><span class="label">ISP / Org</span><span class="value">${org:-N/A}</span></li>
    </ul>
    <div class="footer">Last checked: ${timestamp} &middot; Refreshes every ${INTERVAL}s</div>
  </div>
</body>
</html>
ENDHTML
}

# Initial check
update_status

# Periodic refresh in background
while true; do
  sleep "$INTERVAL"
  update_status
done &

# Start nginx in foreground
exec nginx -g 'daemon off;'
