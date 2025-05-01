#!binbash

# ===========================
# Author   : Rutik Khedekar
# Script   : Proxy Server Resource Monitoring Dashboard
# ===========================

# Display title and author at the beginning
function show_header() {
    clear
    echo "==============================================================="
    echo "        🔍 Proxy Server Resource Monitoring Dashboard"
    echo "        👨‍💻 Created by: Rutik Khedekar"
    echo "        📅 Date: $(date)"
    echo "==============================================================="
    echo
}



# Function to display the top 10 applications by CPU and memory usage
function top_apps() {
    echo ========== Top 10 Applications by CPU and Memory Usage ==========
    ps -eo pid,comm,%mem,%cpu --sort=-%cpu  head -n 11
    echo
}

# Function to monitor network connections, packet drops, and traffic
function network_monitor() {
    echo ==================== Network Monitoring ====================
    echo -n Active TCP Connections 
    netstat -tun  grep ESTABLISHED  wc -l

    echo Packet Drops by Interface
    netstat -i  grep -v 'Iface'  awk '{print $1   $4  packets dropped}'

    echo Network Traffic (MB In  MB Out)
    ifconfig  grep -A 1 'enp'  awk '
        RX packets {printf Received %.2f MBn, $310241024}
        TX packets {printf Transmitted %.2f MBn, $710241024}
    '
    echo
}

# Function to monitor disk usage, highlighting high usage
function disk_usage() {
    echo ===================== Disk Usage =====================
    df -h  grep -vE '^Filesystemtmpfscdrom'  while read -r line; do
        usage=$(echo $line  awk '{print $5}'  tr -d '%')
        if [ $usage -ge 80 ]; then
            echo -e 033[31m$line  -- High Usage033[0m
        else
            echo $line
        fi
    done
    echo
}

# Function to display system load and CPU breakdown
function system_load() {
    echo ===================== System Load & CPU =====================
    echo -n Current Load Average 
    uptime  awk -F'load average' '{print $2}'  sed 's^ '

    echo -n CPU Usage 
    if command -v mpstat  devnull; then
        mpstat  awk '$3 ~ [0-9.]+ {print User  $4 %, System  $6 %, Idle  $12 %}'
    else
        top -bn1  grep Cpu(s)  awk '{print User  $2 %, System  $4 %, Idle  $8 %}'
    fi
    echo
}

# Function to display memory and swap usage
function memory_usage() {
    echo ===================== Memory & Swap Usage =====================
    free -h  awk 'NR==2{printf Memory - Total %s  Used %s  Free %sn, $2,$3,$4}'
    free -h  awk 'NR==3{printf Swap   - Total %s  Used %s  Free %sn, $2,$3,$4}'
    echo
}

# Function to display active processes and top resource consumers
function process_monitor() {
    echo ===================== Process Monitoring =====================
    echo -n Total Active Processes 
    ps aux  wc -l

    echo Top 5 Processes by CPU and Memory
    ps -eo pid,comm,%mem,%cpu --sort=-%cpu  head -n 6
    echo
}

# Function to monitor essential services
function service_monitor() {
    echo ===================== Service Monitoring =====================
    for service in sshd nginx iptables; do
        if systemctl is-active --quiet $service; then
            echo $service is running ✅
        else
            echo $service is NOT running ❌
        fi
    done
    echo
}

# Function to display the full dashboard
function full_dashboard() {
    show_header
    top_apps
    network_monitor
    disk_usage
    system_load
    memory_usage
    process_monitor
    service_monitor
}


# Main script loop for continuous monitoring
while true; do
    case $1 in
        -top)
            top_apps
            ;;
        -network)
            network_monitor
            ;;
        -disk)
            disk_usage
            ;;
        -load)
            system_load
            ;;
        -memory)
            memory_usage
            ;;
        -process)
            process_monitor
            ;;
        -services)
            service_monitor
            ;;
        *)
            full_dashboard
            ;;
    esac
    sleep 5
done
