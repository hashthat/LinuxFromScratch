# lfs_12
# StartUp Command
qemu-system-x86_64 -m 2G -smp 2 -drive file=~/lfs-build/lfs-disk.img,format=raw,if=ide -nographic

Note: path is local to this machine, adjust as needed.
The disk image itself is not tracked in this repo (~20GB, lives only in ~/lfs-build/).
If it's ever lost, rebuild it with jhalfs using boot/config-6.4.12 and the scripts in this repo.


https://mags.zone/help/arch-usb-intro.html
https://wiki.archlinux.org/title/Chroot
