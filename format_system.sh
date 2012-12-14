#!/tmp/busybox sh
#
#
BB=/tmp/busybox
# unmount and format system

$BB umount -l /system
if $BB grep -q /dev/lvpool/system /etc/fstab ; then
	/tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system /dev/lvpool/system
elif $BB grep -q /dev/lvpool/secondary_system /etc/fstab ; then
	/tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /system /dev/lvpool/secondary_system
else
	echo "no system partition specified"
	exit 1
fi
exit 0
