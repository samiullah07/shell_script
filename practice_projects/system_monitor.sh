#!/bin/bash

LOG_FILE="/var/log/system_health.log"

# Color codes
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"  # No Color

timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_msg() {
  # Logs to file and echoes to screen
  local level="$1"
  local message="$2"
  echo "$(timestamp) [$level] $message" | tee -a "$LOG_FILE"
}




check_cpu() {
  # Use top in batch mode to get the idle percentage, then convert to usage
  cpu_idle=$(top -bn1 | awk '/Cpu\(s\)/ {print $8}' | cut -d'.' -f1)
  cpu_usage_int=$((100 - cpu_idle))

  if [ "$cpu_usage_int" -gt 90 ]; then
    color="$RED"
    level="CRITICAL"
  elif [ "$cpu_usage_int" -gt 80 ]; then
    color="$YELLOW"
    level="WARNING"
  else
    color="$GREEN"
    level="OK"
  fi

  msg="CPU usage: ${cpu_usage_int}%"
  echo -e "${color}${msg}${NC}"
  log_msg "$level" "$msg"
}


check_memory() {
  # Get memory usage percentage using 'free'
  mem_usage=$(free | awk '/Mem:/ {printf("%.0f", $3*100/$2)}')
  mem_usage_int=$mem_usage

  if [ "$mem_usage_int" -gt 90 ]; then
    color="$RED"
    level="CRITICAL"
  elif [ "$mem_usage_int" -gt 75 ]; then
    color="$YELLOW"
    level="WARNING"
  else
    color="$GREEN"
    level="OK"
  fi

  msg="Memory usage: ${mem_usage_int}%"
  echo -e "${color}${msg}${NC}"
  log_msg "$level" "$msg"
}


check_disk() {
  # Root filesystem usage percentage
  disk_usage=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')
  disk_usage_int=$disk_usage

  if [ "$disk_usage_int" -gt 95 ]; then
    color="$RED"
    level="CRITICAL"
  elif [ "$disk_usage_int" -gt 85 ]; then
    color="$YELLOW"
    level="WARNING"
  else
    color="$GREEN"
    level="OK"
  fi

  msg="Disk usage (/): ${disk_usage_int}%"
  echo -e "${color}${msg}${NC}"
  log_msg "$level" "$msg"
}


check_cpu
check_memory
check_disk
