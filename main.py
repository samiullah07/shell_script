import shutil
import os
import datetime

def backup_files(source, destination):
    today = datetime.date.today()
    backup_file_path = os.path.join(destination, f"backup_{today}")

    shutil.make_archive(
        backup_file_path,
        "gztar",
        root_dir=os.path.dirname(source),
        base_dir=os.path.basename(source)
    )

    print(f"Backup created: {backup_file_path}.tar.gz")

source = "/home/samiullah/index.py"
destination = "/home/samiullah/python_backup"

backup_files(source, destination)

