#!/bin/bash
# This script is used to patch the stock Klipper install with the testing KAMP fork
cd ~
git clone -b for/master/adaptive_bed_mesh https://github.com/voidtrance/klipper.git kamp-klipper
cd kamp-klipper
mkdir ~/stock_klipper_files
mv ~/klipper/klippy/extras/bed_mesh.py ~/stock_klipper_files/bed_mesh.py
cd ~/kamp_klipper
ln -sr klippy/extras/bed_mesh.py ~/klipper/klippy/extras/
