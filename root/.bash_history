patch -Np1 -i ../kbd-2.6.1-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make check
make install
cp -R -v docs/doc -T /usr/share/doc/kbd-2.6.1
cd ..
rm -Rf kbd-2.6.1
tar -xvf libpipeline-1.5.7.tar.gz 
cd libpipeline-1.5.7
./configure --prefix=/usr
make
make check
make install
cd ..
rm -Rf libpipeline-1.5.7
tar -xvf make-4.4.1.tar.gz 
cd make-4.4.1
./configure --prefix=/usr
make
chown -Rv tester .
su tester -c "PATH=$PATH make check"
make install
cd ..
rm -Rf make-4.4.1
tar -xvf patch-2.7.6.tar.xz 
cd patch-2.7.6
./configure --prefix=/usr
make
make install
cd ..
rm -Rf patch-2.7.6
tar -xvf tar-1.35.tar.xz 
cd tar-1.35
FORCE_UNSAFE_CONFIGURE=1  ./configure --prefix=/usr
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35
cd ..
rm -Rf tar-1.35
tar -xvf texinfo-7.0.3.tar.xz 
cd texinfo-7.0.3
./configure --prefix=/usr
make
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *;     do install-info $f dir 2>/dev/null;   done
popd
cd ..
rm -Rf texinfo-7.0.3
tar -xvf vim-9.0.1677.tar.gz 
cd vim-9.0.1677
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do     ln -sv vim.1 $(dirname $L)/vi.1; done
ln -sv ../vim/vim90/doc /usr/share/doc/vim-9.0.1677
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

vim -c ':options'
cd ..
rm -Rf vim-9.0.1677
ls
tar -xvf Python-3.11.4.tar.xz 
rm -Rf Python-3.11.4
tar -xvf MarkupSafe-2.1.3.tar.gz 
cd MarkupSafe-2.1.3
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Markupsafe
cd ..
rm -Rf MarkupSafe-2.1.3
ls
tar -xvf Jinja2-3.1.2.tar.gz 
cd Jinja2-3.1.2
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2
cd ..
rm -Rf Jinja2-3.1.2
tar -xvf systemd-254.tar.gz 
cd systemd-254
sed -i -e 's/GROUP="render"/GROUP="video"/'        -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
sed '/systemd-sysctl/s/^/#/' -i rules.d/99-systemd.rules.in
mkdir -p build
cd       build
meson setup       --prefix=/usr                       --buildtype=release                 -Dmode=release                      -Ddev-kvm-mode=0660                 -Dlink-udev-shared=false            ..
ninja udevadm systemd-hwdb       $(grep -o -E "^build (src/libudev|src/udev|rules.d|hwdb.d)[^:]*" \
        build.ninja | awk '{ print $2 }')                                    $(realpath libudev.so --relative-to .)
