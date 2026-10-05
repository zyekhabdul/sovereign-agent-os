#!/usr/bin/env bash
# Sovereign Tmux High-Density Status Probe
# Zero external dependencies; reads directly from /proc & df

# 1. CPU (Instant sample from /proc/stat)
read -r _ u n s i io irq sirq st _ < /proc/stat
prev_total=$((u + n + s + i + io + irq + sirq + st))
prev_idle=$((i + io))
sleep 0.1
read -r _ u n s i io irq sirq st _ < /proc/stat
total=$((u + n + s + i + io + irq + sirq + st))
idle=$((i + io))
diff_total=$((total - prev_total))
diff_idle=$((idle - prev_idle))
cpu_pct=0
[ "$diff_total" -gt 0 ] && cpu_pct=$(( ((diff_total - diff_idle) * 100) / diff_total ))

# 2. RAM & SWAP
mem_total=0; mem_avail=0; swap_total=0; swap_free=0
while read -r key val _; do
    case "$key" in
        MemTotal:) mem_total=$val ;;
        MemAvailable:) mem_avail=$val ;;
        SwapTotal:) swap_total=$val ;;
        SwapFree:) swap_free=$val ;;
    esac
done < /proc/meminfo

mem_used=$((mem_total - mem_avail))
mem_pct=0
[ "$mem_total" -gt 0 ] && mem_pct=$(( (mem_used * 100) / mem_total ))
mem_used_g=$(awk "BEGIN {printf \"%.1f\", $mem_used/1048576}")
mem_total_g=$(awk "BEGIN {printf \"%.1f\", $mem_total/1048576}")

swap_str="0%"
if [ "$swap_total" -gt 0 ]; then
    swap_used=$((swap_total - swap_free))
    swap_pct=$(( (swap_used * 100) / swap_total ))
    swap_str="${swap_pct}%"
else
    swap_str="-"
fi

# 3. DISK (Root partition)
disk_pct=$(df -h / 2>/dev/null | awk "NR==2 {print \$5}")

# 4. LOAD & UPTIME
read -r load_1m _ _ < /proc/loadavg
uptime_str=$(awk "{d=int(\$1/86400); h=int((\$1%86400)/3600); if(d>0) printf \"%dd%dh\", d, h; else printf \"%dh\", h}" /proc/uptime)

# 5. DOCKER CONTAINERS
docker_str=""
if command -v docker >/dev/null 2>&1; then
    d_count=$(docker ps -q 2>/dev/null | wc -l)
    [ "$d_count" -gt 0 ] && docker_str=" #[fg=#666666]│ #[fg=#ffffff]DOC ${d_count}"
fi

# Monochrome High-Density Output
echo -n "#[fg=#ffffff,bg=#262626,bold] CPU ${cpu_pct}% #[default] \
#[fg=#666666]│ #[fg=#ffffff]RAM ${mem_used_g}/${mem_total_g}G (${mem_pct}%) \
#[fg=#666666]│ #[fg=#8a8a8a]SWAP ${swap_str} \
#[fg=#666666]│ #[fg=#ffffff]DISK ${disk_pct} \
#[fg=#666666]│ #[fg=#8a8a8a]LOAD ${load_1m}${docker_str} \
#[fg=#666666]│ #[fg=#8a8a8a]UP ${uptime_str} #[default]"
