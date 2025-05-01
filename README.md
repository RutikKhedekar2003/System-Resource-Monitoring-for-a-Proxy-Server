# System-Resource-Monitoring-for-a-Proxy-Server

---

This script provides real-time monitoring of system resources on an Ubuntu server. It displays various metrics, including CPU and memory usage, network statistics, disk usage, system load, memory usage, process details, and service statuses. The dashboard can be refreshed every few seconds and allows users to view specific sections of the dashboard using command-line switches.

## Features

- **Top 10 Applications**: Displays the top 10 applications consuming the most CPU and memory.
- **Network Monitoring**: Shows the number of concurrent connections, packet drops, and network traffic (MB in and out).
- **Disk Usage**: Displays disk space usage by mounted partitions and highlights partitions using more than 80% of disk space.
- **System Load**: Shows the current load average and a breakdown of CPU usage.
- **Memory Usage**: Displays total, used, and free memory, including swap memory usage.
- **Process Monitoring**: Lists the number of active processes and the top 5 processes by CPU and memory usage.
- **Service Monitoring**: Monitors the status of essential services like `sshd`, `nginx`, and `iptables`.

## Installation

To set up the environment on an EC2 Ubuntu instance, follow these steps:

1. **Update Package Lists**:
   ```bash
   sudo apt update
   ```

2. **Install Required Packages**:
   ```bash
   sudo apt install -y net-tools procps sysstat gawk
   ```

3. **Make the Script Executable**:
   - Save the script to a file, e.g., `monitor.sh`.
   - Make it executable with:
     ```bash
     chmod +x monitor.sh
     ```

## Usage

Run the script by executing the following command:

```bash
./monitor.sh
```

The script will display a full dashboard by default. You can also use command-line switches to view specific parts of the dashboard:

- **Display Top 10 Applications**:
  ```bash
  ./monitor.sh -c -m
  ```

- **Network Monitoring**:
  ```bash
  ./monitor.sh -n
  ```

- **Disk Usage**:
  ```bash
  ./monitor.sh -d
  ```

- **System Load**:
  ```bash
  ./monitor.sh -l
  ```

- **CPU & Memory Usage**:
  ```bash
  ./monitor.sh -u
  ```

- **Process Monitoring**:
  ```bash
  ./monitor.sh -a
  ```

- **Service Monitoring**:
  ```bash
  ./monitor.sh -s
  ```

## Example Output

When running `./monitor.sh -d`, you might see:

```
Disk Space Usage by Mounted Partitions:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       30G   25G   5G   84% /
...
Partitions Using More Than 80% of the Space:
/dev/sda1       30G   25G   5G   84% /
```

## Notes

- **Instance Type**: The script can run on a `t2.micro` instance, but monitor CPU and memory usage to ensure it meets your performance needs. If performance issues arise, consider upgrading to a larger instance type.
- **Script Refresh**: The script refreshes data every 5 seconds. Adjust the `REFRESH_INTERVAL` in the script if needed.
- **Visual Enhancement**: You can pipe the output into tools like `less` or redirect to log files for easier viewing or historical tracking.

## Troubleshooting

- **Script Errors**: Ensure all required packages are installed and that the script has execute permissions.
- **Permission Denied**: Use `chmod +x monitor.sh` if you encounter execution issues.
- **Missing Utilities**: Install any missing command-line tools like `net-tools`, `ss`, `awk`, etc.
- **Performance Issues**: Consider instance type limitations or increase refresh interval.

---

**Author**: Rutik Khedekar  
**Script Name**: `System Resource Monitoring for a Proxy Server'