rm rules.d/90-vconsole.rules
install -vm755 -d {/usr/lib,/etc}/udev/{hwdb,rules}.d
install -vm755 -d /usr/{lib,share}/pkgconfig
install -vm755 udevadm                     /usr/bin/
install -vm755 systemd-hwdb                /usr/bin/udev-hwdb
ln      -svfn  ../bin/udevadm              /usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}         /usr/lib/
install -vm644 ../src/libudev/libudev.h    /usr/include/
install -vm644 src/libudev/*.pc            /usr/lib/pkgconfig/
install -vm644 src/udev/*.pc               /usr/share/pkgconfig/
install -vm644 ../src/udev/udev.conf       /etc/udev/
install -vm644 rules.d/* ../rules.d/{*.rules,README} /usr/lib/udev/rules.d/
install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README}   /usr/lib/udev/hwdb.d/
install -vm755 $(find src/udev -type f | grep -F -v ".") /usr/lib/udev
tar -xvf ../../udev-lfs-20230818.tar.xz
make -f udev-lfs-20230818/Makefile.lfs install
tar -xf ../../systemd-man-pages-254.tar.xz                                --no-same-owner --strip-components=1                                  -C /usr/share/man --wildcards '*/udev*' '*/libudev*'                                                '*/systemd-'{hwdb,udevd.service}.8
sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8                                  > /usr/share/man/man8/udev-hwdb.8
sed 's|lib.*udevd|sbin/udevd|'                                            /usr/share/man/man8/systemd-udevd.service.8                         > /usr/share/man/man8/udevd.8
rm  /usr/share/man/man8/systemd-*.8
udev-hwdb update
cd ..
cd ..
rm -Rf systemd-254
tar -xvf man-db-2.11.2.tar.xz 
cd man-db-2.11.2
./configure --prefix=/usr                                     --docdir=/usr/share/doc/man-db-2.11.2             --sysconfdir=/etc                                 --disable-setuid                                  --enable-cache-owner=bin                          --with-browser=/usr/bin/lynx                      --with-vgrind=/usr/bin/vgrind                     --with-grap=/usr/bin/grap                         --with-systemdtmpfilesdir=                        --with-systemdsystemunitdir=
make
make install
cd ..
rm -Rf man-db-2.11.2
tar -xvf procps-ng-4.0.3.tar.xz 
cd procps-ng-4.0.3
./configure --prefix=/usr                                       --docdir=/usr/share/doc/procps-ng-4.0.3             --disable-static                                    --disable-kill
make
make install
cd ..
rm -Rf procps-ng-4.0.3
tar -xvf util-linux-2.39.1.tar.xz 
cd util-linux-2.39.1
sed -i '/test_mkfds/s/^/#/' tests/helpers/Makemodule.am
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime             --bindir=/usr/bin                --libdir=/usr/lib                --runstatedir=/run               --sbindir=/usr/sbin              --disable-chfn-chsh              --disable-login                  --disable-nologin                --disable-su                     --disable-setpriv                --disable-runuser                --disable-pylibmount             --disable-static                 --without-python                 --without-systemd                --without-systemdsystemunitdir             --docdir=/usr/share/doc/util-linux-2.39.1
make
make install
cd ..
rm -Rf util-linux-2.39.1
tar -xvf e2fsprogs-1.47.0.tar.gz 
cd e2fsprogs-1.47.0
mkdir -v build
cd       build
../configure --prefix=/usr                        --sysconfdir=/etc                    --enable-elf-shlibs                  --disable-libblkid                   --disable-libuuid                    --disable-uuidd                      --disable-fsck
make
make install
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf
cd ../..
rm -Rf e2fsprogs-1.47.0
tar -xvf sysklogd-1.5.1.tar.gz 
cd sysklogd-1.5.1
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
make
make BINDIR=/sbin install
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF

cd ..
rm -Rf sysklogd-1.5.1
tar -xvf sysvinit-3.07.tar.xz 
cd sysvinit-3.07
patch -Np1 -i ../sysvinit-3.07-consolidated-1.patch
make
make install
cd ..
rm -Rf sysvinit-3.07
df -h
df -h
save_usrlib="$(cd /usr/lib; ls ld-linux*[^g])
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.32
             libitm.so.1.0.0
             libatomic.so.1.2.0"
cd /usr/lib
for LIB in $save_usrlib; do     objcopy --only-keep-debug $LIB $LIB.dbg;     cp $LIB /tmp/$LIB;     strip --strip-unneeded /tmp/$LIB;     objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB;     install -vm755 /tmp/$LIB /usr/lib;     rm /tmp/$LIB; done
online_usrbin="bash find strip"
online_usrlib="libbfd-2.41.so
               libsframe.so.1.0.0
               libhistory.so.8.2
               libncursesw.so.6.4
               libm.so.6
               libreadline.so.8.2
               libz.so.1.2.13
               $(cd /usr/lib; find libnss*.so* -type f)"
