#!/sbin/sh
# Install SuperSU in the specified mode

TMP=/tmp/nethunter

. $TMP/env.sh

console=$(cat /tmp/console)
[ "$console" ] || console=/proc/$$/fd/1

print() {
	echo "ui_print - $1" > $console
	echo
}

sutmp=$1
supersu=$2

if [ "$supersu" = "systemless" ]; then
	print "Installing SuperSU in systemless mode"
	cat <<EOF > "/system/.supersu"
SYSTEMLESS=true
EOF
elif [ "$supersu" = "system" ]; then
	if [ ! -d "$TMP/boot-patcher/patch.d" ]; then
		print "Skipping SuperSU (unable to patch sepolicy)"
		exit 1
	fi
	print "Installing SuperSU in system mode"
	cat <<EOF > "/system/.supersu"
SYSTEMLESS=false
PATCHBOOTIMAGE=false
EOF
else
	print "Installing SuperSU in automatic mode"
	cat <<EOF > "/system/.supersu"
SYSTEMLESS=detect
EOF
fi

sh "$sutmp/META-INF/com/google/android/update-binary" dummy 1 "$TMP/supersu.zip"
