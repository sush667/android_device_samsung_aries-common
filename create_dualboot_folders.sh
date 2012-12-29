#!/system/bin/sh
#
#
PATH=/system/bin/:/system/xbin/

# Programs needed
CAT="busybox cat"
CUT="busybox cut"
EGREP="busybox egrep"
GREP="busybox grep"
MV="busybox mv"
SED="busybox sed"
TEST="busybox test"
MKDIR="busybox mkdir -p"
ROM=`$CAT /data/dualboot/rom`
PREVIOUS_BOOT=`$CAT /cache/.previous_boot`

exec >>/data/dualboot/dualboot_Setup.log
exec 2>&1

set -x

cd datadata
for package in com.android.* ; do
cd /
if $TEST "$PREVIOUS_BOOT" = "$ROM" && $TEST "$package" != "com.android.providers.*"; then
	if ! $TEST -e /datadata/$ROM/$package ; then
	OWNER="`ls -ld /datadata/$package/ | awk '{print $3}'`"
	$MKDIR /datadata/$ROM/$package
	busybox chown $OWNER.$OWNER /datadata/$ROM/$package
	$MV /datadata/$package/* /datadata/$ROM/$package/
	fi
fi

mount -o bind /datadata/$ROM/$package /datadata/$package 
done
echo "$ROM" > /cache/.previous_boot