for BIN in $online_usrbin; do     cp /usr/bin/$BIN /tmp/$BIN;     strip --strip-unneeded /tmp/$BIN;     install -vm755 /tmp/$BIN /usr/bin;     rm /tmp/$BIN; done
for LIB in $online_usrlib; do     cp /usr/lib/$LIB /tmp/$LIB;     strip --strip-unneeded /tmp/$LIB;     install -vm755 /tmp/$LIB /usr/lib;     rm /tmp/$LIB; done
for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg)          $(find /usr/lib -type f -name \*.a)                          $(find /usr/{bin,sbin,libexec} -type f); do     case "$online_usrbin $online_usrlib $save_usrlib" in         *$(basename $i)* )             ;;         * ) strip --strip-unneeded $i;             ;;     esac; done
unset BIN LIB save_usrlib online_usrbin online_usrlib
rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester
cd $LFS/sources/
tar -xvf Python-3.11.4.tar.xz 
cd Python-3.11.4
./configure --prefix=/usr                    --enable-shared                  --with-system-expat              --with-system-ffi                --enable-optimizations
make
cd ..
rm -Rf Python-3.11.4
tar -xvf lfs-bootscripts-20230728.tar.xz 
cd lfs-bootscripts-20230728
make install
cd ..
rm -Rf lfs-bootscripts-20230728
bash /usr/lib/udev/init-net-rules.sh
cat /etc/udev/rules.d/70-persistent-net.rules
cd /etc/sysconfig/
cat > ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF

ls
vi ifconfig.eth0 
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain <Your Domain Name>
nameserver <IP address of your primary nameserver>
nameserver <IP address of your secondary nameserver>

# End /etc/resolv.conf
EOF

ls
cd ..
ls
vi resolv.conf 
echo "lfs_12.0" > /etc/hostname
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
127.0.1.1 <FQDN> <HOSTNAME>
<192.168.1.1> <FQDN> <HOSTNAME> [alias1] [alias2 ...]
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF

ls
vi hosts 
cat hostname 
cat host
cat hosts
vi hostname 
vi hosts
cat hostname 
cat hosts
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

ls
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

KEYMAP="pl2"
FONT="lat2a-16 -m 8859-2"

# End /etc/sysconfig/console
EOF

cd sysconfig/
vi console 
local -a
ls
vi rc.site 
locale -a
LC_ALL=en_US locale charmap
LC_ALL=en_US locale language
LC_ALL=en_US locale charmap
LC_ALL=en_US locale int_curr_symbol
LC_ALL=en_US locale int_prefix
cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=en_US.ISO-8859-1

# End /etc/profile
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point    type     options             dump  fsck
#                                                                order

/dev/<xxx>     /              <fff>    defaults            1     1
/dev/<yyy>     swap           swap     pri=1               0     0
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOF

cd ..
vi fstab 
blkid /dev/sda
blkid /dev/sda1
fdisk /dev/sda
blkid /dev/sda1
blkid /dev/sda2
ls
vi fstab 
vi fstab 
cd ..
cd $LFS
ls
cd ..
ls
cd sources/
tar -xvf linux-6.4.12.tar.xz 
cd linux-6.4.12
make mrproper
make menuconfig
make menuconfig
make menuconfig
make
make modules_install
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.4.12-lfs-12.0
cp -iv System.map /boot/System.map-6.4.12
cp -iv .config /boot/config-6.4.12
cp -r Documentation -T /usr/share/doc/linux-6.4.12
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

mount /boot
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.4.12-lfs-12.0
cp -iv .config /boot/config-6.4.12
cp -r Documentation -T /usr/share/doc/linux-6.4.12
cd ..
grub-install /dev/sda
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod part_gpt
insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 6.4.12-lfs-12.0" {
        linux   /boot/vmlinuz-6.4.12-lfs-12.0 root=/dev/sda2 ro
}
EOF

cd ..
ls
cd boot/grub
ls
vi grub.cfg 
lsblk -o UUID,PARTUUID,PATH,MOUNTPOINT
logout
