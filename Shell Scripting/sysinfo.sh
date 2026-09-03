#!/usr/bin/env bash
# sysinfo.sh - print a quick summary of this machine, then save the full
# process list to a report file whose location the user chooses at runtime.
#
# Usage:
#   ./sysinfo.sh            interactive: prompts for directory and file name
#   ./sysinfo.sh -a         append to the report instead of overwriting it
#   ./sysinfo.sh -h         show this help
#
# Exit codes: 0 ok, 1 bad arguments, 2 could not write the report.

set -u   # error on unset variables; catches typos in variable names

append=false

while getopts ":ah" opt; do
  case "$opt" in
    a) append=true ;;
    h) sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: -$OPTARG (try -h)" >&2; exit 1 ;;
  esac
done

# ---------- gather facts into variables ----------
today=$(date "+%Y-%m-%d %H:%M:%S")
box=$(hostname)
me=$(whoami)
disk=$(df -h / | awk 'NR==2 {print $5 " used of " $2}')
proc_count=$(ps aux | awk 'NR>1' | wc -l | tr -d ' ')
uptime_str=$(uptime | sed 's/.*up /up /; s/,  *load.*//')

# ---------- print the summary ----------
echo "=== System summary ==="
printf '%-12s: %s\n' "Date"      "$today"
printf '%-12s: %s\n' "Host"      "$box"
printf '%-12s: %s\n' "User"      "$me"
printf '%-12s: %s\n' "Uptime"    "$uptime_str"
printf '%-12s: %s\n' "Root disk" "$disk"
printf '%-12s: %s\n' "Processes" "$proc_count running"
echo

echo "--- Disk usage (df -h) ---"
df -h
echo

echo "--- Top 10 processes by CPU ---"
ps aux | sort -rk 3 | head -n 10 | cut -c1-110
echo

# ---------- ask where to put the report ----------
read -r -p "Directory to save the report in [reports]: " report_dir
read -r -p "Report file name [processes-$(date +%Y%m%d-%H%M%S).txt]: " report_file

# fall back to defaults if the user just pressed Enter
report_dir=${report_dir:-reports}
report_file=${report_file:-processes-$(date +%Y%m%d-%H%M%S).txt}
report_path="$report_dir/$report_file"

# ---------- create the directory and file ----------
if ! mkdir -p "$report_dir"; then
  echo "could not create directory: $report_dir" >&2
  exit 2
fi
touch "$report_path" || { echo "could not create file: $report_path" >&2; exit 2; }

# ---------- redirect the process list into the file ----------
{
  echo "# process snapshot from $box at $today"
  ps aux
} | if $append; then cat >> "$report_path"; else cat > "$report_path"; fi

lines=$(wc -l < "$report_path" | tr -d ' ')
echo
echo "Saved $lines lines to $report_path$($append && echo ' (appended)')"
