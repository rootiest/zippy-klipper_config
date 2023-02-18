# Clean Backup Files

This script will clean all those `printer-####.cfg` files that clutter up the main config directory by moving them to an archive directory during klipper startup.

# Contents

- [Clean Backup Files](#clean-backup-files)
- [Contents](#contents)
- [Installation](#installation)
- [Setup](#setup)
- [Changelog](#changelog)
  - [v1.2.5 2023-02-17](#v125-2023-02-17)
  - [v1.2.0 2023-02-15](#v120-2023-02-15)
  - [v1.1.0 2023-02-15](#v110-2023-02-15)
  - [v1.0.0 2023-02-14](#v100-2023-02-14)

# Installation

Download the following files:

- [clean_backups.cfg](clean_backups.cfg)

- [clean_backups.sh](clean_backups.sh)

- [move_files.sh](move_files.sh)

Place the downloaded files in your main config directory:

    /home/pi/printer_data/config/clean_backups.cfg
    /home/pi/printer_data/config/clean_backups.sh
    /home/pi/printer_data/config/move_files.sh

Add the following line near the top of your `printer.cfg` file:

    [include clean_backups.cfg]

Make the move_files.sh script executable:

From SSH, run the following:

    chmod +x /home/pi/printer_data/config/move_files.sh

You may need to adjust that path if your config files are not stored in `/home/pi/printer_data/config`.

# Setup

If your main config directory is `/home/pi/printer_data/config` you don't need to do anything else. The script should run when Klipper starts and move any backup files to the `archive` directory.

If your main config path is different, you will need to modify some lines:

Change any instances of `/home/pi/printer_data/config` to the path you are using. These will be found both in [clean_backups.cfg](clean_backups.cfg) and [clean_backups.sh](clean_backups.sh)

After making those changes the script should then work as expected.

# Changelog

## v1.2.5 2023-02-17

- Use a better (more specific) regex pattern to match the backup files.

## v1.2.0 2023-02-15

- Fixed a bug where already-moved files would try to move again to the same directory.

## v1.1.0 2023-02-15

- Simplify the scripts to just run from the main config directory instead of using a scripts directory.
- Create the destination directory if it doesn't exist

## v1.0.0 2023-02-14

- Initial Release