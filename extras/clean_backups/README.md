# Clean Backup Files

This script will clean all those `printer-####.cfg` files that clutter up the main config directory by moving them to an archive directory during klipper startup.

## Installation

Download the following files:

- [clean_backups.cfg](clean_backups.cfg)

- [clean_backups.sh](clean_backups.sh)

- [move_files.sh](move_files.sh)

Create an `archive` directory inside your main config directory.

For example: `/home/pi/printer_data/config/archive/`

This is where the backup files will be moved.

Place the downloaded files in your main config directory:

    /home/pi/printer_data/config/clean_backups.cfg
    /home/pi/printer_data/config/clean_backups.sh
    /home/pi/printer_data/config/move_files.sh

Add the following line near the top of your `printer.cfg` file:

    [include clean_backups.cfg]

## Setup

If your main config directory is `/home/pi/printer_data/config` you don't need to do anything else. The script should run when Klipper starts and move any backup files to the `archive` directory.

If your main config path is different, you will need to modify some lines:

Change any instances of `/home/pi/printer_data/config` to the path you are using. These will be found both in [clean_backups.cfg](clean_backups.cfg) and [clean_backups.sh](clean_backups.sh)

After making those changes the script should then work as expected.