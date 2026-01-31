import psutil
import datetime

def generate_system_report():
    report = {
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_info": psutil.virtual_memory()._asdict(),
        "disk_usage": psutil.disk_usage('/')._asdict(),
        "boot_time": datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")
    }

    report_file = "/home/samiullah/system_report.txt"
    with open(report_file, 'w') as f:
        for key, value in report.items():
            f.write(f"{key}: {value}\n")

    print(f"System report generated: {report_file}")


generate_system_report()
