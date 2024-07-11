#!/bin/bash

print_system_info() {
    current_runtime=$(uptime -p)
    current_time=$(date '+%Y-%m-%d %H:%M:%S')

    disk_usage=$(df -h /)
    used_space=$(echo "$disk_usage" | awk 'NR==2 {print $3}')
    used_percent=$(echo "$disk_usage" | awk 'NR==2 {print $5}' | sed 's/%//')
    free_space=$(echo "$disk_usage" | awk 'NR==2 {print $4}')

    hostname=$(hostname)
    ip_address=$(hostname -I | awk '{print $1}')

    os_name=$(uname -s)
    os_version=$(uname -r)

    cpu_model=$(grep "model name" /proc/cpuinfo | head -n1 | awk -F: '{print $2}' | sed 's/^ *//')
    cpu_cores=$(grep -c '^processor' /proc/cpuinfo)

    memory_total=$(free -h | awk 'NR==2 {print $2}')
    memory_used=$(free -h | awk 'NR==2 {print $3}')

    html_output="
    <html>
    <head><title>Systeminformationen</title></head>
    <body>
    <h1>Systeminformationen für $hostname</h1>
    <p><strong>Timestamp:</strong> $current_time</p>
    <p><strong>Systemlaufzeit:</strong> $current_runtime</p>
    <h2>Speicherplatz</h2>
    <p><strong>Belegt:</strong> $used_space</p>
    <p><strong>Frei:</strong> $free_space</p>
    <h2>Netzwerk</h2>
    <p><strong>Hostname:</strong> $hostname</p>
    <p><strong>IP-Adresse:</strong> $ip_address</p>
    <h2>System</h2>
    <p><strong>Betriebssystem:</strong> $os_name $os_version</p>
    <p><strong>CPU Modell:</strong> $cpu_model</p>
    <p><strong>Anzahl Cores:</strong> $cpu_cores</p>
    <h2>Arbeitsspeicher</h2>
    <p><strong>Gesamt:</strong> $memory_total</p>
    <p><strong>Genutzt:</strong> $memory_used</p>
    </body>
    </html>
    "

    echo "$html_output" > /home/lbraendli/index.html

    echo "Speicherplatz belegt: $used_space, Speicherplatz in Prozent: $used_percent"

    if [ "$used_percent" -gt 80 ]; then
        echo "Warnung: Speicherplatz knapp. Belegt: $used_space ($used_percent%). Eine E-Mail wird gesendet."
        echo "Der Speicherplatz auf dem System $hostname ist knapp. Belegt: $used_space ($used_percent%)." | mail -s "Speicherplatz-Warnung" amirgholamsakhi@gmail.com
        echo "Warn-E-Mail (über sendmail) an amirgholamsakhi@gmail.com verschickt."
    fi
}

print_system_info